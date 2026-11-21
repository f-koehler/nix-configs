{ inputs, lib }:
let
  overlays = {
    fenix = inputs.fenix.overlays.default;
    # packages defined in ./pkgs
    local = final: _prev: {
      guitar-pro-8 = final.callPackage ./pkgs/guitar-pro-8 { };
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
