{ ... }:
let
  fosboxes = [ "101" "102" "103" ];
  mkFosbox = id: rec {
    hostname = "fosbox-${id}";
    system = "x86_64-linux";
    image = { format = "raw"; };
    moduleArgs = { inherit hostname; };
    deploy = {
      hostname = "${hostname}.pit.protopit.eu";
      sshUser = "human";

      remoteBuild = false;
      fastConnection = true;
    };
  };
in map mkFosbox fosboxes
