""" Detect nixos and install binaries fron nix-store directly. """

def _get_path_to_binary_in_nix_store(repo_ctx, nix_package):
  """Ephemeral download of binary and return of its path."""
  command = "nix-shell --pure -p bash busybox {} --run 'which {}'".format(nix_package)
  result = repo_ctx.execute(
    [
      "sh",
      "-c",
      command,
    ],
    environment = {
      "NIX_PATH": "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos",
      },
  )
  downloaded = result.return_code == 0
  if not downloaded:
    fail("Failed to run '%s'" % command)

  path_to_binary = result.stdout.strip()
  return path_to_binary


def is_running_on_nixos(repo_ctx):
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


def copy_bin_from_nix_store(repo_ctx, nix_package, dest):
  """Copy nix package from nix_store to given destination.

  Downloads a binary via nix package manger,
  then copies it to Bazel cache. This operation
  does not impact host configuration in any way.

  Args:
    repo_ctx: context of the repository rule,
        containing helper functions and information about attributes
    nix_package: name of the package that should be downloaded
        (i.e. kubectl)
    dest: path under which the binary should be copied
  Returns:
    None
  """
  target_dst = "{dest}/{nix_package}".format(
    dest=dest,
    nix_package=nix_package,
  )
  copy_cmd = "cp -f {src} {target_dst}".format(
    src=_get_path_to_binary_in_nix_store(repo_ctx),
    target_dst=target_dst,
  )

  repo_ctx.file(target_dst)
  result = repo_ctx.execute([
    "sh",
    "-c",
    copy_cmd,
  ])

  if result.return_code != 0:
    fail("Failed to copy kustomize bin from nix_store")
