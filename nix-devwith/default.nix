{ writeShellApplication
, util-linux, coreutils, jq
}:

writeShellApplication {
  name = "nix-devwith";
  text = builtins.readFile ./nix-devwith.sh;
  runtimeInputs = [ util-linux coreutils jq ];
}
