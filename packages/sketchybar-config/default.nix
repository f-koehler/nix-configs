{
  stdenv,
  lua5_4_compat,
  sketchybar-lua,
  ...
}:
stdenv.mkDerivation {
  name = "sketchybar-config";
  src = ./.;

  buildInputs = [
    lua5_4_compat
    sketchybar-lua
  ];

  patchPhase = ''
    substituteInPlace init.lua \
      --replace 'SBAR_LUA_PATH' '${sketchybar-lua}/lib/'; \
    substituteInPlace sketchybarrc \
      --replace 'LUA_EXECUTABLE' '${lua5_4_compat}/bin/lua'
  '';

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
