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
    hash = "sha256-Cq52X7TUuT2fBCY2MZgZWgI9icBfTqyL0D7+EgF/a80=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  unpackPhase = ''
    undmg "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -pR "${finalAttrs.pname}.app" "$out/Applications/"
    runHook postInstall
  '';
})
