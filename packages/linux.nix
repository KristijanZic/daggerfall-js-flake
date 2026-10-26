{ appimageTools, fetchurl, ... }:
let
  pname = "daggerfall-js";
  version = "0.1.11785";
in
appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Lattymoy/daggerfall-js-source/releases/download/app-v${finalAttrs.version}/DaggerfallOnline-linux-x86_64.AppImage";
    hash = "sha256-rVQw9xBGQoZb5nwV6Q143TnFy5pQhxoCVymHhuYb/+4=";
  };
})
