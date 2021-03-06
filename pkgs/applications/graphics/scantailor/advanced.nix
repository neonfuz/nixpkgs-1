{ stdenv, fetchFromGitHub, makeDesktopItem
, cmake, libjpeg, libpng, libtiff, boost
, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "scantailor-advanced-${version}";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "4lex4";
    repo = "scantailor-advanced";
    rev = "v${version}";
    sha256 = "0lc9lzbpiy5hgimyhl4s4q67pb9gacpy985gl6iy8pl79zxhmcyp";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ libjpeg libpng libtiff boost qtbase ];

  meta = with stdenv.lib; {
    homepage = https://github.com/4lex4/scantailor-advanced;
    description = "Interactive post-processing tool for scanned pages";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jfrankenau ];
    platforms = with platforms; gnu ++ linux ++ darwin;
  };
}
