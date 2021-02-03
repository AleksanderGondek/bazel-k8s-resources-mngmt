workspace(name = "bazel_k8s_resources_mngmt")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


# Bazel rules for materializing helm charts
git_repository(
  name="dataform_co_dataform",
  commit="69d94367d3a417de1bc370994c5c2d4a2c810854",
  shallow_since = "1612343338 +0000",
  remote="https://github.com/dataform-co/dataform.git",
)
load(
  "@dataform_co_dataform//tools/helm:repository_rules.bzl",
  "helm_chart",
  "helm_tool"
)
helm_tool(name = "helm_tool")


# Bazel rules for running kustomize on resources
git_repository(
  name="com_adobe_rules_gitops",
  commit="94f689221fc69e30ee25ef82c1a43efa793fb463",
  remote="https://github.com/adobe/rules_gitops.git",
  shallow_since = "1611958260 -0800",
  patches=[
    "//:patches/com_adobe_rules_gitops-add-ability-to-run-in-nixos-environment.patch",
  ]
)
load("@com_adobe_rules_gitops//gitops:deps.bzl", "rules_gitops_dependencies")
rules_gitops_dependencies()


# Patching golang binaries for NixOS
rules_io_tweag_nixpkgs_version = "acb9e36f403ec6f38bac81290781cb896f22a85e"
http_archive(
    name = "io_tweag_rules_nixpkgs",
    sha256 = "52c5ab0b68841b96463e1bd44760ef2bbbffa0804873496b6e0f982f5b3176f6",
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


# Bazel rules for interaction with container images

## See: https://github.com/bazelbuild/rules_docker/issues/1687
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.1.0/rules_python-0.1.0.tar.gz",
    sha256 = "b6d46438523a3ec0f3cead544190ee13223a52f6a6765a29eae7b7cc24cc83a0",
)
http_archive(
  name = "io_bazel_rules_docker",
  sha256 = "1698624e878b0607052ae6131aa216d45ebb63871ec497f26c67455b34119c80",
  strip_prefix = "rules_docker-0.15.0",
  urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.15.0/rules_docker-v0.15.0.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")
container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()


# Bazel rules for dealing with K8s manifests
http_archive(
  name = "io_bazel_rules_k8s",
  strip_prefix = "rules_k8s-0.6",
  urls = ["https://github.com/bazelbuild/rules_k8s/archive/v0.6.tar.gz"],
  sha256 = "51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef",
)

load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")
k8s_repositories()

load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_deps = "deps")
k8s_go_deps()


# Helm charts
helm_chart(
  name = "kubeview",
  chartname = "kubeview",
  repo_url = "https://benc-uk.github.io/kubeview/charts",
  version = "0.1.17",
)

helm_chart(
  name = "center",
  chartname = "fluxcd/helm-operator",
  repo_url = "https://repo.chartcenter.io",
  version = "1.2.0",
)


# Container images
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
container_pull(
  name = "kubeview_image",
  registry = "docker.io",
  repository = "bencuk/kubeview",
  # 'tag' is also supported, but digest is encouraged for reproducibility.
  digest = "sha256:c7d39e1669991f258bdb32c743548a4a19c6e62d7d78f6a1cece77d0e11e12cc",
)
