#!/usr/bin/env bash

set -euo pipefail

# Attempt to determine script location on disk
{
  SCRIPT_DIR=$(dirname "$(readlink -f $0)")
} || {
  echo "Script was unable to locate its location on disk,"
  echo "Assuming current working directory."
  SCRIPT_DIR="."
}

bazel query 'deps(//kubeview:prod)' --output graph > "${SCRIPT_DIR}/graph.in"
bazel query --noimplicit_deps 'deps(//kubeview:prod)' --output graph > "${SCRIPT_DIR}/simplified_graph.in"

dot -Tpng < "${SCRIPT_DIR}/graph.in" > "${SCRIPT_DIR}/graph.png"
dot -Tpng < "${SCRIPT_DIR}/simplified_graph.in" > "${SCRIPT_DIR}/simplified_graph.png"
