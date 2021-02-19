""" Ensure golang binaries will work on NixOS. """

def _is_running_on_nixos(repo_ctx):
  """Check if Bazel is executed on NixOS.

  Args:
    repo_ctx: context of the repository rule,
      containing helper functions and information about attributes
  Returns:
    boolean: indicating if Bazel is executed on NixOS.
  """
  result = repo_ctx.execute([
    "sh",
    "-c",
    "test -f /etc/os-release && cat /etc/os-release | head -n1",
  ])
  os_release_file_read_success = result.return_code == 0
  if not os_release_file_read_success:
    return False

  os_release_first_line = result.stdout
  host_is_nixos = os_release_first_line.strip() == "NAME=NixOS"
  return host_is_nixos


def _gen_imports_impl(ctx):
  ctx.file("BUILD", "")
  imports_for_nix = """
load("@io_tweag_rules_nixpkgs//nixpkgs:toolchains/go.bzl", "nixpkgs_go_configure")
def nixos_golang_patch():
  nixpkgs_go_configure(repository = "@nixpkgs")
  """
  imports_for_non_nix = """
def nixos_golang_patch():
  # if go isn't transitive you'll need to add call to go_register_toolchains here
  pass
  """

  if _is_running_on_nixos(ctx):
    ctx.file("imports.bzl", imports_for_nix)
  else:
    ctx.file("imports.bzl", imports_for_non_nix)

_gen_imports = repository_rule(
  implementation = _gen_imports_impl,
  attrs = dict(),
)

def gen_imports():
  _gen_imports(name = "nixos_support_golang")
