{ writeShellApplication
, coreutils, jq
}:

writeShellApplication {
  name = "nix-devwith";
  text = builtins.readFile ./nix-devwith.sh;
  runtimeInputs = [ coreutils jq ];
}
