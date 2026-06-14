{ config, lib, pkgs, options, ... }:

let
  hl = config.homelab;
  cfg = hl.immich;

  immichStorage = "${config.homelab.safeStorage}/Photos";
in
{
  options.homelab.immich = with lib; {
      enable = mkEnableOption "immich";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${immichStorage} 0750 immich immich -"
    ];

    homelab = {
      traefik = {
        enable = true;
        services.immich.port = config.services.immich.port;
      };
    };
    users.users.immich.extraGroups = [ "video" "render" ];
    services = {
      immich = {
        enable = true;
        host = "0.0.0.0";
        openFirewall = true;
        mediaLocation = immichStorage;
        accelerationDevices = [ "/dev/dri/card0" ];
        # settings = {  # TODO: set up declarative settings
          # backup.database.enabled = false;  # TODO: create external DB Backup
          # newVersionCheck.enabled = false;
        # };
      };
    };
    systemd.services.immich-server = {
      # We must set the UMask of the Immich service, so new files can be read by the group as well,
      # in order for restic backups to work properly across NFS.
      serviceConfig.UMask = lib.mkForce "0027"; # default is 0077
    };
    hardware.graphics = { 
     enable = true;
     # ...
     # See: https://wiki.nixos.org/wiki/Accelerated_Video_Playback
    };
  };
}
  
