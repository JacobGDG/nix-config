# Session 6 - Scripts Module Import - Clarification Questions

The source scripts module dynamically discovers 20 shell/ruby scripts and wraps them as home packages.

## Question 1
Two ruby scripts (prepare-commit.rb, prepare-pr.rb) depend on `inputs.prompts` (git+ssh://git@github.com/JacobGDG/prompts.git). How should we handle this?

A) Add the prompts input to the flake and wire it through - scripts work as-is
B) Import the scripts but comment out / placeholder the prompt paths (can wire later)
C) Skip those two ruby scripts entirely
D) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 2
Three scripts (wg-manager.sh, wg-waybar.sh, wg-wofi.sh) are wireguard VPN management tools. Wireguard was skipped in session 5. Should these scripts be included?

A) Yes - include them (they'll be useful when wireguard is added later)
B) No - skip wireguard scripts
C) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3
Some scripts appear work-specific: aws-console.sh (Healios AWS portal), jira-id.sh (Jira ticket lookup), k-cm-dependants.sh (Kubernetes ConfigMap). Should these be included?

A) Yes - include all of them
B) No - skip work-specific scripts
C) Include some (specify which after [Answer]: tag below)
D) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4
Where should the scripts module live in the target repo?

A) modules/shell/scripts.nix (alongside zsh, tmux, starship)
B) modules/development/scripts.nix (alongside git, neovim)
C) modules/scripts.nix (top-level, since scripts span multiple categories)
D) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5
The source module uses dynamic script discovery (readDir + filter). Should the target follow the same pattern, or list scripts explicitly?

A) Dynamic discovery (same as source - scripts/ subdirectory auto-scanned)
B) Explicit list (each script referenced by name in the nix module)
C) Other (please describe after [Answer]: tag below)

[Answer]: B
