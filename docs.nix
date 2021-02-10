{ }:

let
  pkgs = import (
    fetchTarball { url = https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz;}
  ) {};
in
  pkgs.stdenv.mkDerivation({
    name = "bazel-k8s-docs";
    srcs = [
      ./docs
    ];

    buildInputs = with pkgs; [ 
      bash
      coreutils
      mkdocs
    ];

    buildPhase = ''
      mkdir -p docs
      find . -maxdepth 1 ! -name docs ! -name . ! -name .. ! -name mkdocs.yml -exec mv -t ./docs {} +
      mkdocs build
    '';

    installPhase = ''
      mkdir -p $out
      cp -r site/* $out
    '';
  })
