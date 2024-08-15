{ pkgs, inputs, config, ... }:
# let
#   ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
# in
{
  # Decrypt coopetal-password tto /run/secrets-for-users/ so it can be used to create the user
  sops.secrets.coopetal-password.neededForUsers = true;
  users.mutableUsers = false;

  users.users.coopetal = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.coopetal-password.path;
    shell = pkgs.zsh;  # Default shell
    extraGroups = [
      "wheel"
    # ]  # TODO: add the conditional groups
    # ++ ifTheyExist [
    #   "audio"
    #   "video"
    #   "docker"
      "git"
      "networkmanager"
    ];

    packages = [
      pkgs.home-manager
    ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ./keys/id_home-pc.pub)
      (builtins.readFile ./keys/id_framework.pub)
    ];

    # No matter what environment we are in we want these tools for root, and the user(s)
    # programs.zsh.enable = true
    # programs.git.enable = true;
    # TODO: environment object not found
    # environment.systemPackages = [
    #   pkgs.just
    #   pkgs.rsync
    # ];
  };

  # Import this user's personal/home configurations
  home-manager.users.coopetal = import (
    # "../../../../home/coopetal/${config.networking.hostName}.nix"  # TODO: Change home default.nix to a <host-name>.nix file
    ../../../../home/coopetal
  );
}
