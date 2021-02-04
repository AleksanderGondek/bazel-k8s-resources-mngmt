load("@com_adobe_rules_gitops//gitops:defs.bzl", "k8s_deploy")
load("@dataform_co_dataform//tools/helm:helm_template.bzl", "helm_template")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")


exports_files([
  "argo.ns.yaml",
  "argo-custom.secret.yaml",
  "argo-workflow-controller-configmap.yaml",
])


k8s_object(
  name = "ns",
  kind = "Namespace",
  cluster = "local",
  template = "//argo:argo.ns.yaml",
)

k8s_object(
  name = "argo-custom",
  kind = "Secret",
  cluster = "local",
  namespace = "argo-workflows",
  template = "//argo:argo-custom.secret.yaml",
  substitutions = {
    "%{minio-access-key}": "T3VuY2VCdXR0b25Db21wbGljYXRlVGlja2V0",
    "%{minio-secret-key}": "UHJvbm91bmNlQ29ycmVjdFNob290V2lkb3dlcg==",
    "%{argo-postgres-user}": "YXJnby1wb3N0Z3Jlcy11c2Vy",
    "%{argo-postgres-pass}": "Vm9pY2VQbGF5QWxpa2VEYW5nZXI=",
  },
)

helm_template(
  name = "argo-postgresql",
  chart_tar = "@helm_postgresql//:chart.tgz",
  include_crds = True,
  namespace = "argo-workflows",
  values = {
    "global.storageClass": "hostpath",
    "psp.create": "true",
    "rbac.create": "true",
    "image.registry": "docker.io",
    "image.repository": "bitnami/postgresql",
    "image.tag": "11.10.0-debian-10-r60",
    "primary.podAffinityPreset": "hard",
    "global.postgresql.postgresqlDatabase": "argo-postgres",
    "global.postgresql.postgresqlUsername": "argo-postgres-user",
    "global.postgresql.postgresqlPassword": "VoicePlayAlikeDanger"
  },
)

helm_template(
  name = "argo-minio",
  chart_tar = "@helm_minio//:chart.tgz",
  include_crds = True,
  namespace = "argo-workflows",
  values = {
    "global.storageClass": "hostpath",
    "defaultBuckets": "argo-artifacts",
    "ingress.enabled": "true",
    "ingress.hostname": "argo.blackwood",
    "image.registry": "docker.io",
    "image.repository": "bitnami/minio",
    "image.tag": "2021.2.1-debian-10-r0",
    "podAffinityPreset": "hard",
    "clientImage.registry": "docker.io",
    "clientImage.repository": "bitnami/minio-client",
    "clientImage.tag": "2021.1.30-debian-10-r2",
    "global.minio.accessKey": "OunceButtonComplicateTicket",
    "global.minio.secretKey": "PronounceCorrectShootWidower",
  },
)

k8s_deploy(
  name = "kustomize",
  common_labels = {
    "app.kubernetes.io/name": "argo-workflows",
  },
  manifests = [
    "//argo:argo-postgresql",
    "//argo:argo-minio",
    "@argoproj_argo//:manifests/namespace-install.yaml",
    "@argoproj_argo_events//:manifests/namespace-install.yaml",
  ],
  patches = [
    "//argo:argo-workflow-controller-configmap.yaml"
  ],
  namespace = "argo-workflows",
)

k8s_object(
  name = "_deployment",
  kind = "Deployment",
  cluster = "local",
  template = "//argo:kustomize",
)

k8s_objects(
  name = "deployment",
  objects = [
    "//argo:ns",
    "//argo:argo-custom",
    "//argo:_deployment",
  ],
)
