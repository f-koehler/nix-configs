{
  lib,
  pkgs,
  config,
  nodeConfig,
  ...
}: let
  hyprlandLaunch = pkgs.writeShellScriptBin "hyprland-launch" ''
    ${pkgs.hyprland}/bin/Hyprland $@ &>/dev/null

    # Correctly clean up the session
    ${pkgs.hyprland}/bin/hyprctl dispatch exit
    systemctl --user --machine=${nodeConfig.username}@.host stop dbus-broker
    systemctl --user --machine=${nodeConfig.username}@.host stop hyprland-session.target
  '';
in {
  environment = {
    systemPackages = [hyprlandLaunch];
  };
  programs = {
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      systemd.setPath.enable = true;
    };
    nm-applet = lib.mkIf config.networking.networkmanager.enable {
      enable = true;
      indicator = true;
    };
    regreet = {
      enable = true;
      settings = {
        appearance = {
          greeting_msg = "Hello!";
        };
        commands = {
          reboot = ["${pkgs.systemd}/bin/systemctl" "reboot"];
          poweroff = ["${pkgs.systemd}/bin/systemctl" "poweroff"];
        };
        # GTK = lib.mkForce {
        #   application_prefer_dark_theme = true;
        #   cursor_theme_name = "catppuccin-mocha-blue-cursors";
        #   font_name = "Work Sans 16";
        #   icon_theme_name = "Papirus-Dark";
        #   theme_name = "catppuccin-mocha-blue-standard";
        # };
      };
    };
  };
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    greetd = {
      enable = true;
      vt = 1;
    };
  };
  security = {
    pam.services = {
      hyprlock = {};
      greetd.enableGnomeKeyring = true;
    };
    polkit.enable = true;
  };
  xdg = {
    portal = {
      configPackages = [pkgs.hyprland];
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common = {
          default = ["gtk"];
        };
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = ["wezterm.desktop"];
      };
    };
  };
  # Fix xdg-portals opening URLs: https://github.com/NixOS/nixpkgs/issues/189851
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
}
