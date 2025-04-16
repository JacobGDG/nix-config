# My Nix config

My overkill dotfiles.

* https://search.nixos.org/packages
* https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/programs
* https://github.com/nix-community/home-manager/tree/master/modules/programs

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
    * Secret declration per system, including OS permissions on the files
      created. Secret values are stored, encrypted, in a seperate and private
      repo
* `nixos/`
    * NixOS configuration. Currently only for a single device
* `modules/home-manager/`
    * Primary location for more complex home-manager package config
* `modules/nixos/`
    * Primary location for more complex NixOS package config
* `mylib/`
    * Helper functions, purposefully kept seperate from nixos or home-manager
      lib
* `config/`
    * I like Lua and I like how Neovim is configured with Lua, this is my
      solution. It isn't fully declarative doesnt allow Nix rollbacks etc, but
      it works.
    * TLDR, disable Nix nvim config, symlink this directory to `~/.config/nvim`
