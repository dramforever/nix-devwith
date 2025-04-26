#!/usr/bin/env bash

set -e -o pipefail

getPath() {
    nix build --no-link --json "$@" | jq -r '.[].outputs[]'
}

getAllPaths() {
    if [ "$#" -eq "0" ]; then
        echo
    else
        getPath "$@"
    fi
}

fixedArgs=()

for arg in "$@"; do
    if [[ "$arg" == *^* ]]; then
        # Has output specifier
        fixedArgs+=("$arg")
    else
        # No output specifier
        fixedArgs+=("${arg}^*")
    fi
done

stdenv="$(getPath nixpkgs\#stdenv)"
store="$(nix eval --raw --expr builtins.storeDir)"
bashPath="$(dirname "$(realpath "$(type -p bash)")")"
allPaths="$(getAllPaths "${fixedArgs[@]}")"

exec bash --rcfile /proc/self/fd/19 19<<END
export NIX_BUILD_TOP="$(pwd)"
export NIX_STORE="$store"
export out="/var/empty"
export buildInputs="$allPaths"
export noDumpEnvVars=1
export savedPath="\$PATH"
source "$stdenv"/setup
unset NIX_ENFORCE_PURITY
export PATH="$bashPath:\$PATH:\$savedPath"
[ -f ~/.bashrc ] && source ~/.bashrc
set +e
END
