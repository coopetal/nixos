{ outputs. lib, ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "git-repositories" = {
        host = "gitlab.com github.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };
    };
  };
}
