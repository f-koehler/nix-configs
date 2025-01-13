{
  stdenv,
  fetchFromGitHub,
  gcc,
  lua5_4_compat,
  readline,
  ...
}:
stdenv.mkDerivation {
  name = "sketchybar-lua";
  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "refs/heads/master";
    sha256 = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };

  buildInputs = [
    gcc
    readline.dev
    lua5_4_compat
  ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace '$(HOME)/.local/share/sketchybar_lua' '$out'
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp bin/sketchybar.so $out/lib
  '';
}
