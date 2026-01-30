{ ... }:
let
  fosboxes = [ "101" "102" "103" ];
  mkFosbox = id: rec {
    hostname = "fosbox-${id}";
    system = "x86_64-linux";
    image = { format = "raw"; };
    moduleArgs = { inherit hostname; };
    deploy = {
      hostname = "185.175.218.181";
      sshUser = "human";

      remoteBuild = false;
      fastConnection = true;
    };
  };
in map mkFosbox fosboxes
