{ inputs, lib }:
let
  overlays = {
    fenix = inputs.fenix.overlays.default;
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
