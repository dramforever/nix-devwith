# nix-devwith

It's like `nix-shell -p` but it supports flakes

## Nix Flake

This repository contains a Nix Flake. To use it, use the following Flake URL:

```plain
github:dramforever/nix-devwith
```

## Usage

```console
$ nix-devwith <installables>
```

Start a development shell with `<installables>` as build inputs. Examples:

```console
$ nix-devwith nixpkgs#boost.dev
$ nix-devwith nixpkgs#autoPatchelfHook
```

## Caveats

Does not (yet) replicate all details of `nix-shell -p`.
