{ config, lib, ... }:

let
  cfg = config.homelab;
in
{
  imports = [
    ./immich.nix
    ./multimedia.nix
    ./traefik.nix
  ];
  options.homelab = {
    domain = lib.mkOption {
      type = lib.types.str;
    };
    storage = lib.mkOption {
      type = lib.types.str;
      default = "/data";
    };
    safeStorage = lib.mkOption {
      type = lib.types.str;
      default = "/safe";
    };
  };
  config = {
    systemd.tmpfiles.rules = [
      "d ${cfg.storage} - - - - -"
    ];
  };
}
