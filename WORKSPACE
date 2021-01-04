load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Add the 'dataform' repository as a dependency.
git_repository(
    name = "dataform",
    commit = "bd8faf21b9e305aa3571eee4a0eb2b6c92450cae",
    remote = "https://github.com/dataform-co/dataform.git",
)

# Load the Helm repository rules.
load("@dataform//tools/helm:repository_rules.bzl", "helm_chart", "helm_tool")

# Download the 'helm' tool.
helm_tool(
    name = "helm_tool",
)

# Download the 'istio' Helm chart.
helm_chart(
    name = "kubeview",
    chartname = "kubeview",
    repo_url = "https://benc-uk.github.io/kubeview/charts",
    version = "0.1.17",
)
