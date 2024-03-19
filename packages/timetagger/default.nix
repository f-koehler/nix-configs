{
  stdenv,
  autoPatchelfHook,
  fetchurl,
  dpkg,
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
  buildInputs = [
  ];

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out
  '';
}
