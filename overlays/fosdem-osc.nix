self: super:
let
  version = "5d607f80ad27c2d09e437c22fd498f5ef049aca5";
  src = super.fetchFromGitHub {
    owner = "fosdem";
    repo = "video-amixcontrol";
    rev = "${version}";
    hash = "sha256-6KD62eclas+BE5dCwO0brVD8q8P4KeUQFbU5KVsj7Jk=";
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
  # override version of `click` because `click-repl` doesn't work with the new one
  # https://github.com/click-contrib/click-repl/issues/128
  python3 = super.python3.override {
    packageOverrides = pythonSelf: pythonSuper: {
      click = pythonSuper.click.overridePythonAttrs (oldAttrs: rec {
        version = "8.1.8";
        src = pythonSelf.fetchPypi {
          pname = "click";
          inherit version;
          sha256 = "sha256-7VPJ2JkNg8Kifermjk7jN0c/YzDAQKMdQiXJV00WCWo=";
        };
        pyproject = true;
        build-system = [ pythonSelf.setuptools ];
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
          ++ [ pythonSelf.setuptools pythonSelf.flit-core ];
      });
    };
  };
  python3Packages = self.python3.pkgs;

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
      [ fosdem-osc-lib py.click py.click-repl py.tabulate py.pyserial ];
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
