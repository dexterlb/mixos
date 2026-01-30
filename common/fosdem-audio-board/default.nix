{ lib, pkgs, ... }:
let
  mixerapi-config-pkg = pkgs.stdenvNoCC.mkDerivation {
    name = "fosdem-mixerapi-config";
    src = ./mixerapi-config;
    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ ];
    installPhase = ''
      mkdir -p $out
      cp -rf * $out/
    '';
  };
in {
  services.udev.extraRules = ''
    ACTION=="remove", GOTO="fosdem_audio_end"
    SUBSYSTEM!="tty", GOTO="fosdem_audio_end"
    SUBSYSTEMS=="usb", IMPORT{builtin}="usb_id"
    ENV{ID_SERIAL}!="FOSDEM_Audio*", GOTO="fosdem_audio_end"
    KERNEL!="ttyACM[0-9]*", GOTO="fosdem_audio_end"

    ENV{ID_USB_INTERFACE_NUM}=="00", SYMLINK+="tty_fosdem_audio_ctl"
    ENV{ID_USB_INTERFACE_NUM}=="02", SYMLINK+="tty_fosdem_audio_debug"

    LABEL="fosdem_audio_end"
  '';
  services.udev.packages = [ pkgs.teensy-udev-rules ];
  environment.systemPackages = [
    pkgs.fosdem-firmware-audio-brd-flash
    pkgs.fosdem-mixercli
    pkgs.fosdem-mixerapi
    pkgs.fosdem-osc-proxy
  ];

  systemd.services.osc-proxy = {
    enable = true;
    description = "FOSDEM audio OSC proxy";
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.fosdem-osc-proxy}/bin/osc-proxy-go -device /dev/tty_fosdem_audio_ctl";
      User = "human";
      Group = "human";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.mixerapi = {
    enable = true;
    description = "FOSDEM audio mixer API";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.fosdem-mixerapi}/bin/mixerapi";
      WorkingDirectory = "${mixerapi-config-pkg}";
      User = "human";
      Group = "human";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
