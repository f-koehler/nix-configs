{
  pkgs,
  lib,
  isWorkstation,
  ...
}: {
  home.packages = with pkgs; [
    rclone
    fuse
    coreutils
  ];
  systemd.user.services.onedrive = lib.mkIf isWorkstation {
    Unit = {
      Description = "OneDrive";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
      Documentation = ["man:rclone(1)"];
    };
    Service = {
      Type = "notify";
      ExecStartPre = ["-${pkgs.coreutils}/bin/mkdir -p %h/OneDrive"];
      ExecStart = "${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --vfs-cache-mode writes --poll-interval 30s SpeQtral-OneDrive: OneDrive";
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
