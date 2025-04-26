{
  description = "A replacement for nix-shell -p for flakes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in rec {
          inherit (pkgs) nix-devwith;
          default = nix-devwith;
        };
    }) // {
      checks = self.packages;

      overlays.default = final: prev: {
        nix-devwith = final.callPackage ./nix-devwith {};
      };
    };
}
