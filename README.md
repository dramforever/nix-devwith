# nix-devwith

It's like `nix-shell -p` but it supports flakes

## What's wrong with `nix shell`?

`nix-shell -p` starts a `mkShell` environment, rather than just adding the flakes to `$PATH`. This means that things like libraries or Python packages or shell functions will not work. `nix-devwith` fixes this by actually loading the `stdenv` setup script.

## Nix Flake

This repository contains a Nix Flake. To use it, use the following Flake URL:

```plain
github:dramforever/nix-devwith
```

## Usage

```console
$ nix-devwith [--stdenv INSTALLABLE] [--] INSTALLABLES
```

## Examples

Basic usage:

```console
$ nix-devwith nixpkgs#boost
$ nix-devwith nixpkgs#autoPatchelfHook
```

Cross compilation: (Uses Bash [brace expansion])

```console
$ nix-devwith --stdenv nixpkgs#pkgsCross.riscv64.{stdenv,openssl,pkgsBuildHost.clang}
```

[brace expansion]: https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html

## Caveats

Does not (yet) replicate all details of `nix-shell -p` or `nix develop`.
