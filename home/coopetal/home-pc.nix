{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Core configuration
    common/core
  ];

  home.packages = with pkgs; [
    darktable
    heroic
    lsfg-vk
    lsfg-vk-ui
    lutris
    unzip

    # Fonts
    # jetbrains-mono
  ];

  programs = {
  };
}
