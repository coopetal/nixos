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
    safeStorage = "/data/safe";
    immich.enable = true;
    multimedia.enable = true;
    # redis = {
    #   enable = true;
    #   databases = 1;
    #   # Databases:
    #   # 0: Immich
    # };
    # postgresql = {
    #   enable = true;
    #   package = pkgs.postgresql_18;
    # };
    traefik = {
      enable = true;
      services = {
        "gmktec01.pve" = { host = "10.0.0.10"; port = 8006; };
        "node.pve" = { host = "10.0.0.11"; port = 8006; };
        homeassistant = { host = "10.0.0.23"; port = 8123; };
        zigbee2mqtt = { host = "10.0.0.51"; port = 9442; };
      };
    };
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
