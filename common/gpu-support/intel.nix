{ config, lib, pkgs, ... }: {
  # Enable OpenGL
  hardware.graphics = { enable = true; };

  # enable firmware blobs
  hardware.enableRedistributableFirmware = true;
}
