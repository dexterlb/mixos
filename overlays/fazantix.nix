self: super:
let
  fazantix-pkgs =
    self.config.flake-inputs.fazantix.packages.${self.stdenv.hostPlatform.system};
in {
  fazantix = fazantix-pkgs.fazantix;
  fazantix-sample-images = fazantix-pkgs.fazantix-sample-images;
}
