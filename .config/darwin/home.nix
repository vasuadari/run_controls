{ config, pkgs, ... }:

{
  home = {
    stateVersion = "24.11"; # Please read the comment before changing.
    packages = with pkgs; [
      git
      htop
      curl
      jq
      tmux
      bat
      rustc
      cargo
      kubectl
      k9s
      kubelogin
      kubectx
      awscli2
      kubelogin-oidc
      fzf
      lua-language-server
      tldr
      sops
      python3
      docker-compose
      just
      neovim
      slides
      uv
      tgpt
      pkg-config
      next-ls
      jwt-cli
      shell-gpt
      nodejs
      btop
      #wkhtmltopdf-bin
    ];
    file = {
      ".profile.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.profile.d";
      };

      ".zshrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.zshrc";
      };

      ".config/alacritty" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.config/alacritty";
      };

      ".config/darwin" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.config/darwin";
      };

      ".config/just" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.config/just";
      };

      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.config/nvim";
      };

      ".config/dnsmasq.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.config/dnsmasq.conf";
      };

      ".tmux" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.tmux";
      };

      ".tmux.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.tmux.conf";
      };

      ".tmux.conf.local" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.tmux.conf.local";
      };

      ".hammerspoon" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vasu.adari/.run_commands/.hammerspoon";
      };

      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;

      sessionVariables = {
        EDITOR = "nvim";
        HOMEBREW_SYSTEM_VERSION=15.0;
        HOMEBREW_FAKE_MACOS=15.0;
      };

      shellAliases = {
        ls = "ls --color";
        vim = "nvim";
        switch = "darwin-rebuild switch --flake ~/.config/darwin";
      };
    };
  };

  programs.home-manager.enable = true;

  programs.openclaw = {
    documents = ./documents;

    config = {
      gateway = {
        mode = "local";
        auth.token = builtins.readFile "/Users/vasu.adari/.secrets/openclaw-gateway-token";
      };
    };

    instances.default = {
      enable = true;
      plugins = [];
    };
  };
}
