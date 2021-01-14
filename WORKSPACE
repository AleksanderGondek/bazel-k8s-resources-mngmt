workspace(name = "bazel_k8s_resources_mngmt")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Helm templating
load("//tools/helm:repository_rules.bzl", "helm_chart", "helm_tool")
helm_tool(name = "helm_tool")

## Download the 'kubeview' Helm chart.
helm_chart(
  name = "kubeview",
  chartname = "kubeview",
  repo_url = "https://benc-uk.github.io/kubeview/charts",
  version = "0.1.17",
)

# GitOps Rules
# --
# By default, they are downloading go/kustomize/etc. binaries from github releases
# which means, dynamically linked executables, which will fail in nix-shell / nixos environment.
# 
# ## To use unpatched/not-vendored version, uncomment the following:
# 
# rules_gitops_version = "8d9416a36904c537da550c95dc7211406b431db9"
# http_archive(
#   name = "com_adobe_rules_gitops",
#   sha256 = "25601ed932bab631e7004731cf81a40bd00c9a34b87c7de35f6bc905c37ef30d",
#   strip_prefix = "rules_gitops-%s" % rules_gitops_version,
#   urls = ["https://github.com/adobe/rules_gitops/archive/%s.zip" % rules_gitops_version],
# )
# load("@com_adobe_rules_gitops//gitops:deps.bzl", "rules_gitops_dependencies")
# rules_gitops_dependencies()
# 
# load("@com_adobe_rules_gitops//gitops:repositories.bzl", "rules_gitops_repositories")
# rules_gitops_repositories(
# 
# 
# ## Vendored & Patched version of adobe rules_gitops
# 
# Rules below are utilizing nix-pkgs based binaries
# 
local_repository(
  name = "com_adobe_rules_gitops",
  path = "./vendored/github.com/adobe/rules_gitops",
)
load("@com_adobe_rules_gitops//gitops:deps.bzl", "rules_gitops_dependencies")
rules_gitops_dependencies()


# Section: If NixOS, do some patching
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


# Load gitops_rules dependencies
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

## External images to pull
container_pull(
  name = "kubeview_image",
  registry = "docker.io",
  repository = "bencuk/kubeview",
  # 'tag' is also supported, but digest is encouraged for reproducibility.
  digest = "sha256:c7d39e1669991f258bdb32c743548a4a19c6e62d7d78f6a1cece77d0e11e12cc",
)

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
