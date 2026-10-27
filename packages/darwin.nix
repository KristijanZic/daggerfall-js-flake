{
  stdenvNoCC,
  fetchurl,
  undmg,
  ...
}:
let
  pname = "daggerfall-js";
  version = "0.1.11682";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = version;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Lattymoy/daggerfall-js-source/releases/download/app-v${finalAttrs.version}/DaggerfallOnline-mac-arm64.dmg";
    hash = "sha256-tMDTJVFdBOhKI4KKa3tsE4GJxnS/uPTrRxGzHamxsU0=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  unpackPhase = ''
    undmg "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -pR "DFO Online.app" "$out/Applications/"
    runHook postInstall
  '';
})
