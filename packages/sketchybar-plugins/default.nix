{stdenv, ...}:
stdenv.mkDerivation {
  name = "sketchybar-plugins";
  src = ./.;
  installPhase = ''
    mkdir -p $out
    cp aerospace.sh $out
    cp clock.sh $out
    cp volume.sh $out
  '';
}
