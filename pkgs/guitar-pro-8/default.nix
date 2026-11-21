# Guitar Pro 8 running under wine.
#
# The installer is proprietary and not downloadable without an account; add it
# to the store once with
#   nix-store --add-fixed sha256 guitar-pro-soundbank-full.exe
#
# The package does not depend on the installer, so it builds (and the system
# deploys) before the installer has been added. Its store path is fixed by the
# hash, so the launcher only refers to it as a string and looks for it at run
# time. On first launch the launcher
#   - creates a wine prefix in $XDG_DATA_HOME/guitar-pro-8 and runs the
#     installer there, so licence activation, settings and soundbanks live in
#     that (writable) prefix,
#   - roots the installer in the prefix (installer.exe) so it is not garbage
#     collected while the prefix exists,
#   - extracts the app icon into $XDG_DATA_HOME/icons.
#
# Display settings (`dpi`, `uiFont`) are written to the prefix's registry on
# launch whenever they change, so they can be set with `.override`.
{
  lib,
  stdenvNoCC,
  requireFile,
  writeShellApplication,
  makeDesktopItem,
  copyDesktopItems,
  icoutils,
  libnotify,
  wineWow64Packages,
  winetricks,
  writeText,
  # Windows DPI of the prefix; Qt scales the whole UI with it (96 = 100%, 144 = 150%, 192 = 200%)
  dpi ? 96,
  # host font (via fontconfig) used in place of Segoe UI/Tahoma; wine's
  # built-in Tahoma clips glyphs and parentheses in the Qt UI
  uiFont ? "Noto Sans",
}:
let
  pname = "guitar-pro-8";
  version = "8.1.5.31";

  wine = wineWow64Packages.stable;

  message = ''
    Guitar Pro 8 cannot be downloaded automatically. Download the full
    installer (with soundbanks) from your account at guitar-pro.com, then run

      nix-store --add-fixed sha256 guitar-pro-soundbank-full.exe

    If you got a newer installer, update `version` and `sha256` in
    pkgs/guitar-pro-8/default.nix (`nix hash file <installer>`).
  '';

  installer = requireFile {
    name = "guitar-pro-soundbank-full.exe";
    sha256 = "642eb400725ee7493de1695dafdd2cc12836c72ed6c4ea37799fbd767ea35d6e";
    inherit message;
  };
  # the store path without the build dependency, see the comment at the top
  installerPath = builtins.unsafeDiscardStringContext installer.outPath;

  # regedit expects 8 hex digits for a dword
  hexDword = n: lib.fixedWidthString 8 "0" (lib.toLower (lib.toHexString n));

  settings = writeText "${pname}-settings.reg" ''
    REGEDIT4

    [HKEY_CURRENT_USER\Control Panel\Desktop]
    "LogPixels"=dword:${hexDword dpi}

    [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
    ${lib.concatMapStrings
      (font: ''
        "${font}"="${uiFont}"
      '')
      [
        "Segoe UI"
        "MS Shell Dlg"
        "MS Shell Dlg 2"
        "Tahoma"
      ]
    }
  '';

  launcher = writeShellApplication {
    name = pname;
    runtimeInputs = [
      icoutils
      libnotify
      wine
      winetricks
    ];
    text = ''
      export WINEPREFIX="''${GUITAR_PRO_PREFIX:-''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}}"
      export WINEDEBUG="''${WINEDEBUG:--all}"

      find_exe() {
        find "$WINEPREFIX/drive_c" -ipath '*/Guitar Pro 8/GuitarPro.exe' -print -quit 2>/dev/null || true
      }

      init_prefix() {
        if [ ! -f "$WINEPREFIX/system.reg" ]; then
          echo "Creating wine prefix in $WINEPREFIX" >&2
          # skip the wine-mono/wine-gecko download prompts
          WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init
          wineserver -w
        fi
        # (re)apply display settings when they changed
        if [ "$(cat "$WINEPREFIX/.nix-settings" 2>/dev/null || true)" != "${settings}" ]; then
          wine regedit /S ${settings}
          wineserver -w
          echo "${settings}" > "$WINEPREFIX/.nix-settings"
        fi
      }

      # keep the installer alive while the prefix exists (nix-store comes from the system)
      root_installer() {
        if [ -e ${installerPath} ] && [ ! -L "$WINEPREFIX/installer.exe" ] && command -v nix-store >/dev/null; then
          nix-store --add-root "$WINEPREFIX/installer.exe" --realise ${installerPath} >/dev/null
        fi
      }

      run_installer() {
        if [ ! -e ${installerPath} ]; then
          cat >&2 <<'EOF'
      ${message}
      EOF
          notify-send --app-name="Guitar Pro 8" --icon=dialog-error \
            "Guitar Pro 8 installer missing" \
            "Download it from guitar-pro.com and run: nix-store --add-fixed sha256 guitar-pro-soundbank-full.exe" || true
          exit 1
        fi
        init_prefix
        root_installer
        echo "Running the Guitar Pro 8 installer (this takes a while, the soundbanks are ~1 GB)" >&2
        wine ${installerPath} /SILENT /SUPPRESSMSGBOXES /NORESTART /SP-
        wineserver -w
      }

      install_icons() {
        local icons="''${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor"
        [ -e "$icons/256x256/apps/${pname}.png" ] && return
        local tmp
        tmp="$(mktemp -d)"
        if wrestool --extract --type=14 "$1" > "$tmp/icon.ico" && icotool --extract --output="$tmp" "$tmp/icon.ico"; then
          for png in "$tmp"/icon_*_*x*x32.png; do
            size="$(basename "$png" | sed -E 's/.*_([0-9]+)x[0-9]+x32\.png/\1/')"
            install -Dm644 "$png" "$icons/''${size}x''${size}/apps/${pname}.png"
          done
        fi
        rm -rf "$tmp"
      }

      case "''${1:-}" in
        --help)
          cat <<EOF
      Usage: ${pname} [FILE...]          launch Guitar Pro 8 (installs it on first run)
             ${pname} --install          (re)run the installer in the prefix
             ${pname} --winecfg          open winecfg for the prefix
             ${pname} --winetricks ARGS  run winetricks in the prefix
             ${pname} --wine ARGS        run wine in the prefix
      Prefix: $WINEPREFIX (override with GUITAR_PRO_PREFIX)
      EOF
          exit 0
          ;;
        --install)
          run_installer
          exit 0
          ;;
        --winecfg)
          init_prefix
          exec wine winecfg
          ;;
        --winetricks)
          shift
          init_prefix
          exec winetricks "$@"
          ;;
        --wine)
          shift
          init_prefix
          exec wine "$@"
          ;;
      esac

      exe="$(find_exe)"
      if [ -z "$exe" ]; then
        run_installer
        exe="$(find_exe)"
        if [ -z "$exe" ]; then
          echo "GuitarPro.exe not found in $WINEPREFIX after installing" >&2
          exit 1
        fi
      fi
      init_prefix
      root_installer
      install_icons "$exe"

      # translate files passed on the command line (e.g. from a file manager)
      args=()
      for arg in "$@"; do
        if [ -e "$arg" ]; then
          args+=("$(winepath -w "$arg")")
        else
          args+=("$arg")
        fi
      done

      exec wine "$exe" "''${args[@]}"
    '';
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ${lib.getExe launcher} $out/bin/${pname}
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Guitar Pro 8";
      genericName = "Tablature Editor";
      comment = "Edit, play and learn guitar tablatures";
      exec = "${pname} %F";
      icon = pname;
      categories = [
        "Audio"
        "AudioVideo"
        "Music"
      ];
      startupWMClass = "guitarpro.exe";
    })
  ];

  passthru = {
    inherit
      installer
      launcher
      settings
      wine
      ;
  };

  meta = {
    description = "Guitar tablature editor, run through wine";
    homepage = "https://www.guitar-pro.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
