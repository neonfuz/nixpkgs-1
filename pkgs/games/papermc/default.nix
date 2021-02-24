{ lib, stdenv, fetchurl, bash, jre }:
let
  mcVersion = "1.16.5";
  buildNum = "496";
  jar = fetchurl {
     url = "https://papermc.io/api/v1/paper/${mcVersion}/${buildNum}/download";
     sha256 = "0bidpx2vkzrg9avfizkcg86wpz0izvzkpncrxsb0v4sfl498lr2c";
  };
in stdenv.mkDerivation {
  pname = "papermc";
  version = "${mcVersion}r${buildNum}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/papermc/papermc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "High-performance Minecraft Server";
    homepage    = "https://papermc.io/";
    license     = lib.licenses.gpl3Only;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaronjanse neonfuz ];
  };
}
