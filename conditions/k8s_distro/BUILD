""" To be described. """

K8S_DISTRIBUTIONS = [
  "k8s",
  "aks",
  "eks",
  "openshift",
  "rke-goverment"
]

[
  config_setting(
      name = distro,
      define_values = {"k8s_distro" : distro},
  ) for distro in K8S_DISTRIBUTIONS
]
