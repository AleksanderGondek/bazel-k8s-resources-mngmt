load("//tools/helm:helm_template.bzl", "helm_template")

package(default_visibility = ["//visibility:public"])

helm_template(
    name = "helm_chart",
    chart_tar = "@kubeview//:chart.tgz",
    namespace = "hello-world",
    values = {
        "limitNamespace": "true",
        "ingress.enabled": "true",
        "ingress.hosts[0].host": "*",
        "ingress.hosts[0].paths[0]": '/',
    },
    include_crds = True,
    # Helm doesn't render it anyway :)
    create_namespace = True,
)

load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")

k8s_deploy(
    name = "dev",
    namespace = "kubeview",
    manifests = [
        ":kubeview.ns.yaml",
        ":helm_chart",
    ],
)
