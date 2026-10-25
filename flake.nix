{
  description = "Daggerfall Online Appimage for Nix";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs =
    { self, nixpkgs }:
    let
      systemPkgs = system: f: { ${system} = f nixpkgs.legacyPackages.${system} system; };

      pname = "daggerfall-js";
      version = "0.1.11168";
    in
    {
      packages = (
        systemPkgs "x86_64-linux" (
          pkgs: system: {
            daggerfall-js = pkgs.appimageTools.wrapType2 (finalAttrs: {
              inherit pname version;
              __structuredAttrs = true;
              strictDeps = true;

              src = pkgs.fetchurl {
                url = "https://github.com/Lattymoy/daggerfall-js-source/releases/download/app-v${finalAttrs.version}/DaggerfallOnline-linux-x86_64.AppImage";
                hash = "sha256-a7kwayoCWQdEqjtmdTbrBlhQZSeM8rKiz8cZw3+CQN4=";
              };
            });

            default = self.packages.${system}.daggerfall-js;
          }
        )
      )
      # // (systemPkgs "aarch64-darwin" (
      #   pkgs: system: {
      #     daggerfall-js = pkgs.stdenv.mkDerivation (finalAttrs: {
      #       inherit pname version;
      #       __structuredAttrs = true;
      #       strictDeps = true;
      #
      #       src = {
      #         url = "https://github.com/Lattymoy/daggerfall-js-source/releases/download/app-v${finalAttrs.version}/DaggerfallOnline-mac-arm64.dmg";
      #         hash = "";
      #       };
      #     });
      #
      #     default = self.packages.${system}.daggerfall-js;
      #   }
      # ))
      ;
    };
}
