self: super:
let
  version = "c3e27384bd755dc42b9f55de872cc18c98e273a1";
  src = super.fetchFromGitHub {
    owner = "fosdem";
    repo = "video-amixcontrol";
    rev = "${version}";
    hash = "sha256-JvkA4YohcjEE9m3RQf5u3P0fEylZqpL8NbPby0qFnM8=";
    fetchSubmodules = true;
  };
  py = self.python3Packages;

  goversion = "c6ffce8893286f48c998e85bce99b3113acc7c72";
  gosrc = super.fetchFromGitHub {
    owner = "MartijnBraam";
    repo = "osc-proxy-go";
    rev = "${goversion}";
    hash = "sha256-7xDkzeuI3qUuQROCk8R+Y45VN5XZKXWenWVVFSmgmWs=";
    fetchSubmodules = true;
  };
in rec {
  fosdem-osc-lib = py.buildPythonPackage {
    inherit src version;
    pname = "fosdem-osc-lib";
    sourceRoot = "${src.name}/osc-lib";
    pyproject = true;
    build-system = [ py.setuptools ];
    dependencies = [ py.pyserial py.python-osc ];
  };
  fosdem-mixercli = py.buildPythonPackage {
    inherit src version;
    pname = "fosdem-mixercli";
    sourceRoot = "${src.name}/cli";
    pyproject = true;
    build-system = [ py.setuptools ];
    dependencies =
      [ fosdem-osc-lib py.click py.prompt-toolkit py.tabulate py.pyserial ];
  };
  fosdem-mixerapi = py.buildPythonPackage {
    inherit src version;
    pname = "fosdem-mixerapi";
    sourceRoot = "${src.name}/api";
    pyproject = true;
    build-system = [
      py.setuptools
      py.click
      py.fastapi
      py.uvicorn
      py.websockets
      py.requests
    ];
    dependencies = [ fosdem-osc-lib ];
  };
  fosdem-osc-proxy = super.buildGoModule {
    src = gosrc;
    version = goversion;
    name = "fosdem-osc-proxy";
    vendorHash = "sha256-n+jamm5trXR/8Ejrw6fYDP5RccoiyJr6CNpg7/Ijx5o=";
  };
}
