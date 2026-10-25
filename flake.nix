{
  description = "Daggerfall Online for Nix";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      versions = builtins.fromJSON (builtins.readFile ./versions.json);
      systemPkgs = system: f: f nixpkgs.legacyPackages.${system} system;
      allSystems = f: lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: systemPkgs system f);
    in
    {
      packages = {
        x86_64-linux = systemPkgs "x86_64-linux" (
          pkgs: system: {
            daggerfall-js = pkgs.appimageTools.wrapType2 (finalAttrs: {
              pname = "daggerfall-js";
              inherit (versions) version;
              __structuredAttrs = true;
              strictDeps = true;
              src = pkgs.fetchurl versions.${system};
            });

            default = self.packages.${system}.daggerfall-js;
          }
        );
        # aarch64-darwin = systemPkgs "aarch64-darwin" (
        #   pkgs: system: {
        #     daggerfall-js = pkgs.stdenv.mkDerivation (finalAttrs: {
        #       pname = "daggerfall-js";
        #       inherit (versions) version;
        #       __structuredAttrs = true;
        #       strictDeps = true;
        #       src = pkgs.fetchurl { inherit (versions.${system}) url hash; };
        #     });
        #
        #     default = self.packages.${system}.daggerfall-js;
        #   }
        # );
      };
      apps = allSystems (
        pkgs: system: {
          update = {
            type = "app";
            meta.description = "Update version_data.json";
            program = lib.getExe (
              pkgs.writeShellApplication {
                name = "Update DFO Online";
                derivationArgs = {
                  allowSubstitutes = false;
                  preferLocalBuild = true;
                };
                runtimeInputs = with pkgs; [
                  jq
                  curl
                ];
                text = ''
                  VERSION=$(curl --silent "https://api.github.com/repos/Lattymoy/daggerfall-js-source/releases/latest" | jq -r .tag_name)
                  LINUX_URL="https://github.com/Lattymoy/daggerfall-js-source/releases/download/$VERSION/DaggerfallOnline-linux-x86_64.AppImage"
                  LINUX_HASH=$(nix store prefetch-file --json "$LINUX_URL" | jq -r .hash)
                  MAC_URL="https://github.com/Lattymoy/daggerfall-js-source/releases/download/$VERSION/DaggerfallOnline-mac-arm64.dmg"
                  MAC_HASH=$(nix store prefetch-file --json "$MAC_URL" | jq -r .hash)
                  jq -n \
                    --arg version "$VERSION" \
                    --arg linuxhash "$LINUX_HASH" \
                    --arg machash "$MAC_HASH" \
                    --arg linuxurl "$LINUX_URL" \
                    --arg macurl "$MAC_URL" \
                    '{ version: $version, "x86_64-linux": { hash: $linuxhash, url: $linuxurl }, "aarch64-darwin": { hash: $machash, url: $macurl }}' \
                    > versions.json
                '';
              }
            );
          };
        }
      );
    };
}
