{ lib, pkgs, ... }: {
  imports = [ ../../common/dev-mapper.nix ];

  mixos.devMap = {
    videoCapture.by-path = {
      "pci-0000:05:00.0-usbv3-0:1:1.0:fixme1" = { name = "video-slides"; };
      "pci-0000:05:00.0-usbv3-0:1:1.0:fixme2" = { name = "video-cam"; };
    };

    audio.by-name = {
      "~alsa_card.usb-FOSDEM_Audio_Board_" = { name = "audio-board"; };
    };
  };
}
