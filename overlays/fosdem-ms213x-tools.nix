self: super: {
  fosdem-ms213x-status = super.buildGoModule rec {
    version = "64c702f393794f83f1ca15ef330b209ac64f8f3e";
    src = super.fetchFromGitHub {
      owner = "fosdem";
      repo = "video-ms213x-status";
      rev = "${version}";
      hash = "sha256-l1zfxxHdCD8Ej6siPPH+wNbXTiPRBhobYGEMVOXR8JY=";
    };
    buildInputs = [ super.udev ];
    name = "fosdem-ms213x-status";
    vendorHash = "sha256-y4sn5jQ+iqXLPXm0gmOTdSpeVVcEOjECM6akZsxQqu4=";
  };
}
