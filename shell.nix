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

    # 'Patched' adobe rules_gitops
    export BZL_ADOBE_RULES_GITOPS_DIR="./vendored/github.com/adobe/rules_gitops"
    if [ ! -d "$BZL_ADOBE_RULES_GITOPS_DIR" ]; then
      export _PROJECT_ROOT=$(pwd)

      mkdir -p "$BZL_ADOBE_RULES_GITOPS_DIR"
      git clone https://github.com/adobe/rules_gitops.git "$BZL_ADOBE_RULES_GITOPS_DIR" > /dev/null 2>&1
      cd "$BZL_ADOBE_RULES_GITOPS_DIR"
      git checkout d80ee3af3c5de5659f24eb3e702a74dba5ad04ec > /dev/null 2>&1

      # Apply patch
      git apply --check $_PROJECT_ROOT/patches/0001-Add-ability-to-run-in-nixos-environment.patch
      git am $_PROJECT_ROOT/patches/0001-Add-ability-to-run-in-nixos-environment.patch

      rm -rf ./.git/
      cd "$_PROJECT_ROOT"
      unset _PROJECT_ROOT
    fi
    echo 'Bazel k8s resources mngmt dev shell ready - happy hacking!'
  '';
}
