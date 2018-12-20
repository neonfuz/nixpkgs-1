{ stdenv, fetchFromGitHub, libudev, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "wii-u-gc-adapter-${version}";
  version = "2016-02-03";

  src = fetchFromGitHub {
    owner = "ToadKing";
    repo = "wii-u-gc-adapter";
    rev = "1030fee12a7ed87058a6f5b282934e1074cd8934";
    sha256 = "0i7jc56djqqqb37cn35cqd2xwg3ab603h8hn03547rs8nf659mr3";
  };

  postPatch = ''
    sed 's|-Wno-format|-Wno-format -Wno-format-security|' -i ./Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./wii-u-gc-adapter $out/bin
  '';

  buildInputs = [ libudev libusb1 pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/ToadKing/wii-u-gc-adapter;
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ neonfuz ];
  };
}
