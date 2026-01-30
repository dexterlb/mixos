{ ... }:
let
  fosboxes = [ "58" ];
  mkFosbox = id: rec {
    hostname = "fosbox-${id}";
    system = "x86_64-linux";
    image = { format = "raw"; };
    moduleArgs = { inherit hostname; };
    deploy = {
      hostname = "box${id}.video.fosdem.org";
      sshUser = "human";

      remoteBuild = false;
      fastConnection = true;
    };
  };
in map mkFosbox fosboxes
