load("//tools/helm:helm_template.bzl", "helm_template")

package(default_visibility = ["//visibility:public"])

helm_template(
    name = "world",
    chart_tar = "@kubeview//:chart.tgz",
    namespace = "hello-world",
)
