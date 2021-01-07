load("//tools/helm:helm_template.bzl", "helm_template")

package(default_visibility = ["//visibility:public"])

helm_template(
    name = "helm-chart",
    chart_tar = "@kubeview//:chart.tgz",
    namespace = "hello-world",
    values = {
        "limitNamespace": "true",
        "ingress.enabled": "true",
        "ingress.hosts[0].host": "*",
        "ingress.hosts[0].paths[0]": '/',
        "image.repository": "docker.io/aleksandergondek/kubeview",
        "image.tag": "dev",
        "image.pullPolicy": "IfNotPresent",
    },
    include_crds = True,
    # Helm doesn't render it anyway :)
    create_namespace = True,
)

load("@io_bazel_rules_docker//container:container.bzl", "container_image")
container_image(
    name = "image",
    base = "@kubeview_image//image"
)


load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")

k8s_deploy(
    name = "kustomize-dev",
    namespace = "kubeview",
    common_labels = {
        "app.kubernetes.io/name": "awesome-kubeview-dev",
    },
    manifests = [
        ":deployments/dev/kubeview.ns.yaml",
        ":helm-chart",
    ],
)

k8s_deploy(
    name = "kustomize-prod",
    namespace = "prod-kubeview",
    common_labels = {
        "app.kubernetes.io/name": "awesome-kubeview-prod",
    },
    manifests = [
        ":deployments/prod/kubeview.ns.yaml",
        ":helm-chart",
    ],
)

load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_object(
  name = "dev",
  kind = "deployment",
  cluster = "local",
  template = ":kustomize-dev",
  images = {
    "docker.io/aleksandergondek/kubeview:dev": "@kubeview_image//image"
  },
)

load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_object(
  name = "prod",
  kind = "deployment",
  cluster = "local",
  template = ":kustomize-prod",
  images = {
    "docker.io/aleksandergondek/kubeview:dev": "@kubeview_image//image"
  },
)
