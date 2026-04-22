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
      jwt-cli
      shell-gpt
      nodejs
      btop
      #wkhtmltopdf-bin
    ];
    file = {
      ".profile.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.profile.d";
      };

      ".config/alacritty" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/alacritty";
      };

      ".config/darwin" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/darwin";
      };

      ".config/just" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/just";
      };

      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/nvim";
      };

      ".config/dnsmasq.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/dnsmasq.conf";
      };

      ".config/tmux/oh-my-tmux.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/tmux/tmux.conf";
      };

      ".config/tmux/tmux.conf.local" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.config/tmux/tmux.conf.local";
      };

      ".hammerspoon" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Users/vadari/.run_controls/.hammerspoon";
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

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-b";
      escapeTime = 0;
      baseIndex = 1;

      extraConfig = ''
        # Set Oh My Tmux environment variables
        set-environment -g TMUX_CONF "$HOME/.config/tmux/oh-my-tmux.conf"
        set-environment -g TMUX_CONF_LOCAL "$HOME/.config/tmux/tmux.conf.local"

        # Load Oh My Tmux configuration
        if-shell "test -f ~/.config/tmux/oh-my-tmux.conf" "source ~/.config/tmux/oh-my-tmux.conf"

        # Enable true color support
        set -ga terminal-overrides ",*256col*:Tc"

        # Renumber windows when one is closed
        set -g renumber-windows on

        # Enable focus events
        set -g focus-events on
      '';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        copycat
        cpu
        resurrect
        continuum
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15'
          '';
        }
      ];
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

      initContent = ''
        for i in $(ls ~/.profile.d)
        do
          . ~/.profile.d/$i
        done
      '';
    };
  };

  programs.home-manager.enable = true;
}
