#!@shell@

getPath() {
    nix build --no-link --json "$@" | @jq@ -r '.[].outputs[]'
}

getAllPaths() {
    if [ "$#" -eq "0" ]; then
        echo
    else
        getPath "$@"
    fi
}

set -e

stdenv="$(getPath nixpkgs\#stdenv)"
store="$(nix eval --raw --expr builtins.storeDir)"
bashPath="$(@dirname@ "$(@realpath@ "$(type -p bash)")")"

exec bash --rcfile /proc/self/fd/19 19<<END
export NIX_BUILD_TOP="$(pwd)"
export NIX_STORE="$store"
export out="/var/empty"
export buildInputs="$(getAllPaths "$@")"
export noDumpEnvVars=1
export savedPath="\$PATH"
source "$stdenv"/setup
unset NIX_ENFORCE_PURITY
export PATH="$bashPath:\$PATH:\$savedPath"
[ -f ~/.bashrc ] && source ~/.bashrc
set +e
END
