""" To be described. """

workspace(name = "bazel_k8s_resources_mngmt")

load(
  "@bazel_tools//tools/build_defs/repo:git.bzl",
  "git_repository",
  "new_git_repository"
)
load(
  "@bazel_tools//tools/build_defs/repo:http.bzl",
  "http_archive"
)


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


# Download Argo repository
new_git_repository(
  name="argoproj_argo",
  commit="5f5150730c644865a5867bf017100732f55811dd",
  remote="https://github.com/argoproj/argo.git",
  shallow_since = "1612215927 -0800",
  build_file_content = "exports_files(['manifests/namespace-install.yaml'])",
)


# Download Argo events repo
new_git_repository(
  name="argoproj_argo_events",
  commit="976f205f1044af9680927e47618cf32b522e15c9",
  remote="https://github.com/argoproj/argo-events.git",
  shallow_since = "1611769037 -0800",
  build_file_content = "exports_files(['manifests/namespace-install.yaml'])",
)



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

helm_chart(
  name = "helm_postgresql",
  chartname = "postgresql",
  repo_url = "https://charts.bitnami.com/bitnami",
  version = "10.2.6",
)

helm_chart(
  name = "helm_minio",
  chartname = "minio",
  repo_url = "https://charts.bitnami.com/bitnami",
  version = "6.1.3",
)


# Container images
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
container_pull(
  name = "kubeview_image",
  registry = "docker.io",
  repository = "bencuk/kubeview",
  digest = "sha256:c7d39e1669991f258bdb32c743548a4a19c6e62d7d78f6a1cece77d0e11e12cc",
)

container_pull(
  name = "bitnami_postgresql_image",
  registry = "docker.io",
  repository = "bitnami/postgresql",
  digest = "sha256:1865ce08f82ab14fe779513a94e8877063a44571a4f2308c160f7fccb7fccd90",
)

container_pull(
  name = "bitnami_minio_image",
  registry = "docker.io",
  repository = "bitnami/minio",
  digest = "sha256:1987305951a7be62cbfe397493eb4ed931a063e5f703fb244be7232286a5e1b8",
)

container_pull(
  name = "argo_cli_image",
  registry = "docker.io",
  repository = "argoproj/argocli",
  digest = "sha256:17d8ded691aac38c8ca5f4d1e030d4411c66fe2a057cfd837ade54b7cd561d0d",
)

container_pull(
  name = "argo_exec_image",
  registry = "docker.io",
  repository = "argoproj/argoexec",
  digest = "sha256:eaa03299021190338e34df4e57c3cc44a3931e66c6429e7c756fe49f6da34660",
)

container_pull(
  name = "argo_workflow_controller_image",
  registry = "docker.io",
  repository = "argoproj/workflow-controller",
  digest = "sha256:f0ec247f3bbe110d8c967f8458a02bc722d7c2094f5eb77eb06b783470357f5d",
)

container_pull(
  name = "argo_sensor_controller_image",
  registry = "docker.io",
  repository = "argoproj/sensor-controller",
  digest = "sha256:f8561298fbf1c20eb4687e3ae35244e18adfc735e18c2f527d85b638f2cbb37b",
)

container_pull(
  name = "argo_eventsource_controller_image",
  registry = "docker.io",
  repository = "argoproj/eventsource-controller",
  digest = "sha256:b8e8757c2ae63befbf3b4241454b9e7603a0a359c41fe7885a0b462a4fe06669",
)

container_pull(
  name = "argo_eventbus_controller_image",
  registry = "docker.io",
  repository = "argoproj/eventbus-controller",
  digest = "sha256:e52874479ffdda10709406bc541506428fa9b4b9a734615bc45e580e73f76ac0",
)

container_pull(
  name = "argo_sensor_image",
  registry = "docker.io",
  repository = "argoproj/sensor",
  digest = "sha256:e027b076ae01890113ea89da88ab93bab44485ff633f6d58f82c93c706f0ac8e",
)

container_pull(
  name = "argo_sensor_eventsource_image",
  registry = "docker.io",
  repository = "argoproj/eventsource",
  digest = "sha256:c7bfb84eb5ec380959d0c0e3a9a5ed7387f76232bcf2ff6e165d515698562540",
)
