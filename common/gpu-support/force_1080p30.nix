{ ... }: {
  hardware.display = {
    edid = {
      enable = true;
      modelines = {
        "F_1080_30" =
          "80.18 1920 1984 2176 2432 1080 1081 1084 1099 -HSync +Vsync";
      };
    };
    outputs = {
      "HDMI-A-1".mode = "d"; # off
      "HDMI-A-2" = {
        edid = "F_1080_30.bin";
        mode = "e"; # force on
      };
    };
  };
}
