{stdenv, ...}:
stdenv.mkDerivation {
  name = "sketchybar-plugins";
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    cp aerospace.sh $out/bin
    cp clock.sh $out/bin
    cp volume.sh $out/bin
  '';
}
