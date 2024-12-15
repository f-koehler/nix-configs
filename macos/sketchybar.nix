{
  # pkgs,
  outputs,
  nodeConfig,
  ...
}: let
  inherit (outputs.packages.${nodeConfig.system}) sketchybar-plugins;
in {
  environment.systemPackages = [
    # TODO(fk): figure out why we cannot use pkgs.sketchybar-plugins
    sketchybar-plugins
  ];
  services = {
    sketchybar = {
      enable = true;
      config = ''
        sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000

        default=(
          padding_left=5
          padding_right=5
          icon.font="Hack Nerd Font:Bold:17.0"
          label.font="Hack Nerd Font:Bold:14.0"
          icon.color=0xffffffff
          label.color=0xffffffff
          icon.padding_left=4
          icon.padding_right=4
          label.padding_left=4
          label.padding_right=4
        )
        sketchybar --default "''${default[@]}"

        sketchybar --add event aerospace_workspace_change
        for sid in $(aerospace list-workspaces --all); do
            sketchybar --add item space.$sid left \
                --subscribe space.$sid aerospace_workspace_change \
                --set space.$sid \
                background.color=0x44ffffff \
                background.corner_radius=5 \
                background.height=20 \
                background.drawing=off \
                label="$sid" \
                click_script="aerospace workspace $sid" \
                script="${sketchybar-plugins}/bin/aerospace.sh $sid"
        done

        sketchybar --add item chevron left \
           --set chevron icon= label.drawing=off \
           --add item front_app left \
           --set front_app icon.drawing=off script="${sketchybar-plugins}/bin/front-app.sh" \
           --subscribe front_app front_app_switched

        sketchybar --add item clock right \
           --set clock update_freq=10 icon=  script="${sketchybar-plugins}/bin/clock.sh" \
           --add item volume right \
           --set volume script="${sketchybar-plugins}/bin/volume.sh" \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery update_freq=120 script="${sketchybar-plugins}/bin/battery.sh" \
           --subscribe battery system_woke power_source_change


        sketchybar --update
      '';
    };
  };
}
