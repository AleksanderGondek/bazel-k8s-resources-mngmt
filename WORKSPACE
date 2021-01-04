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
