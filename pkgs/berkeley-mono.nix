# make a  derivation for berkeley-mono font installation
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "berkeley-mono-typeface";
  version = "1.009";

  src = ../dotfiles/berkeley-mono-typeface-trial.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    ls -alh
    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
