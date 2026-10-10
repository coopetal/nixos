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
  ];

  programs = {
  };
}
