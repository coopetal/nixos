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
    extraGroups = [ "wheel" "git" "networkmanager" ];
  };

  # environment.systemPackages = with pkgs; [
  # ];

  system.stateVersion = "25.05";
}
