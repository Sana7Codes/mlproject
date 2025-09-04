#!/usr/bin/env bash
set -euxo pipefail

LOG_FILE="/var/log/eb-hooks/00_setup_and_install.log"
mkdir -p /var/log/eb-hooks
# start fresh log
: > "$LOG_FILE"

# Wrap everything so stdout+stderr go to the log (NO bare 'exec' anywhere)
{
  echo "[INFO] Starting prebuild at $(date -Iseconds)"

  # Locate EB venv
  PIP_BIN="$(find /var/app/venv -type f -path '*/bin/pip' | head -n1 || true)"
  PY_BIN="$(find /var/app/venv -type f -path '*/bin/python' | head -n1 || true)"
  if [[ -z "${PIP_BIN}" || -z "${PY_BIN}" ]]; then
    echo "[ERROR] Could not locate EB virtualenv under /var/app/venv"
    ls -R /var/app/venv || true
    exit 1
  fi
  echo "[INFO] Using pip: $PIP_BIN"
  echo "[INFO] Using python: $PY_BIN"

  REQ_FILE="/var/app/staging/requirements.txt"
  echo "[INFO] requirements.txt:"
  ls -l "$REQ_FILE"

  echo "[INFO] Upgrading pip toolchain"
  "$PY_BIN" -m pip install --upgrade pip setuptools wheel

  echo "[INFO] Installing requirements (no cache)"
  "$PIP_BIN" install --no-cache-dir -r "$REQ_FILE"

  echo "[INFO] Cleaning temp/cache"
  rm -rf /root/.cache/pip /tmp/* /var/tmp/* || true

  echo "[INFO] Prebuild completed at $(date -Iseconds)"
} >>"$LOG_FILE" 2>&1
