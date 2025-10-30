{ inputs, outputs, lib, ... }:

{
  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
  '';

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Locale
  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";
  time.timeZone = lib.mkDefault "Europe/London";
}
