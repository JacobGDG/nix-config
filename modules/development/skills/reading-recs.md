---
name: reading-recs
description: Recommend recent articles the user is likely to enjoy, based on their Raindrop bookmarks. Scans what's being shared and discussed (Lobsters, Hacker News, the user's followed blogs) and returns a ranked list with raw links. Use when the user asks for reading recommendations, "find me something to read", "what's new that I'd like", or invokes /reading-recs.

allowed-tools: Read, Write, WebFetch, WebSearch, mcp__plugin_claude-code-home-manager_raindrop__find_collections, mcp__plugin_claude-code-home-manager_raindrop__find_bookmarks
---

# Reading Recommendations

Find recently published articles the user would want to read, using their
Raindrop bookmarks to work out their taste.

## Cache

The interest profile is cached at `~/.cache/reading-recs/profile.md`. The cache
lets later runs skip re-reading the whole Raindrop library. The file contains:

- Frontmatter with `updated` (ISO date), the IDs and roles of the collections
  used (see Step 1), and `latest_bookmark` (the `created` timestamp of the
  newest bookmark seen).
- **Themes** and **Followed sources** lists, as described in Step 1.
- **Bookmarks**: every saved URL with a one- or two-sentence note on what it
  covers and what saving it says about the user's taste. These notes are the
  main evidence for Themes, and the URLs double as the "already saved" list.
- **Recommended**: every URL recommended in earlier runs, with the date, so
  the same article isn't suggested twice.

Expand `~` to the user's home directory before reading or writing the file.
Everything personal lives in the cache, never in this skill.

## Step 1: Load or build the interest profile

Read the cache file first. If it doesn't exist, build the profile from
scratch (below). If it exists, call `find_bookmarks` sorted newest first with
`created.gte` set to the date part of `latest_bookmark`:

- If that call returns no bookmarks newer than `latest_bookmark` **and**
  `updated` is less than 30 days ago, use the cached profile as it is.
- If there are new bookmarks, write a note for each one (as in step 3 of
  "Building from scratch" below),
  add them to Bookmarks, adjust Themes and Followed sources if the new notes
  shift them, then update `latest_bookmark`.
- If `updated` is 30 days old or more, or the user asks for a refresh, rebuild
  the profile from scratch.

Building from scratch:

1. Call `find_collections` without arguments. Don't pass `search`, because
   semantic search fails on free Raindrop accounts. From the titles, pick out:
   - the **reading collection**(s), meaning saved articles the user enjoyed
     (titles like "Interesting", "Reading", "Articles")
   - the **blogs collection**, meaning blog homepages the user follows (titles
     like "Blogs", "Feeds")

   If the choice isn't clear from the titles, ask the user once and record
   the answer in the cache.
2. Call `find_bookmarks` once for each chosen collection, plus a further call
   across all collections, sorted newest first, to catch bookmarks saved
   elsewhere.
3. Annotate every bookmark. Read its content with `fetch_bookmark_content`,
   falling back to `WebFetch`, and write one or two sentences on what it
   covers and what saving it suggests about the user's taste (e.g. "prefers
   practical how-tos to theory", "likes contrarian takes on popular
   frameworks"). For blog homepages, describe the blog's usual topics and
   tone, and note its RSS/Atom feed if there is one. If a page can't be read,
   write the note from the title and mark it "(unread)". With more than about
   25 bookmarks, split them across parallel background subagents and ask each
   to return only `- <url> — <note>` lines, so the page contents stay out of
   the main context.
4. From the notes, write down:
   - **Themes**: recurring topics and the angle the user takes on each one
     (e.g. "<topic>, sceptical angle" or "<tool>, internals over tutorials").
     Give more weight to recently saved bookmarks and to the reading
     collection. Also list weak signals that shouldn't drive picks on their
     own.
   - **Followed sources**: the blog domains in the blogs collection (with
     feed URLs where found) and any domain that appears more than once.

Don't show the profile to the user unless they ask for it. Keep the
Recommended list from the old cache when rebuilding.

## Step 2: Gather candidates

The default window is the **last 7 days**. Use a different window if the user
gives one. Run these independent fetches and searches in parallel:

- `https://lobste.rs/top/1w`, to get each story's title, external URL, tags
  and score.
- `https://news.ycombinator.com/best`, to get titles and URLs.
- For each followed source, check its RSS/Atom feed (from the cache) or blog
  index for posts inside the window. Skip a source if it fails to load; don't
  retry it.
- One `WebSearch` per major theme, using `extended` mode, with the current
  month and year in the query (e.g. "<theme> blog post <Month> <Year>").

## Step 3: Filter and verify

1. Drop anything already in Bookmarks or Recommended, anything off-theme, and
   anything that is purely news or a release note, unless it ties closely to a
   theme.
2. For each remaining candidate (at most about 10), use `WebFetch` to confirm
   the **publication date** and get a two-sentence summary. Drop items that
   are clearly older than the window. Items a few days outside the window can
   stay if they're trending now; mark them as such.
3. If a page can't be fetched (403 or paywall), keep it only if the
   recommendation is strong, and say that it wasn't verified.

## Step 4: Output

Return between 5 and 10 picks, ranked by how well they fit the user's
interests, judged against the Bookmarks notes as well as Themes. Split them
into **Most likely to interest you** and **Also worth a look**.

**Write every link as a raw URL on its own line. Never use markdown link
syntax like `[text](url)`, because the user's terminal doesn't show those
links.** Format each pick like this:

```
1. <Title> — <Author/site>, <date>
   https://example.com/full/url
   <One or two sentences on what it is and why it fits, naming the related
   bookmark where one exists.>
```

Finish with a single-line offer to save any of the picks to the reading
collection. Don't save anything to Raindrop unless the user says yes.

## Step 5: Update the cache

Write the profile back to `~/.cache/reading-recs/profile.md`. Set `updated` to
today if the profile was rebuilt or merged, and append this run's picks to
Recommended. If the write fails (e.g. the sandbox blocks it), tell the user in
one line and carry on; the cache is an optimisation, not a requirement.
