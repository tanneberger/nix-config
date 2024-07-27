{ pkgs, fontforge, perl, perlPackages }:

pkgs.stdenv.mkDerivation {
  pname = "dejavu-fonts-full";
  nativeBuildInputs = [ fontforge perl perlPackages.IOString perlPackages.FontTTF ];

  src = ./fonts/.;

  buildFlags = [ "full-ttf" ];

  preBuild = "patchShebangs scripts";

  installPhase = "install -m444 -Dt $out/share/fonts/truetype build/*.ttf";
}
