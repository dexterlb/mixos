{ lib, pkgs, ... }:
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
in {
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="f05d", ATTRS{idProduct}=="4001", SYMLINK+="tty_fosdem_box_ctl"
  '';
  systemd.services.fosdem-video-status = {
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
}
