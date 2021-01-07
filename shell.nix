{ }:

let
  pkgs = import (
    fetchTarball { url = https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz;}
  ) {};
in
pkgs.mkShell {
  name = "bazel-k8s-resources-mngmt-dev-shell";

  buildInputs = with pkgs; [
    bash
    busybox
    bazel
    bazel-buildtools
    cacert
    coreutils-full
    gitFull
    kubectl
    kubernetes-helm
    kustomize
    nix
  ];

  shellHook = ''
    mkdir -p ./.helm/cache
    mkdir -p ./.helm/config
    mkdir -p ./.helm/data
    mkdir -p ./.helm/repository-cache

    export HELM_CACHE_HOME=$(pwd)/.helm/cache
    export HELM_CONFIG_HOME=$(pwd)/.helm/config
    export HELM_DATA_HOME=$(pwd)/.helm/data
    export HELM_REPOSITORY_CACHE=$(pwd)/.helm/repository-cache

    echo 'Bazel k8s resources mngmt dev shell ready - happy hacking!'
  '';
}
