{
  stdenv,
  lua,
  sketchybar-lua,
  ...
}:
stdenv.mkDerivation {
  name = "sketchybar-config";
  src = ./.;

  buildInputs = [lua sketchybar-lua];

  buildPhase = ''
    pushd helpers && make && popd
  '';

  installPhase = ''
    mkdir -p $out/share/sketchybar-config/
    cp \
      bar.lua \
      colors.lua \
      default.lua \
      icons.lua \
      init.lua \
      settings.lua \
      sketchybarrc \
      $out/share/sketchybar-config/
    cp -r \
      helpers \
      items \
      $out/share/sketchybar-config/
  '';
}
