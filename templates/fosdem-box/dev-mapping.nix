{ lib, pkgs, ... }: {
  imports = [ ../../common/dev-mapper.nix ];

  mixos.devMap = {
    videoCapture.by-path = {
      "pci-0000:00:14.0-usbv3-0:1:1.0" = { name = "video-cam"; };
      "pci-0000:00:14.0-usbv3-0:2:1.0" = { name = "video-slides"; };
    };

    audio.by-name = {
      "~alsa_card.usb-FOSDEM_Audio_Board_" = { name = "audio-board"; };
    };
  };
}
