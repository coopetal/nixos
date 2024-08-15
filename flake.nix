{
  description = "Coopetal NixOs config";

  inputs = {
    # Official NixOs Package Sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOs hardware optimizations
    hardware.url = "github:nixos/nixos-hardware";

    # Home-Manager for /home declaration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "github:nix-community/home-manager/master";  # Unstable branch
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    # Impermanence tool to declare which root files to persist
    impermanence.url = "github:nix-community/impermanence";
    
    # Secrets management tool
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private secrets repo
    # Authenticate via ssh and use shallow clone
    mysecrets = {
      url = "git+ssh://git@gitlab.com/coopetal1/nixos-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, impermanence, ... }@inputs:
  let
    inherit (self) outputs;
    # Supported systems:
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    specialArgs = {inherit inputs outputs;};
  in
  {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;


    #
    # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management

    devShells = forAllSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = pkgs.mkShell {
          NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

          nativeBuildInputs = builtins.attrValues {
            inherit (pkgs)

              nix
              home-manager
              git
              just

              age
              ssh-to-age
              sops
              ;
          };
        };
      }
    );


    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      home-pc = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          { home-manager.extraSpecialArgs = specialArgs; }
          # Main NixOs configuration file
          ./hosts/home-pc
        ];
      };
    };

    # homeManagerConfigurations = {
    #   coopetal = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.${system};
    #     modules = [
    #       ./home/coopetal
    #       {
    #         home = {
    #           username = "coopetal";
    #           homeDirectory = "/home/coopetal";
    #           stateVersion = "24.05";
    #         };
    #       }
    #     ];
    #   };
    # };
  };
}
