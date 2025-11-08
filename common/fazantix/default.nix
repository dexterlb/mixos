{ config, pkgs, lib, ... }:
let
  fazantix-config-text = pkgs.writeTextFile {
    name = "fazantix-config.json";
    text = builtins.toJSON config.programs.fazantix.config;
  };
  fazantix-config-file = pkgs.stdenvNoCC.mkDerivation rec {
    name = "fazantix-config-file";
    meta.description = "Config file for fazantix";
    buildInputs = [ pkgs.coreutils ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -vfT ${fazantix-config-text} $out/fazantix-config.json
      ${pkgs.fazantix}/bin/fazantix-validate-config $out/fazantix-config.json
    '';
  };
in {
  options = {
    programs.fazantix.config = lib.mkOption {
      type = lib.types.raw; # accepts any nix expression/value
      default = ((import ./example_config.nix) { inherit pkgs; });
      description = "Fazantix configuration";
    };
  };

  config = {
    home-manager.users.human = {
      imports = [ ];

      home.packages = with pkgs; [ cage fazantix ];

      home.file.".zprofile".text = ''
        # Auto-start cage on first VT if not already under Wayland
        if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR: -0}" -eq 1 ]; then
          cage -d -- fazantix ${fazantix-config-file}/fazantix-config.json
        fi
      '';
    };
  };
}
