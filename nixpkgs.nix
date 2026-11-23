{ inputs, lib }:
let
  overlays = {
    fenix = inputs.fenix.overlays.default;
    # packages not (yet) in nixpkgs
    local = final: _prev: {
      clice = final.callPackage ./pkgs/clice/package.nix { };
    };
  };
in
{
  inherit overlays;
  overlayList = lib.attrValues overlays;
  config = tags: {
    allowUnfree = true;
    nvidia.acceptLicense = lib.elem "gpu-nvidia" tags;
  };
}
