_: {
  additions = final: _prev: import ../packages final.pkgs;
  modifications = _final: prev: {
    hyprland = prev.hyprland.overrideAttrs (_old: {
      postPatch =
        _old.postPatch
        + ''
          sed -i 's|Exec=Hyprland|Exec=hypr-launch|' example/hyprland.desktop
        '';
    });
  };
}
