_: {
  services = {
    aerospace = {
      enable = true;
      settings = {
        after-startup-command = ["exec-and-forget sketchybar"];

        # TODO(fk): disable the next two settings and rexplore the recommendation from the aerospace warning
        enable-normalization-flatten-containers = false;
        enable-normalization-opposite-orientation-for-nested-containers = false;

        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        on-focused-monitor-changed = [
          "move-mouse monitor-lazy-center"
        ];
        mode = {
          main.binding = {
            # Move focus
            alt-h = "focus --boundaries-action wrap-around-the-workspace left";
            alt-j = "focus --boundaries-action wrap-around-the-workspace down";
            alt-k = "focus --boundaries-action wrap-around-the-workspace up";
            alt-l = "focus --boundaries-action wrap-around-the-workspace right";
            # alt-left = "focus --boundaries-action wrap-around-the-workspace left";
            # alt-down = "focus --boundaries-action wrap-around-the-workspace down";
            # alt-up = "focus --boundaries-action wrap-around-the-workspace up";
            # alt-right = "focus --boundaries-action wrap-around-the-workspace right";

            # Move window
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";
            # alt-shift-left = "move left";
            # alt-shift-down = "move down";
            # alt-shift-up = "move up";
            # alt-shift-right = "move right";

            # Change layout
            alt-g = "split horizontal";
            alt-v = "split vertical";
            alt-f = "fullscreen";
            alt-s = "layout v_accordion";
            alt-w = "layout h_accordion";
            alt-e = "layout tiles horizontal vertical";
            alt-shift-space = "layout floating tiling";

            # Change workspace
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-0 = "workspace 10";

            # Move window to workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-0 = "move-node-to-workspace 10";

            alt-shift-c = "reload-config";
            alt-r = "mode resize";
          };
          resize.binding = {
            h = "resize width -50";
            j = "resize height +50";
            k = "resize height -50";
            l = "resize width +50";
            left = "resize width -50";
            down = "resize height +50";
            up = "resize height -50";
            right = "resize width +50";
            enter = "mode main";
            esc = "mode main";
          };
        };
      };
    };
  };
}
