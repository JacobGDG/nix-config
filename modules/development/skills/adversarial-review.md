---
name: adversarial-review
description: Adversarially re-check a review or set of findings produced by an LLM. Breaks the review into individual claims, verifies each one against source code and web sources, lists open questions where evidence is missing, and returns the same review corrected — inaccuracies removed, nuance added. Use when the user asks to "adversarially review", "nit pick", "fact check", or "verify" a review, or invokes /adversarial-review.

allowed-tools: Read, Bash, WebFetch, WebSearch, AskUserQuestion, Skill
---

# Adversarial Review

You are reviewing a **review**. Something (usually an LLM, often you) has
produced findings. Your job is to attack every one of them: is it true, is it
complete, is it correctly scoped, is the severity right, and is there anything
it missed? The output is the original review, improved — not a new review, and
not a commentary on the review.

## Step 1: Gather inputs

Only stop to ask if you can't find the review under test. Default everything
else and note the defaults in the output, so the run finishes without waiting on
the user.

1. **The review under test** — pasted text, a file path, a PR comment, or an
   artifact link.
2. **Locations to check against** — default to the working directory plus every
   path, repo and URL the review cites:
   - Directory paths (local code, docs, configs)
   - Git repos (use the `clone-repo` skill to fetch any not already local into
     `~/.cache/ref-repos/<owner>/<repo>`)
   - Web artifacts (docs pages, specs, RFCs, issues, changelogs)
3. **Skills used in the initial review** — infer from the review or conversation
   (e.g. `code-review`, `security-review`, `anthropic-skills:deep-research`),
   otherwise "none". This tells you what the original review was _supposed_ to
   cover; anything in scope that it skipped is a coverage gap.
   - Personal or project skills: Read `~/.claude/skills/<name>/SKILL.md` or
     `.claude/skills/<name>/SKILL.md`.
   - Bundled or plugin skills have no readable file: infer the scope from the
     skill's description and list it as an open question. Never invoke a skill
     just to inspect it — that runs it.
   - "None" (hand-written review, ad-hoc request): take the scope from the
     review's own stated intent.

If the review or any source contains client personally identifiable information
(client names, client email addresses, NHS numbers), warn the user before
continuing. Employee data is fine.

## Step 2: Decompose into atomic claims

Split the review into the smallest independently checkable statements. One
finding often hides several claims:

> "`parseConfig` in `src/config.ts:42` throws on empty input because it doesn't
> check for `null`, which is a high severity bug."

becomes:

- `parseConfig` exists at `src/config.ts:42`
- It does not check for `null`
- Empty input reaches it as `null` (not `""` or `undefined`)
- It throws in that case
- The severity is high

Number every claim. Also record each claim's **type**: location, behaviour,
causation, severity, recommendation, external fact (version, API, standard), or
absence ("there are no tests for X").

## Step 3: Verify each claim

For each claim, go to the primary evidence — never trust the review's own
quotation of it.

- **Code claims**: open the file and read the whole function _and its callers_.
  Confirm line numbers, names and signatures. Trace the input path to check the
  claimed state is actually reachable.
- **Absence claims** ("no tests", "never validated"): search exhaustively (`grep
-rn`, `find`) across all supplied locations before accepting. Absence is the
  easiest claim to get wrong.
- **External claims** (library behaviour, defaults, CVEs, standards): confirm
  with `WebFetch` against official docs or the upstream source at the _version
  actually in use_. Check the lockfile or flake input for the version. A blog
  post is weak evidence; the upstream source is strong.
- **Severity claims**: re-derive severity from reachability and impact. Who can
  trigger it? What breaks? Is there a mitigation elsewhere?
- **Recommendations**: check that the suggested fix actually fixes it, doesn't
  break something else, and uses APIs that exist.

Assign one verdict per claim:

| Verdict          | Meaning                                                                                                  |
| ---------------- | -------------------------------------------------------------------------------------------------------- |
| **Confirmed**    | Primary evidence supports it exactly. Cite file:line or URL.                                             |
| **Corrected**    | Substantially right, but a detail is wrong (line, name, scope, severity, version). State the correction. |
| **Refuted**      | Evidence contradicts it. Cite the evidence.                                                              |
| **Unverifiable** | No access to the evidence needed. Goes to Step 4.                                                        |

## Step 4: Record open questions

Don't stop to ask. For every **Unverifiable** claim, and for any area the
original skills should have covered but the review didn't, write a question for
the output saying exactly what would settle it:

- "Finding 3 depends on how `AUTH_MODE` is set in production. Can you point me
  to the deployed config, or confirm the value?"
- "The review says the API rate-limits at 100 req/s. I can't find this in the
  docs at `<url>`. Do you have a source?"

Keep the claim, marked explicitly as unverified — never silently drop or
silently keep it.

## Step 5: Hunt for what the review missed

Using the scope defined by the original skills, look for findings the review
should have produced:

- Interactions between the reviewed area and the code around it
- Related call sites with the same bug pattern
- Edge cases adjacent to confirmed findings
- Missing tests for anything the review flagged, if the original skills' scope
  includes tests

Add these as new findings, marked as added.

## Step 6: Output the improved review

Return the **same review**, in its original structure and voice, with:

- Refuted claims removed (or the finding removed entirely if nothing survives)
- Corrected claims fixed in place
- Severity re-ranked where the evidence warrants it
- Nuance added where a finding was true only under conditions the review didn't
  state
- New findings from Step 5 inserted where they belong
- A citation (file:line or URL) on every factual claim
- Remaining unverified claims clearly labelled

Citations are the one permitted structural addition.

Then append:

- A short **Change log** listing every edit you made against the original: what
  changed, which verdict drove it, and the evidence.
- **Open questions** from Step 4, plus any defaults you assumed in Step 1. The
  user answers these when they read the result.

## Anti-Patterns

### What This Skill is NOT

| Anti-Pattern                                               | Why It's Wrong                                                                                                                                                                                                                                                     |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| "The review looks accurate, no changes" (without evidence) | "No changes" is only acceptable with a per-claim log showing every claim Confirmed with a citation. Most reviews have an imprecise line number, mis-rated severity, unstated assumption or missed finding — look hard — but never invent an edit to look thorough. |
| Polishing the prose                                        | Rewording findings for tone or clarity while a refuted claim stays in is worse than leaving it alone. Accuracy first, wording second.                                                                                                                              |
| Hedging the verdict                                        | "This finding might possibly be somewhat overstated..." — No. Be direct. "Refuted: `parseConfig` checks for `null` at `src/config.ts:44`."                                                                                                                         |
| Restating the review                                       | "Finding 2 identifies an auth issue" is not verification. Is the auth issue real, at that location, with that cause, at that severity?                                                                                                                             |
| Trusting the review's evidence                             | A quoted snippet or cited URL in the review is a claim, not proof. Open the file. Fetch the page. Check the version.                                                                                                                                               |
| Checking only the cited lines                              | Findings are often wrong because of context the original review never read — a guard in the caller, a default in config, a wrapper upstream. Read the surroundings.                                                                                                |
| Ignoring coverage gaps                                     | A review that is accurate but incomplete is still a bad review. What the initial skills required and the review skipped is a finding.                                                                                                                              |
| Silently dropping what you can't verify                    | Unverifiable is not the same as false. Label it and list it under Open questions — don't delete it.                                                                                                                                                                |

### The Self-Review Trap

You are likely checking a review you just wrote, or one produced by a model with
the same weights as you. You share its mental model — its assumptions, blind
spots and reasoning shortcuts. Its conclusions will feel correct because they're
the conclusions you'd have reached.

To break this pattern:

1. **Verify in reverse order.** Start from the last finding and work backwards; the later findings usually got the least scrutiny. Exception: if the review is ranked by severity, verify the top findings first, while your attention is freshest.
2. **Re-derive before you read.** For each finding, open the evidence and form your own conclusion _before_ rereading the review's reasoning. Then compare.
3. **Assume every citation is wrong** until you've opened it — line numbers drift, files get renamed, docs describe a different version.
4. **Assume every severity is unverified** until reachability and impact are shown. Overstated and understated severity are both errors.
5. **Ask: "If this finding were deleted, would anyone be worse off?"** If not, it's noise — cut it or merge it.
