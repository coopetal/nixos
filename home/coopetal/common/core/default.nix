{ inputs, outputs, ... }:

{
  imports = [
    ./shell.nix
    # FIX: ssh.nix is crashing
    # ./ssh.nix
  ];
}
