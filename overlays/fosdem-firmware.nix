self: super:
let
  version = "051e9154f50d9d416ca79d81b5be7c5f2131b14f";
  src = (super.fetchFromGitHub {
    owner = "fosdem";
    repo = "video";
    rev = "${version}";
    hash = "sha256-hJcnyITCv1a+mIj+3S3B1yHv038+ViLE568+KyN0Wog=";
    fetchSubmodules = true;
  }).overrideAttrs {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
    GIT_CONFIG_VALUE_0 = "git@github.com:";
  };
in {
  fosdem-firmware-audio-brd = super.stdenv.mkDerivation {
    inherit version src;
    pname = "fosdem-firmware-audio-brd";
    nativeBuildInputs = [ super.cmake super.gcc-arm-embedded ];
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
