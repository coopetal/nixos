{ config, lib, pkgs, options, ... }:

let
  hl = config.homelab;
  cfg = hl.multimedia;
in
{
  options.homelab.multimedia = with lib; {
    enable = mkEnableOption "multimedia";
    deluge = {
      interface = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.multimedia = {};
      users.multimedia = {
        group = "multimedia";
        isSystemUser = true;
      };
      # users."${config.mySystem.user}".extraGroups = [ "multimedia" ];
    };

    systemd.tmpfiles.rules = [
      "d ${config.homelab.storage}/Media 2750 multimedia multimedia - -"
    ];

    homelab.traefik = {
      enable = true;
      services = {
        jellyfin.port = 8096;
        bazarr.port = config.services.bazarr.listenPort; # Default: 6767
        radarr.port = 7878;
        sonarr.port = 8989;
        lidarr.port = 8686;
        readarr.port = 8787;
        prowlarr.port = 9696;
        # deluge.port = config.services.deluge.web.port; # Default: 8112
      };
    };

    services = {
      jellyfin = {
        enable = true;
        user = "multimedia";
        group = "multimedia";
        dataDir = "${config.homelab.storage}/service_data/jellyfin";
        cacheDir = "${config.homelab.storage}/service_data/cache/jellyfin";
        openFirewall = true;
      };

      bazarr = {
        enable = true;
        user = "multimedia";
        group = "multimedia";
        dataDir = "${config.homelab.storage}/service_data/bazarr";
        openFirewall = true;
      };
      radarr = {
        enable = true;
        user = "multimedia";
        group = "multimedia";
        dataDir = "${config.homelab.storage}/service_data/radarr";
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        user = "multimedia";
        group = "multimedia";
        dataDir = "${config.homelab.storage}/service_data/sonarr";
        openFirewall = true;
      };
      # lidarr = {
      #   enable = true;
      #   user = "multimedia";
      #   group = "multimedia";
      #   openFirewall = true;
      #   # dataDir = "${config.homelab.storage}/service_data/lidarr";
      # };
      # readarr = {
      #   enable = true;
      #   user = "multimedia";
      #   group = "multimedia";
      #   openFirewall = true;
      # };
      prowlarr = {
        enable = true;
        dataDir = "${config.homelab.storage}/service_data/prowlarr";
        openFirewall = true;
      };
      transmission = {
        enable = true;
        user = "multimedia";
        group = "multimedia";
        package = pkgs.transmission_4;
        openFirewall = true;
        openRPCPort = true; # Open firewall for RPC
        settings = {
          download-dir = "${config.homelab.storage}/Media/Torrent";
          incomplete-dir = "${config.homelab.storage}/Media/Torrent/Incomplete";
          rpc-bind-address = "0.0.0.0"; #Bind to own IP
          rpc-whitelist = "127.0.0.1,10.0.0.20,10.0.0.21,10.0.0.22"; # Whitelist your remote machine
        };
      };
    };
  };
}
