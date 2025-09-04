#!/usr/bin/env bash
set -euxo pipefail

# Log everything for debugging
mkdir -p /var/log/eb-hooks
exec >/var/log/eb-hooks/00_setup_and_install.log 2>&1

# Locate EB’s virtualenv binaries reliably
PIP_BIN="$(find /var/app/venv -type f -path '*/bin/pip' | head -n1 || true)"
PY_BIN="$(find /var/app/venv -type f -path '*/bin/python' | head -n1 || true)"
if [[ -z "${PIP_BIN}" || -z "${PY_BIN}" ]]; then
  echo "ERROR: Could not locate EB virtualenv (pip/python) under /var/app/venv"
  ls -R /var/app/venv || true
  exit 1
fi

REQ_FILE="/var/app/staging/requirements.txt"
ls -l "$REQ_FILE"

# Upgrade pip toolchain inside EB venv
"$PY_BIN" -m pip install --upgrade pip setuptools wheel

# Install deps without cache to save disk. (Do NOT use bare 'exec'!)
"$PIP_BIN" install --no-cache-dir -r "$REQ_FILE"

# Keep disk clean
rm -rf /root/.cache/pip /tmp/* /var/tmp/* || true
