{
  config,
  lib,
  isTrusted,
  ...
}: {
  sops = {
    secrets = {
      "atuin/key".path = "${config.home.homeDirectory}/.local/share/atuin/key";
    };
  };
  programs.atuin = lib.mkIf isTrusted {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      inline_height = 20;
      key_path = config.sops.secrets."atuin/key".path;
      show_preview = true;
      style = "compact";
      sync_address = "https://api.atuin.sh";
      sync_frequency = "5m";
      update_check = false;
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
}
