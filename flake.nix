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
            overlays = [ self.overlay ];
          };
        in {
          inherit (pkgs) nix-devwith;
        };

        apps = {
          nix-devwith = {
            type = "app";
            description = "nix-devwith";
            program = "${self.packages.${system}.nix-devwith}/bin/nix-devwith";
          };
        };

        defaultPackage = self.packages.${system}.nix-devwith;
        defaultApp = self.apps.${system}.nix-devwith;
    }) // {
      checks = self.packages;

      overlay = final: prev: {
        nix-devwith = final.callPackage ./nix-devwith {};
      };
    };
}
