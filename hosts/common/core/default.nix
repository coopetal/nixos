{ inputs, outputs, ... }:

{
  # TODO: create the commented modules below
  imports = [
    ./nix.nix       # Nix settings and garbage collection
    # ./sops.nix    # Secrets management
    # ./zsh.nix     # Load a basic shell just in case we need it without home-manager
  ];
}
