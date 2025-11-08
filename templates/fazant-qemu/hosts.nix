{ ... }: [rec {
  hostname = "fazant";
  system = "x86_64-linux";
  image = { format = "qcow-efi"; };
  moduleArgs = {
    inherit hostname;
    streamInfo = {
      url = "rtmp://strm.ludost.net/st";
      key = "fazant-testing";
    };
  };
  deploy = {
    hostname = "localhost";
    sshUser = "human";

    remoteBuild = false;
    fastConnection = true;
    sshOpts = [ "-p" "2222" ];
  };
}]
