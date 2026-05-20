# Requirements Clarification Questions

Please answer each question by filling in the letter choice after the `[Answer]:` tag.
If none of the options match, choose the last option and describe your preference.
Let me know when done.

---

## Question 1: Config Scope

The source repo's erebor config includes the following common NixOS settings applied to ALL hosts.
Should all of these be ported into the new flake-parts `core` module?

- Networking: `networkmanager.enable = true`
- Audio: PipeWire (replacing PulseAudio)
- Printing: CUPS
- Removable media: udisks2
- SSH: openssh (disabled by default, hardened settings)
- Security: rtkit, polkit, polkit-gnome authentication agent (systemd service)

A) Yes — port all of the above into the `core` NixOS module (matches source config)
B) Minimal only — networking and audio only, skip printing/udisks2/polkit-gnome
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2: Nvidia

The source erebor config enables Nvidia drivers (`myModules.nixOS.nvidia.enable = true`).
The source used a reusable opt-in module. How should this be handled in the new config?

A) Add nvidia config directly to `modules/hosts/erebor/default.nix` (simple, no abstraction needed yet)
B) Create a reusable `modules/nixos/nvidia.nix` option module and enable it for erebor
C) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 3: nixpkgs.config.allowUnfree

The source config sets `nixpkgs.config.allowUnfree = true` globally. Should this be added to the core module?

A) Yes — add to `modules/core/settings.nix`
B) No — skip for now
C) Other (please describe after [Answer]: tag below)

[Answer]: C git@github.com:bivsk/nix-iv.git is a good source of inspiration
here. Specifically modules/flake/unfree.nix and
modules/nixos/desktop/gaming/steam.nix show how they manage it. again clone to
tmp to see it

---

## Question 4: Security Extension

Should Security Baseline extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade systems)
B) No — skip all SECURITY rules (suitable for home lab / personal config)
X) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 5: Property-Based Testing Extension

Should Property-Based Testing (PBT) rules be enforced for this project?

A) Yes — enforce all PBT rules as blocking constraints
B) No — skip all PBT rules (Nix config has no algorithmic business logic to test with PBT)
X) Other (please describe after [Answer]: tag below)

[Answer]: B
