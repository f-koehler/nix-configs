{
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        log_level = "warn";
        notify_on_error = true;
        notify_no_formatters = true;
        formatters_by_ft = {
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          cpp = ["clang-format"];
          nix = ["alejandra"];
          python = ["ruff"];
          rust = ["rustfmt"];
        };
        formatters = {
          alejandra = {
            command = lib.getExe pkgs.alejandra;
          };
          clang-format = {
            command = "${pkgs.clang-tools}/bin/clang-format";
            args = ["-i" "$FILENAME"];
          };
          ruff = {
            command = lib.getExe pkgs.ruff;
            args = ["format" "$FILENAME"];
          };
          rustfmt = {
            command = lib.getExe pkgs.rustfmt;
          };
          shellcheck = {
            command = lib.getExe pkgs.shellcheck;
          };
          shfmt = {
            command = lib.getExe pkgs.shfmt;
          };
          shellharden = {
            command = lib.getExe pkgs.shellharden;
          };
        };
      };
    };
  };
}
