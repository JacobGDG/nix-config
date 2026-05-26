# Session 5 - jake-linux-laptop Import - Clarification Questions

Most modules already exist from the erebor sessions. These questions focus on what's **different** for the laptop host.

## Question 1
The source jake-laptop-nixos enables a **battery** NixOS module (TLP, thermald, powertop, charge thresholds). Should a new battery module be created in the target?

A) Yes - create a battery module at modules/system/battery.nix (recommended for laptop)
B) No - skip battery management for now
C) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2
The source enables **wireguard** (home + public VPN) which depends on ragenix for encrypted secrets. Should wireguard be included?

A) Yes - create wireguard module and add ragenix input
B) No - skip wireguard for now (can be added later)
C) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 3
The source enables **homelab** modules (homer dashboard). Should homelab be included?

A) Yes - create homelab module(s)
B) No - skip homelab for now
C) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 4
Several small source modules don't exist in the target yet. Which should be imported? (Select all that apply, e.g. "A,C,D")

A) llm.nix - adds `pkgs.llm` CLI tool (trivial one-liner)
B) genealogy.nix - adds gramps + graphviz
C) sops.nix - adds sops, age, ssh-to-age packages
D) nix-update-app.nix - desktop entry for nix config updates
E) battery-warning-daemon.nix - systemd user service for low-battery notifications
F) None of these - keep scope to host files + battery module only
G) Other (please describe after [Answer]: tag below)

[Answer]: E

## Question 5
The source linux-base.nix includes additional packages not in the target erebor config: blender, prismlauncher, mumble, discord, rpi-imager, spotify. Should these be added to the jake-linux-laptop host?

A) Yes - add all of them to the host packages
B) Add some (specify which after [Answer]: tag)
C) No - keep packages matching erebor for now
D) Other (please describe after [Answer]: tag below)

[Answer]: A, not some of these are relavant to erebor given they live in
linux-base

## Question 6
Confirm the target hostname. The source uses "jake-laptop-nixos".

A) Use "jake-linux-laptop" (as you specified in your request)
B) Keep "jake-laptop-nixos" (match the source)
C) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 7
The source uses stateVersion "24.05". The target erebor uses "25.05". Which stateVersion for the new host?

A) Use "24.05" (match the source - preserves compatibility if migrating an existing install)
B) Use "25.05" (match erebor/target patterns)
C) Other (please describe after [Answer]: tag below)

[Answer]: A
