{ inputs, lib, pkgs, ... }: {
  imports = [
    ./dev-mapping.nix

    ../../common/platforms/x86_64-virtio-qemu-img.nix
    ../../common/networking-dhcp.nix

    ../../common/base-config.nix
    ../../common/fazantix
  ];
}
