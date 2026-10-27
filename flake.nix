{
  description = "Daggerfall Online for Nix";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs =
    { self, nixpkgs }:
    let
      systemPkgs = system: f: f nixpkgs.legacyPackages.${system} system;
    in
    {
      packages = {
        x86_64-linux = systemPkgs "x86_64-linux" (
          pkgs: system: {
            daggerfall-js = pkgs.callPackage ./packages/linux.nix { };
            default = self.packages.${system}.daggerfall-js;
          }
        );
        aarch64-darwin = systemPkgs "aarch64-darwin" (
          pkgs: system: {
            daggerfall-js = pkgs.callPackage ./packages/darwin.nix { };
            default = self.packages.${system}.daggerfall-js;
          }
        );
      };
    };
}
