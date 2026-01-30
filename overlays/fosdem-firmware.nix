self: super:
let
  version = "33c5ec852816db2247e0b7c9b9e9ab7ce6f56c4c";
  src = super.fetchFromGitHub {
    owner = "fosdem";
    repo = "video";
    rev = "${version}";
    hash = "sha256-OUsRUgAwlckjZd//0mMOaJeCMTRvDvvQXXxhZQqPzMw=";
    fetchSubmodules = true;
    preFetch = ''
      # can't clone using ssh
      # https://github.com/jg-rp/python-jsonpath/pull/122
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };
in {
  fosdem-firmware-audio-brd = super.stdenv.mkDerivation {
    inherit version src;
    pname = "fosdem-firmware-audio-brd";
    nativeBuildInputs = [ super.cmake super.gcc-arm-embedded-14 ];
    sourceRoot = "${src.name}/hardware/firmware/audio_board";
    installPhase = ''
      mkdir -p $out
      cp teensy_audio.{hex,elf} $out/
    '';
  };

  fosdem-firmware-audio-brd-flash = let
    flash-sh = super.stdenvNoCC.mkDerivation {
      pname = "fosdem-firmware-audio-brd-flash-sh";
      inherit version src;
      sourceRoot = "${src.name}/hardware/firmware/audio_board";
      phases = [ "unpackPhase" "installPhase" ];
      nativeBuildInputs = [ super.makeWrapper ];
      installPhase = ''
        mkdir -p $out/bin
        cp -a flash.sh $out/bin
        sed -i 's/teensy_loader_cli/teensy-loader-cli/g' $out/bin/flash.sh
        wrapProgram $out/bin/flash.sh --prefix PATH : \
          ${super.lib.makeBinPath [ super.coreutils super.teensy-loader-cli ]}
      '';
    };
  in super.writeShellApplication {
    name = "fosdem-firmware-audio-brd-flash";
    text = ''
      ${flash-sh}/bin/flash.sh ${self.fosdem-firmware-audio-brd}
    '';
  };
}
