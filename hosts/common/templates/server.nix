### System template for a server running in Proxmox with btrfs partitioning
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader.efi.canTouchEfiVariables = false; # For VMs without EFI vars (Proxmox default)
    # loader.systemd-boot.enable = true;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  networking.networkmanager.enable = true;

  # Disable NetworkManager's internal DNS resolution
  networking.networkmanager.dns = "none";
  # These options are unnecessary when managing DNS ourselves
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  # Configure DNS servers manually
  # IPv6 DNS servers can be used here as well.
  networking.networkmanager.insertNameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];

  environment.systemPackages = with pkgs; [
    git
    tree
    vim
    wget
  ];

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
