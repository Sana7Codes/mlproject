#!/usr/bin/env bash
set -euo pipefail

# Be loud in EB logs
echo "[prebuild] Bootstrapping pip for python3"

# Prefer the system python3
PY=$(command -v python3 || true)

if [[ -z "${PY}" ]]; then
  echo "[prebuild] python3 not found. Installing it..."
  # Amazon Linux detection
  if [[ -f /etc/system-release && "$(cat /etc/system-release)" == *"Amazon Linux 2"* ]]; then
    sudo yum install -y python3
  else
    # Amazon Linux 2023
    sudo dnf install -y python3
  fi
  PY=$(command -v python3)
fi

# Try ensurepip first (works on most builds)
if ! "${PY}" -m pip --version >/dev/null 2>&1; then
  echo "[prebuild] pip not found; trying ensurepip..."
  if "${PY}" -m ensurepip --upgrade >/dev/null 2>&1; then
    echo "[prebuild] ensurepip succeeded."
  else
    echo "[prebuild] ensurepip unavailable; installing python3-pip via package manager..."
    if [[ -f /etc/system-release && "$(cat /etc/system-release)" == *"Amazon Linux 2"* ]]; then
      sudo yum install -y python3-pip
    else
      sudo dnf install -y python3-pip
    fi
  fi
fi

# Final sanity check: upgrade pip safely
"${PY}" -m pip install --upgrade pip

echo "[prebuild] pip ready at: $(${PY} -m pip --version)"
