# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # Core configuration
    ../common/core

    # Users to create
    ../common/users/coopetal
  ];

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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home-pc"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  # GNOME
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # # TODO: minimise gnome installation
  # environment.gnome.excludePackages = with pkgs; [
  #     gnome-terminal
  #     gnome-software
  #     gnome-music
  #     # gnome-photos
  #     simple-scan
  #     totem
  #     epiphany
  #     geary
  #   ];

  # KDE
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Persistence settings
  # environment.etc = {
  #   nixos.source = "/persist/etc/nixos";
  #   "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
  #   adjtime.source = "/persist/etc/adjtime";
  #   NIXOS.source = "/persist/etc/NIXOS";
  #   machine-id.source = "/persist/etc/machine-id";
  # };
  # systemd.tmpfiles.rules = [
  #   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
  #   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
  #   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  # ];
  # # TODO: Switch all persistence options to impermanence module
  # environment.persistence."/persist" = {
  #   # hideMounts = true;
  #   directories = [
  #     "/etc/ssh"
  #     "/var/lib/bluetooth"
  #     "/var/lib/sops-nix"
  #     "/var/lib/nixos"
  #   ];
  #   files = [ "/var/lib/sops-nix-key.txt" ];
  # };

  # Rollback root to empty state
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  # boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
  #   mkdir -p /mnt
  #
  #   # We first mount the btrfs root to /mnt
  #   # so we can manipulate btrfs subvolumes.
  #   mount -o subvol=/ /dev/mapper/enc /mnt
  #
  #   # While we're tempted to just delete /root and create
  #   # a new snapshot from /root-blank, /root is already
  #   # populated at this point with a number of subvolumes,
  #   # which makes `btrfs subvolume delete` fail.
  #   # So, we remove them first.
  #   #
  #   # /root contains subvolumes:
  #   # - /root/var/lib/portables
  #   # - /root/var/lib/machines
  #   #
  #   # I suspect these are related to systemd-nspawn, but
  #   # since I don't use it I'm not 100% sure.
  #   # Anyhow, deleting these subvolumes hasn't resulted
  #   # in any issues so far, except for fairly
  #   # benign-looking errors from systemd-tmpfiles.
  #   btrfs subvolume list -o /mnt/root |
  #   cut -f9 -d' ' |
  #   while read subvolume; do
  #     echo "deleting /$subvolume subvolume..."
  #     btrfs subvolume delete "/mnt/$subvolume"
  #   done &&
  #   echo "deleting /root subvolume..." &&
  #   btrfs subvolume delete /mnt/root
  #
  #   echo "restoring blank /root subvolume..."
  #   btrfs subvolume snapshot /mnt/root-blank /mnt/root
  #
  #   # Once we're done rolling back to a blank snapshot,
  #   # we can unmount /mnt and continue on the boot process.
  #   umount /mnt
  # '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users = {
  #   mutableUsers = false;
  #   users = {
  #     coopetal = {
  #       hashedPassword = "$y$j9T$Ba5QklI3eouI6nqMlQfp./$804g2xkRrBlSsRxojs50lGTvUHoqJ5ckhkogORCFTJ5";
  #       isNormalUser = true;
  #       extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  #       # packages = with pkgs; [
  #       #
  #       # ];
  #       shell = pkgs.zsh;
  #     };
  #   };
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      firefox
      sops
      tree
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget

      # Gnome Extensions
      # gnomeExtensions.appindicator
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
  ];

  programs = {
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    # };
    # nushell.enable = true;
    zsh.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    flatpak.enable = true;
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        # AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [
  #   3389 # Gnome Remote Desktop
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   3389 # Gnome Remote Desktop
  # ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
