{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix
    ./gaming.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./nix.nix
    ./power.nix
    ./ssh.nix
    ./tailscale.nix
    ./user.nix
  ];

  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_SG.UTF-8";
  system.stateVersion = "26.11"; # Did you read the comment?

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop

    # for neovim config
    gcc
    basedpyright
    clang-tools
    docker-language-server
    harper
    lua-language-server
    neocmakelsp
    ruff
    rust-analyzer
    statix
    taplo
    terraform-ls
    texlab
    tofu-ls
    zizmor
    nixfmt
    shfmt
    stylua
    terraform
    tex-fmt
    vscode-extensions.vadimcn.vscode-lldb.adapter
  ];
}
