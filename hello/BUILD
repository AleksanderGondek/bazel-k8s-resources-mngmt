load("//tools/helm:helm_template.bzl", "helm_template")

package(default_visibility = ["//visibility:public"])

helm_template(
    name = "world",
    chart_tar = "@kubeview//:chart.tgz",
    namespace = "hello-world",
)

load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")

k8s_deploy(
    name = "release",
    namespace = "hello-world-prod",
    #image_digest_tag = True,  # test optional image tagging
    # images = {
    #     "helloworld-image": ":image",
    # },
    manifests = [
        ":world",
    ],
)
