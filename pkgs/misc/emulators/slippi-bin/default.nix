{ appimageTools, fetchurl, gmp, lib}:

let
  pname = "slippi-bin";
  version="2.2.5";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  extraPkgs = pkgs: [ gmp ];

  src = fetchurl {
    url = "https://github.com/project-slippi/Ishiiruka/releases/download/v${version}/Slippi_Online-x86_64.AppImage";
    sha256 = "0l1rq0lc8n4f0fiqnksayybshgr626hqd43hdzhb0p0wqbnk8yi6";
  };

  meta = with lib; {
    homepage = "https://slippi.gg/netplay";
    description = "Dolphin emulator customized for online melee netplay"; # TODO: improve
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ neonfuz ];
  };
}
