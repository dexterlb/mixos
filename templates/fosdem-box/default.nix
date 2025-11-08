{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./dev-mapping.nix

    ../../common/platforms/x86_64-efi-bootdisk.nix
    ../../common/base-config.nix
    ../../common/audio-config.nix
    ../../common/fazantix
    ../../common/fosdem-box-status
    ../../common/fosdem-audio-board
  ];
}
