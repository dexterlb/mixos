{ lib, pkgs, ... }: {
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
  environment.systemPackages = [ pkgs.fosdem-firmware-audio-brd-flash ];
}
