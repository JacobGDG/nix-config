# Session 3 — Requirements Clarification Questions

Please answer each question by filling in the letter choice after the `[Answer]:` tag.
If none of the options match, choose the last option (Other) and describe your preference.
Let me know when you're done.

---

## Question 1 — devops: kubernetes sub-feature
Should the kubernetes toolset (kubectl, k9s, kubectx, kustomize, cmctl, kubernetes-helm) be enabled for erebor?

A) Yes — enable kubernetes tools
B) No — skip kubernetes tools
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2 — devops: terraform sub-feature
Should the terraform toolset (tenv, tflint) be enabled for erebor?

A) Yes — enable terraform tools
B) No — skip terraform tools
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 3 — devops: aws sub-feature
Should the AWS toolset (aws-sso-util) be enabled for erebor?

A) Yes — enable AWS tools
B) No — skip AWS tools
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 4 — devops: certificates sub-feature
Should the certificates toolset (step-cli) be enabled for erebor?

A) Yes — enable step-cli
B) No — skip certificates tools
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 5 — firefox NixOS module
The source `modules/nixos/firefox.nix` contains system-level Firefox policies (telemetry, extensions, content blocking). Should this be imported into erebor's NixOS config alongside the HM firefox profile?

A) Yes — import both NixOS policies module and HM profile module
B) No — import only the HM profile module (skip NixOS policies)
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 6 — Module naming / placement
The new repo uses `flake.modules.homeManager.<name>` for all HM modules (e.g. `git`, `tmux`, `neovim`). The source devops/mpv/ai-agents modules use a `myModules.*` options pattern with enable flags. How should devops be ported?

A) Preserve the `myModules.devops` options pattern (sub-feature toggles remain, enabled via host config)
B) Flatten to a single module with all selected packages always included (no options)
C) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 7 — Security Extension
Should security extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade applications)
B) No — skip all SECURITY rules (suitable for PoCs, prototypes, and experimental projects)
C) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 8 — Property-Based Testing Extension
Should property-based testing (PBT) rules be enforced for this project?

A) Yes — enforce all PBT rules as blocking constraints
B) No — skip all PBT rules (suitable for Nix configuration with no algorithmic business logic)
C) Other (please describe after [Answer]: tag below)

[Answer]: B
