{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  # clice builds with Bazel against its own LLVM/Clang release (xclang), which
  # is impractical to reproduce in the Nix sandbox, so this repackages the
  # prebuilt release archives. Besides glibc the binary links nothing.
  platforms = {
    x86_64-linux = {
      target = "x86_64-unknown-linux-gnu";
      hash = "sha256-ndGBqsnIHK52slXpU9ohyeYD/FtAZEfrJsler2ftlpo=";
    };
    aarch64-linux = {
      target = "aarch64-unknown-linux-gnu";
      hash = "sha256-t+ts5lr7nNxSKdrfGxpWFIXc2ykqBtaIV81gl3FvCLo=";
    };
    aarch64-darwin = {
      target = "aarch64-apple-darwin";
      hash = "sha256-lBrNbsTHRkRKVABkUiCc0O+Y9aNO7lCJUgAWxApB+Cw=";
    };
  };
  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "clice: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clice";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/clice-io/clice/releases/download/v${finalAttrs.version}/clice-${finalAttrs.version}.${platform.target}.tar.gz";
    inherit (platform) hash;
  };

  sourceRoot = "clice";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;
  # the release is already stripped; keep the clang builtin headers untouched
  dontStrip = true;

  # clice finds the clang builtin headers relative to its executable
  # (bin/../lib/clang/<major>), so bin/ and lib/ have to stay side by side and
  # the binary must not be wrapped.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/doc/clice
    cp -r bin lib $out/
    cp clice.toml LICENSE $out/share/doc/clice/
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/clice --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Next-generation C++ language server for modern C++";
    homepage = "https://github.com/clice-io/clice";
    changelog = "https://github.com/clice-io/clice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames platforms;
    mainProgram = "clice";
  };
})
