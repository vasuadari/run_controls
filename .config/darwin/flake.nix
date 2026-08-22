{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.brew-src.url = "github:Homebrew/brew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-acli = {
      url = "github:atlassian/homebrew-acli";
      flake = false;
    };
    devstack-cli = {
      url = "git+ssh://git@gitlab.agodadev.io/devops/homebrew.git";
      flake = false;
    };
    agoda-homebrew-core = {
      url = "git+ssh://gitlab.agodadev.io/tools/homebrew-core.git";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-acli, devstack-cli, agoda-homebrew-core, ... }:
  let
    machine = "work";
    system = "aarch64-darwin";
    username = "vadari";
    nixpkgsConfig = { config.allowUnfree = true; };
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        jq
      ];

      shellHook = ''
        if [ ! -f /run/current-system/sw ]; then
          echo "👉 Running nix-darwin switch..."
          ${inputs.darwin.packages.${system}.default}/bin/darwin-rebuild switch --flake ${self.outPath}
        fi
      '';
    };

    darwinConfigurations.${machine} = darwin.lib.darwinSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;

            user = "vadari";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "atlassian/homebrew-acli" = homebrew-acli;
              "devops/homebrew-homebrew" = devstack-cli;
              "tools/homebrew-core" = agoda-homebrew-core;
            };

            mutableTaps = false;
            autoMigrate = true;
          };
        }

        {
          homebrew.enable = true;

          homebrew.onActivation = {
            autoUpdate = true;
            cleanup = "uninstall";  # Remove packages not declared in flake
            upgrade = true;
          };

          homebrew.brews = [
            # Only proprietary/company-specific tools that aren't in Nixpkgs
            "acli"                               # Atlassian CLI
            "opencode"                           # Likely proprietary
            "poetry"                             # Python package manager (Nix version broken with Python 3.14)
            "xsv"                                # Fast CSV toolkit (not in Nixpkgs)
            "devops/homebrew/devstack"           # Agoda internal
            "tools/homebrew-core/kubectl-login" # Agoda internal
          ];

          homebrew.casks = [
            "clipy"
            "alacritty"
            "hammerspoon"
            "alfred"
            "font-hack-nerd-font"
            "chatgpt"
            "font-powerline-symbols"
            "google-chrome"
            "numi"
            "firefox"
            "emacs-app"
            "postman"
            "claude-code"
            "sourcetree"
            "keepingyouawake"
            "codex"
            "codex-app"
            "slack-cli"
            "karabiner-elements"
          ];
        }

        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vasuadari = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
