load("//tools/helm:repository_rules.bzl", "helm_chart", "helm_tool")

# Download the 'helm' tool.
helm_tool(
    name = "helm_tool",
)

# Download the 'kubeview' Helm chart.
helm_chart(
    name = "kubeview",
    chartname = "kubeview",
    repo_url = "https://benc-uk.github.io/kubeview/charts",
    version = "0.1.17",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# GitOps Rules
rules_gitops_version = "8d9416a36904c537da550c95dc7211406b431db9"
http_archive(
    name = "com_adobe_rules_gitops",
    sha256 = "25601ed932bab631e7004731cf81a40bd00c9a34b87c7de35f6bc905c37ef30d",
    strip_prefix = "rules_gitops-%s" % rules_gitops_version,
    urls = ["https://github.com/adobe/rules_gitops/archive/%s.zip" % rules_gitops_version],
)
load("@com_adobe_rules_gitops//gitops:deps.bzl", "rules_gitops_dependencies")
rules_gitops_dependencies()

# Fix Go for Nix
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
    revision = "20.09", # Any tag or commit hash
    sha256 = "" # optional sha to verify package integrity!
)
# This part should be "if nix..."
load("@io_tweag_rules_nixpkgs//nixpkgs:toolchains/go.bzl", "nixpkgs_go_configure")
nixpkgs_go_configure(repository = "@nixpkgs")

# Continuation of rules gitops repositoreis
load("@com_adobe_rules_gitops//gitops:repositories.bzl", "rules_gitops_repositories")
rules_gitops_repositories()
