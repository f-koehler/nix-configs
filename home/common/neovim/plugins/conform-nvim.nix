{ lib, pkgs, ... }:
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = "fallback";
          timeout_ms = 500;
        };
        notify_on_error = true;
        formatters_by_ft = {
          bib = [ "tex-fmt" ];
          cmake = [ "cmake_format" ];
          css = [ "stylelint" ];
          cpp = [ "clang-format" ];
          json = [ "prettierd" ];
          nix = [ "nixfmt" ];
          python = [ "ruff_format" ];
          rust = [ "rustfmt" ];
          sass = [ "stylelint" ];
          scss = [ "stylelint" ];
          sh = [ "shfmt" ];
          plaintex = [ "tex-fmt" ];
          toml = [ "taplo" ];
          tex = [ "tex-fmt" ];
          typst = [ "typstyle" ];
          yaml = [ "prettierd" ];

          "*" = [
            "trim_newlines"
            "trim_whitespaces"
          ];
        };
        formatters = {
          "clang-format" = {
            command = lib.getExe' pkgs.clang-tools "clang-format";
          };
          "cmake_format" = {
            command = lib.getExe pkgs.cmake-format;
          };
          "codespell" = {
            command = lib.getExe pkgs.codespell;
          };
          "nixfmt" = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
          "prettierd" = {
            command = lib.getExe pkgs.prettierd;
          };
          "ruff_format" = {
            command = lib.getExe pkgs.ruff;
          };
          "rustfmt" = {
            command = lib.getExe pkgs.rustfmt;
          };
          "shfmt" = {
            command = lib.getExe pkgs.shfmt;
          };
          "stylelint" = {
            command = lib.getExe pkgs.stylelint;
          };
          "taplo" = {
            command = lib.getExe pkgs.taplo;
          };
          "tex-fmt" = {
            command = lib.getExe pkgs.tex-fmt;
          };
          "typstyle" = {
            command = lib.getExe pkgs.typstyle;
          };
        };
      };
    };
  };
}
