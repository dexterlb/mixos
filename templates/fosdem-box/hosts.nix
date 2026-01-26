{ ... }:
let
  fosboxes = [ "101" "102" "103" ];
  mkFosbox = id: rec {
    hostname = "fosbox-${id}";
    system = "x86_64-linux";
    image = { format = "raw"; };
    moduleArgs = { inherit hostname; };
    deploy = {
      hostname = "${hostname}.d.qtrp.org";
      sshUser = "human";

      remoteBuild = false;
      fastConnection = true;
    };
  };
in map mkFosbox fosboxes
