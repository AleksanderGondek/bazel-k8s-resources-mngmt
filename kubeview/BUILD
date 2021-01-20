load("@dataform_co_dataform//tools/helm:helm_template.bzl", "helm_template")
load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

package(default_visibility = ["//visibility:public"])

helm_template(
  name = "helm-chart",
  chart_tar = "@kubeview//:chart.tgz",
  include_crds = True,
  namespace = "hello-world",
  values = {
    "limitNamespace": "true",
    "ingress.enabled": "true",
    "ingress.hosts[0].host": "*",
    "ingress.hosts[0].paths[0]": "/",
    "image.repository": "docker.io/aleksandergondek/kubeview",
    "image.tag": "dev",
    "image.pullPolicy": "IfNotPresent",
  },
)

helm_template(
  name = "fluxcd",
  chart_tar = "@center//:chart.tgz",
  include_crds = True,
  namespace = "this-is-a-test",
  values = {},
)

container_image(
  name = "image",
  base = "@kubeview_image//image",
)

k8s_deploy(
  name = "kustomize-dev",
  common_labels = {
    "app.kubernetes.io/name": "awesome-kubeview-dev",
  },
  manifests = [
    ":deployments/dev/kubeview.ns.yaml",
    ":helm-chart",
  ],
  patches = [
    ":overlays/dev/kubeview.deploy.yaml"
  ],
  namespace = "kubeview",
)

k8s_deploy(
  name = "kustomize-prod",
  common_labels = {
    "app.kubernetes.io/name": "awesome-kubeview-prod",
  },
  manifests = [
    ":deployments/prod/kubeview.ns.yaml",
    ":helm-chart",
  ],
  patches = [
    ":overlays/prod/kubeview.deploy.yaml"
  ],
  namespace = "prod-kubeview",
)

k8s_object(
  name = "dev",
  cluster = "local",
  images = {
    "docker.io/aleksandergondek/kubeview:dev": "@kubeview_image//image",
  },
  kind = "deployment",
  template = ":kustomize-dev",
)

k8s_object(
  name = "prod",
  cluster = "local",
  images = {
    "docker.io/aleksandergondek/kubeview:dev": "@kubeview_image//image",
  },
  kind = "deployment",
  template = ":kustomize-prod",
)
