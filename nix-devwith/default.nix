{ substituteAll
, runtimeShell, coreutils, jq
}:

substituteAll {
  name = "nix-devwith";
  src = ./nix-devwith.sh;
  dir = "bin";
  isExecutable = true;

  shell = runtimeShell;

  jq = "${jq}/bin/jq";
  dirname = "${coreutils}/bin/dirname";
  realpath = "${coreutils}/bin/realpath";
}
