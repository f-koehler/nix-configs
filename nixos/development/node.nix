{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.nodejs
    pkgs.pnpm
    pkgs.yarn
  ];
}
