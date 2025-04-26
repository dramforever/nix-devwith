#!/usr/bin/env bash

set -e -o pipefail

usage() {
    echo "Usage: $0 [--stdenv INSTALLABLE] [--] INSTALLABLES"
    exit 1
}

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

opts="$(getopt --name nix-devwith --shell bash --options '' \
    --longoptions 'stdenv:,help,usage' \
    -- "$@" \
    || usage >&2)"

eval set -- "$opts"

stdenv="nixpkgs#stdenv"

while true; do
    case "$1" in
        --stdenv)
            shift
            stdenv="$1"
            shift
            ;;
        --help|--usage)
            shift
            usage
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Shouldn't happen while parsing arguments?" >&2
            exit 1
            ;;
    esac
done

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

stdenvPath="$(getPath "$stdenv")"
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
source "$stdenvPath"/setup
unset NIX_ENFORCE_PURITY
export PATH="$bashPath:\$PATH:\$savedPath"
[ -f ~/.bashrc ] && source ~/.bashrc
set +e
END
