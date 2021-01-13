""" Ensure golang binaries will work on NixOS. """

def _has_nix(ctx):
  return ctx.which("nix-build") != None

def _gen_imports_impl(ctx):
  ctx.file("BUILD", "")
  imports_for_nix = """
    load("@io_tweag_rules_nixpkgs//nixpkgs:toolchains/go.bzl", "nixpkgs_go_toolchain")
    def fix_go():
      nixpkgs_go_toolchain(repository = "@nixpkgs")
  """
  imports_for_non_nix = """
    def fix_go():
      # if go isn't transitive you'll need to add call to go_register_toolchains here
      pass
  """

  if _has_nix(ctx):
    ctx.file("imports.bzl", imports_for_nix)
  else:
    ctx.file("imports.bzl", imports_for_non_nix)

_gen_imports = repository_rule(
  implementation = _gen_imports_impl,
  attrs = dict(),
)

def gen_imports():
  _gen_imports(name = "nixos_support_golang")
