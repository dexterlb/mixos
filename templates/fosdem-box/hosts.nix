{ ... }:
let
  fosboxes = [ "101" "102" "103" ];
  mkFosbox = id: rec {
    hostname = "fosbox-${id}";
    system = "x86_64-linux";
    image = { format = "raw"; };
    moduleArgs = { inherit hostname; };
    deploy = {
      hostname = "100.64.0.11";
      sshUser = "human";

      remoteBuild = false;
      fastConnection = true;
    };
  };
in map mkFosbox fosboxes
