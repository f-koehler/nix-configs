{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix
    ./development.nix
    ./firmware.nix
    ./gaming.nix
    ./memory.nix
    ./networking.nix
    ./nix.nix
    ./podman.nix
    ./power.nix
    ./ssh.nix
    ./tailscale.nix
    ./user.nix
  ];

  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_SG.UTF-8";
  system.stateVersion = "26.11"; # Did you read the comment?

  services.envfs.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    killall
    gptfdisk
    e2fsprogs

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
