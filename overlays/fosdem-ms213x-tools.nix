self: super: {
  fosdem-ms213x-status = super.buildGoModule rec {
    version = "398bc5af7d1ccb1eee75efff6b38581bbfc875da";
    src = super.fetchFromGitHub {
      owner = "fosdem";
      repo = "video-ms213x-status";
      rev = "${version}";
      hash = "sha256-2TOlCJXkd0kHGYEH+8mlg78Og093I1GUZifKt4jjX9A=";
    };
    buildInputs = [ super.udev ];
    name = "fosdem-ms213x-status";
    vendorHash = "sha256-y4sn5jQ+iqXLPXm0gmOTdSpeVVcEOjECM6akZsxQqu4=";
  };
}
