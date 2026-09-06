{ pkgs, lib, ... }:
let
  lanMouseApp =
    let
      version = "0.11.0";
      hash =
        if pkgs.stdenv.hostPlatform.isAarch64 then
          "sha256-0vAdCaWCoW0Us/GiU2jESQREaQj2tNojsiubdPD+opM="
        else
          "sha256-zjVRehglhcyDCv/6KURIGu6Z3gDo8N9lJe6tLoScBuA=";
      arch = if pkgs.stdenv.hostPlatform.isAarch64 then "arm64" else "intel";
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "lan-mouse-app";
      inherit version;
      src = pkgs.fetchzip {
        url = "https://github.com/feschber/lan-mouse/releases/download/v${version}/lan-mouse-macos-${arch}.zip";
        inherit hash;
        stripRoot = false;
      };
      installPhase = ''
        mkdir -p "$out/Applications"
        cp -r "$src/Lan Mouse.app" "$out/Applications/"
      '';
      # A plain `cp -r` preserves the upstream ad-hoc signature as-is
      # (verified: identical CDHash before/after), so no re-signing needed.
      dontFixup = true;
      meta.platforms = lib.platforms.darwin;
    };
in
{
  programs.lan-mouse = {
    enable = pkgs.stdenv.isLinux;
    systemd = pkgs.stdenv.isLinux;
    # settings = {};
  };

  home.packages = lib.optionals pkgs.stdenv.isDarwin [
    lanMouseApp
  ];
}
