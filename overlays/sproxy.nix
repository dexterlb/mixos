self: super: {
  fosdem-sproxy = super.stdenv.mkDerivation rec {
    pname = "sproxy";
    version = "0.5.0";
    src = super.fetchFromGitHub {
      owner = "fosdem";
      repo = "video-sproxy";
      rev = "v${version}";
      hash = "sha256-eNnj0SnoEeE11+rgbfZGHZSIFUD0P/9Rd4F83lTOFGc=";
    };
    nativeBuildInputs = [ super.gnumake super.gcc super.SDL2 ];
    installPhase = ''
      mkdir -p $out/bin
      install sproxy wait_next_second usb_reset $out/bin
    '';
  };
}
