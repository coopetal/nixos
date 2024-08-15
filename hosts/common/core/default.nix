{ inputs, outputs, ... }:

{
  # TODO: create the commented modules below
  imports = [
    # ./locale.nix  # Localisation settings
    # ./nix.nix     # Nix settings and garbage collection
    ./sops.nix    # Secrets management
    # ./zsh.nix     # Load a basic shell just incase we need it without home-manager
  ];
}
