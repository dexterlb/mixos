{ lib, pkgs, config, ... }:
let
  py = pkgs.python3Packages;
  # TODO: this is a massive hack
  # video status should instead go in a separate repo and have a pyproject.toml, etc
  videoStatusPkg = py.buildPythonPackage {
    src = ./video-status;
    version = "0.1.0";
    pname = "fosdem-video-status";
    pyproject = true;
    build-system = [ py.setuptools ];
    dependencies = [
      py.pyserial
      pkgs.moreutils
      pkgs.lm_sensors
      pkgs.hostname
      pkgs.coreutils
      pkgs.iproute2
    ];
  };
  captureStatusServices = lib.mapAttrs' (name: path: {
    name = "video-capture-status-${name}";
    value = let
      script = pkgs.writeShellApplication {
        name = "status";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          ${pkgs.fosdem-ms213x-status}/bin/ms213x-status \
            --raw-path="$(readlink -f "/dev/input/by-path/${path}")" \
            status --json --loop 1000 --filename /tmp/video-status-${name}.json \
            --region=flaky
        '';
      };
    in {
      enable = true;
      description = "Capture card status (${name})";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${script}/bin/status";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
  }) config.mixos.devMap.videoStatus.paths;
in {
  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="f05d", ATTRS{idProduct}=="4001", SYMLINK+="tty_fosdem_box_ctl"
    '';
    systemd.services = {
      fosdem-video-status = {
        enable = true;
        description = "FOSDEM video status";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${videoStatusPkg}/bin/video-status";
          User = "human";
          Group = "human";
        };
        wantedBy = [ "multi-user.target" ];
      };
    } // captureStatusServices;
    environment.systemPackages = [ pkgs.fosdem-ms213x-status ];
  };
  options.mixos.devMap.videoStatus.paths = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = ''
      Mapping of video capture device names to hidraw paths,
      for the sake of monitoring.
    '';
  };
}
