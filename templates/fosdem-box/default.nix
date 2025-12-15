{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./dev-mapping.nix
    ./hardware.nix

    ../../common/platforms/x86_64-efi-bootdisk.nix
    ../../common/base-config.nix
    ../../common/networking-dhcp.nix
    ../../common/audio-config.nix
    ../../common/gpu-support/intel.nix
    ../../common/fazantix
    ../../common/fosdem-box-status
    ../../common/fosdem-audio-board
  ];
}
