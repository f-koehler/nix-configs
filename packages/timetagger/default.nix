{
  stdenv,
  autoPatchelfHook,
  fetchurl,
  dpkg,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "timetagger";
  version = "2.16.2";
  src = fetchurl {
    url = "https://www.swabianinstruments.com/static/downloads/timetagger_${version}_jammy_amd64.deb";
    hash = "sha256-R8JRw1HKlyAJKaGfNVGmTk5OfUZxkYtUejy8zhJ9D00=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = with pkgs; [
    xorg.libxcb
    systemd
  ];
  runtimeDependencies = with pkgs; [
    lua5_3_compat
  ];
  autoPatchelfIgnoreMissingDeps = [
    "liblua5.3.so.0"
  ];

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out
    chmod 755 $out
  '';
}
