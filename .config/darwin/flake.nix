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
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    machine = "HRXY5C4QDV";
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
            };

            mutableTaps = false;
            autoMigrate = true;
          };
        }

        {
          homebrew.enable = true;

          homebrew.onActivation = {
            autoUpdate = true;
            # cleanup = "uninstall";
            upgrade = true;
          };

          homebrew.brews = [
            "coreutils"
            "ripgrep"
            "pure"
            "zoxide"
            "helm"
            "bore-cli"
            "mise"
            "helmfile"
            "gitui"
            "eza"
            "tree-sitter"
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
            "craft"
            "emacs"
            "livebook"
            "ollama-app"
            "Postman"
            "claude-code"
            "sourcetree"
          ];
        }

        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vasuadari = import ./home.nix;
        }
      ];
    };
  };
}
