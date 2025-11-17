{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Hardware modules

    # Core configuration
    ../common/core

    # Template configuration
    ../common/templates/server.nix

    # Optional configurations

    # Users to create
    ../common/users/coopetal
  ];

  networking.hostName = "alpha";

  # User accounts
  users.users.coopetal = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = 
      let
        ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      in 
        lib.flatten [
          "wheel"
          (ifTheyExist [
            "audio"
            "docker"
            "git"
            "multimedia"
            "networkmanager"
            "podman"
            "video"
          ])
        ];
  };

  homelab = {
    domain = "local";
    storage = "/data";
    multimedia = {
      enable = true;
      # deluge.interface = "wg1";
      # deluge.interface = "ens18";
    };
    traefik.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  # ];

  # virtualisation = {
  #   # Podman settings
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #     defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
  #   };
    # Container declarations
    # oci-containers = {
    #   backend = "podman";
    #   containers = {
        # Container config template
        # container-name = {
        #   image = "container-image";
        #   autoStart = true;
        #   ports = [ "127.0.0.1:1234:1234" ];
        #   pull = "newer";
        #   user = "1000:1000";
        #   dependsOn = [ "another-container" ];
        #   volumes = [
        #     "volume_name:/path/inside/container"
        #     "/path/on/host:/path/inside/container"
        #   ];
        # };
      # };
    # };
  # };

  system.stateVersion = "25.05";
}
