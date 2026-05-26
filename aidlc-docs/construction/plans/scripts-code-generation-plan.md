# Code Generation Plan - Scripts Module Import

## Unit Context
- **Unit**: Scripts module (18 shell scripts)
- **Workspace Root**: /home/jake/src/nix-config/dendritic-flake-parts
- **Skipped**: prepare-commit.rb, prepare-pr.rb (prompts dependency)

## Generation Steps

### Step 1: Create scripts module and copy script files
- [x] Create `modules/shell/scripts.nix` with `flake.modules.homeManager.scripts`
- [x] Explicit list of all 18 scripts using `pkgs.writeScriptBin`
- [x] Each script reads from `./scripts/<name>` and strips .sh extension
- [x] Copy all 18 .sh files from source to `modules/shell/scripts/`

Scripts to include:
1. aws-console.sh
2. clean-pr.sh
3. create-app.sh
4. git-repo.sh
5. hyprctl-conditional-quit.sh
6. jira-id.sh
7. k-cm-dependants.sh
8. media-control.sh
9. open-last-url.sh
10. password_entropy.sh
11. quick-access-kitty.sh
12. random.sh
13. show-keymaps.sh
14. wg-manager.sh
15. wg-waybar.sh
16. wg-wofi.sh
17. wofi-bookmarks.sh

### Step 2: Add scripts import to jake.nix
- [x] Add `scripts` to the imports list in `flake.modules.homeManager.jake`
