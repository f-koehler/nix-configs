{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs.url = "github:serokell/deploy-rs";

    systems.url = "github:nix-systems/default";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    catppuccin.url = "github:catppuccin/nix";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:MIC92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    ashell = {
      url = "github:MalpenZibo/ashell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO(fk): replace with nix package once available
    isd.url = "github:isd-project/isd";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      mylib = import ./lib { inherit inputs outputs stateVersion; };

      config-desktop = {
        hostname = "desktop";
        username = "fkoehler";
        isWorkstation = true;
        isTrusted = true;
        containerBackend = "docker";
        virtualisation = true;
        gpus = [ "nvidia" ];
        desktops = [ "sway" ];
      };
      config-fkt14 = {
        hostname = "fkt14";
        username = "fkoehler";
        isWorkstation = true;
        isTrusted = true;
        containerBackend = "docker";
        virtualisation = true;
        gpus = [ "intel" ];
        desktops = [
          "plasma"
          "sway"
        ];
      };
      config-mbp21 = {
        hostname = "mbp21";
        username = "fkoehler";
        system = "aarch64-darwin";
        isWorkstation = true;
        isTrusted = true;
      };
      config-homeserver = {
        hostname = "homeserver";
        username = "fkoehler";
        isWorkstation = false;
        isTrusted = true;
      };
      config-vps = {
        hostname = "vps";
        username = "fkoehler";
        isWorkstation = false;
        isTrusted = true;
      };
    in
    {
      homeConfigurations = {
        "fkoehler@fkt14" = mylib.mkHome config-fkt14;
        "fkoehler@mbp21" = mylib.mkHome config-mbp21;
        "fkoehler@homeserver" = mylib.mkHome config-homeserver;
        "fkoehler@vps" = mylib.mkHome config-vps;
      };

      nixosConfigurations = {
        "fkt14" = mylib.mkNixOS config-fkt14;
        "homeserver" = mylib.mkNixOS config-homeserver;
        "vps" = mylib.mkNixOS config-vps;
        "desktop" = mylib.mkNixOS config-desktop;
      };

      darwinConfigurations = {
        "mbp21" = mylib.mkDarwin config-mbp21;
      };

      deploy = {
        remoteBuild = true;
        nodes = {
          # vps = {
          #   profiles = {
          #     system = {
          #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vps;
          #     };
          #   };
          # };
          mpb21 = {
            profiles = {
              system = {
                user = "fkoehler";
                path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.mbp21;
                hostname = "mbp21";
              };
            };
          };
        };
      };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      overlays = import ./overlays { inherit inputs; };
      packages = mylib.forAllSystems (
        system:
        (import ./packages inputs.nixpkgs.legacyPackages.${system})
        // {
          devenv-up = self.devShells.${system}.default.config.procfileScript;
          devenv-test = self.devShells.${system}.default.config.test;
        }
      );
      formatter = mylib.forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = mylib.forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          default = inputs.devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                packages = with pkgs; [
                  age
                  fastfetch
                  git
                  home-manager
                  just
                  nodejs
                  sops
                  nixos-rebuild
                ];

                scripts = {
                  refresh.exec = ''
                    nix flake update
                  '';
                  rebuild.exec = ''
                    if [ "$(uname)" == "Darwin" ]; then
                      nix run nix-darwin -- switch --flake .
                      nix run home-manager -- switch --flake .
                    else
                      nix-shell -p nh --run "nh os boot ."
                      nix-shell -p nh --run "nh home switch ."
                    fi
                  '';
                  renovate.exec = ''
                    LOG_LEVEL=debug ${inputs.nixpkgs.lib.getExe' pkgs.nodejs "npx"} renovate --platform=local --repository-cache=reset
                  '';
                };

                enterShell = ''
                  ${pkgs.fastfetch}/bin/fastfetch

                  # Custom greeting message with color
                  echo -e "\033[1;32mWelcome to the development environment, Fabian!\033[0m"

                  # Display two commonly used commands with color
                  echo ""
                  echo -e "\033[1;34mUseful commands:\033[0m"
                  echo -e "\033[1;36m  1. refresh  - \033[0m\033[0;33m🔄 Updates nix flake & devenv\033[0m"
                  echo -e "\033[1;36m  2. rebuild  - \033[0m\033[0;33m🏗️  Rebuilds and switches system and user config\033[0m"
                  echo ""
                '';

                languages = {
                  nix.enable = true;
                  python = {
                    enable = true;
                    uv = {
                      enable = true;
                      sync.enable = true;
                    };
                  };
                };

                pre-commit.hooks = {
                  check-added-large-files.enable = true;
                  check-executables-have-shebangs.enable = true;
                  check-merge-conflicts.enable = true;
                  check-symlinks.enable = true;
                  # end-of-line-fixer.enable = true;
                  # trim-trailing-whitespace = true;
                  # end-of-file-fixer = true;

                  # lua
                  stylua.enable = true;

                  # nix
                  nixfmt-rfc-style.enable = true;
                  deadnix.enable = true;
                  flake-checker.enable = true;
                  nil.enable = true;
                  statix.enable = true;

                  # shell
                  shellcheck.enable = true;
                  shfmt.enable = true;

                  # python
                  ruff-format.enable = true;
                  # ruff-lint.enable = true;

                  # yaml
                  yamllint.enable = true;

                  # toml
                  taplo.enable = true;

                  # other
                  prettier.enable = true;
                  actionlint.enable = true;
                };
              }
            ];
          };
        }
      );
    };
}
