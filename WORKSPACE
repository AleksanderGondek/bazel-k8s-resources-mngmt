workspace(name = "bazel_k8s_resources_mngmt")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


# Helm templating
git_repository(
  name="dataform_co_dataform",
  commit="5acd97bde5150ce433869603125fc2a14a2aadb4",
  remote="https://github.com/dataform-co/dataform.git",
)
load(
  "@dataform_co_dataform//tools/helm:repository_rules.bzl",
  "helm_chart",
  "helm_tool"
)
helm_tool(name = "helm_tool")


# GitOps Rules
# --
# By default, they are downloading go/kustomize/etc. binaries from github releases
# which means, dynamically linked executables, which will fail in nix-shell / nixos environment.
# Custom patch takes care of that.
#
git_repository(
  name="com_adobe_rules_gitops",
  commit="354e7d3341f05e076f286663731f18caf1e62340",
  remote="https://github.com/adobe/rules_gitops.git",
  shallow_since="1611050644 +0000",
  patches=[
    "//:patches/com_adobe_rules_gitops-add-ability-to-run-in-nixos-environment.patch",
    "//:patches/com_adobe_rules_gitops-add-ability-to-run-in-nixos-environment-2.patch",
  ]
)
load("@com_adobe_rules_gitops//gitops:deps.bzl", "rules_gitops_dependencies")
rules_gitops_dependencies()

# Ensure will work on NixOS
rules_io_tweag_nixpkgs_version = "acb9e36f403ec6f38bac81290781cb896f22a85e"
http_archive(
    name = "io_tweag_rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-%s" % rules_io_tweag_nixpkgs_version,
    urls = [ "https://github.com/tweag/rules_nixpkgs/archive/%s.tar.gz" % rules_io_tweag_nixpkgs_version ],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")
rules_nixpkgs_dependencies()

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository")
nixpkgs_git_repository(
  name = "nixpkgs",
  revision = "20.09",
)
local_repository(
    name = "golanch_patch",
    path = "tools/golang_patch",
)

load("@golanch_patch//:nixos_support.bzl", "gen_imports")
gen_imports()

load("@nixos_support_golang//:imports.bzl", "nixos_golang_patch")
nixos_golang_patch()

load("@com_adobe_rules_gitops//gitops:repositories.bzl", "rules_gitops_repositories")
rules_gitops_repositories()


# Container images (on NixOs need above golang tweak)
http_archive(
  name = "io_bazel_rules_docker",
  sha256 = "6287241e033d247e9da5ff705dd6ef526bac39ae82f3d17de1b69f8cb313f9cd",
  strip_prefix = "rules_docker-0.14.3",
  urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.3/rules_docker-v0.14.3.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")
container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")


# K8s Rules
http_archive(
  name = "io_bazel_rules_k8s",
  strip_prefix = "rules_k8s-0.5",
  urls = ["https://github.com/bazelbuild/rules_k8s/archive/v0.5.tar.gz"],
  sha256 = "773aa45f2421a66c8aa651b8cecb8ea51db91799a405bd7b913d77052ac7261a",
)

load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")
k8s_repositories()

load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_deps = "deps")
k8s_go_deps()


## Download the 'kubeview' Helm chart.
helm_chart(
  name = "kubeview",
  chartname = "kubeview",
  repo_url = "https://benc-uk.github.io/kubeview/charts",
  version = "0.1.17",
)
# helm install helm-operator center/fluxcd/helm-operator
helm_chart(
  name = "center",
  chartname = "fluxcd/helm-operator",
  repo_url = "https://repo.chartcenter.io",
  version = "1.2.0",
)


## External images to pull
container_pull(
  name = "kubeview_image",
  registry = "docker.io",
  repository = "bencuk/kubeview",
  # 'tag' is also supported, but digest is encouraged for reproducibility.
  digest = "sha256:c7d39e1669991f258bdb32c743548a4a19c6e62d7d78f6a1cece77d0e11e12cc",
)
