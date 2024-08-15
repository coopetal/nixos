# Host level sops. See home/<user>/optional/sops.nix for home/user level.
{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.mysecrets;
in
{
  imports = [
  inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      # Automatically import host SSH keys as age keys
      sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      # This will use an age key that is expected to already be in the filesystem
      keyFile = "/persist/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };

    # Secrets will be output to /run/secrets
    # E.g. /run/secrets/msmtp-password TODO: update that example
    # Secrets required for user creation are handled in respective ./users/<username>.nix files
    # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
    # secrets = {
    #   msmtp-password = {};
    # };
  };
}
