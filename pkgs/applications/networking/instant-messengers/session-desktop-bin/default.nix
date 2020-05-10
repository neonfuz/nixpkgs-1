{ lib
, fetchurl
, appimageTools
}:

let
  pname = "session-desktop-bin";
  version = "1.0.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/loki-project/session-desktop/releases/download/v${version}/session-messenger-desktop-linux-x86_64-${version}.AppImage";
    sha256 =  "01i6hlhvafqd0vfpqrxb6fw6ca2j6rffhjsx8xc882fwjrnacqax";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/session-messenger-desktop.desktop $out/share/applications/session-messenger-desktop.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/session-messenger-desktop.png \
      $out/share/icons/hicolor/512x512/apps/session-messenger-desktop.png
    substituteInPlace $out/share/applications/session-messenger-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Send Encrypted Messages Not Metadata";
    longDescription = ''
      an end-to-end encrypted messenger that removes sensitive metadata
      collection, and is designed for people who want privacy and freedom
      from any forms of surveillance
    '';
    homepage    = "https://getsession.org/";
    changelog   = "https://github.com/loki-project/session-desktop/releases/tag/v${version}";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ neonfuz ];
    platforms   = [ "x86_64-linux" ];
  };
}
