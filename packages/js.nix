{pkgs, ...}:
with pkgs; [
  nodejs
  nodePackages_latest.prettier
  yarn
]
