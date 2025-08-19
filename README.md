# My Nix config

My overkill dotfiles.

* https://search.nixos.org/packages
* https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/programs
* https://github.com/nix-community/home-manager/tree/master/modules/programs
* https://github.com/JacobGDG/wallpapers
* https://github.com/JacobGDG/nix-secrets \<_private_\>


# Why?

Simply putting my dotfiles into a git repo a few year ago opened up a lot of
potential for me. I enjoyed making tweaks over time and building my own bespoke
development space is very satisfying.

I can also easily lie to myself and say my constant tinkering is productive. "I
am learning."

So why not go further, and put packages into Git. NixOS and Home Manager make
that fun. I have been able to experiment much more with Linux in general without
worrying about breaking something beyond (my ability to) repair.

# Modules
* `hosts/`
    * Location for most of my home-manager setup. In future I hope to expand
      this to also include nixos
* `secrets/`
    * Secret declaration per system, including OS permissions on the files
      created. Secret values are stored, encrypted, in a separate and private
      repo
* `nixos/`
    * NixOS configuration. Currently only for a single device
* `modules/home-manager/`
    * Primary location for more complex home-manager package config
* `modules/nixos/`
    * Primary location for more complex NixOS package config
* `mylib/`
    * Helper functions, purposefully kept separate from nixos or home-manager
      lib
* `config/`
    * I like Lua and I like how Neovim is configured with Lua, this is my
      solution. It isn't fully declarative doesn't allow Nix rollbacks etc, but
      it works.
    * TLDR, disable Nix nvim config, symlink this directory to `~/.config/nvim`

## Components (for NixOs)

|                             | NixOS(Wayland)                    |
| --------------------------- | --------------------------------- |
| **Window Manager**          | [Hyprland][Hyprland]              |
| **Terminal Emulator**       | [Kitty][Kitty]                    |
| **Bar**                     | [Waybar][Waybar]                  |
| **Application Launcher**    | [Wofi][wofi]                      |
| **Notification Daemon**     | [Dunst][Dunst]                    |
| **Display Manager**         | [SDDM][SDDM]                      |
| **Color Scheme**            | Gruvbox                           |
| **network management tool** | [NetworkManager][NetworkManager]  |
| **System resource monitor** | [Btop][Btop]                      |
| **File Manager**            | [Neovim][Neovim] + [Dolphin][Dolphin] |
| **Shell**                   | ZSH + [P10k][P10k]                |
| **Media Player**            | [mpv][mpv]                        |
| **Text Editor**             | [Neovim][Neovim]                  |
| **Fonts**                   | [Nerd fonts][Nerd fonts]          |
| **Image Viewer**            |                                   |
| **Screenshot Software**     |                                   |
| **Screen Recording**        |                                   |



[Hyprland]: https://github.com/hyprwm/Hyprland
[Kitty]: https://github.com/kovidgoyal/kitty
[Zsh]: https://github.com/nushell/nushell
[P10k]: https://github.com/romkatv/powerlevel10k
[Waybar]: https://github.com/Alexays/Waybar
[wofi]: https://github.com/SimplyCEO/wofi
[Dunst]: https://github.com/dunst-project/dunst
[Btop]: https://github.com/aristocratos/btop
[Neovim]: https://github.com/neovim/neovim
[Hyprshot]: https://github.com/Gustash/Hyprshot
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[NetworkManager]: https://wiki.gnome.org/Projects/NetworkManager
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[SDDM]: https://github.com/sddm/sddm
[Dolphin]: https://github.com/KDE/dolphin
[mpv]: https://mpv.io/
