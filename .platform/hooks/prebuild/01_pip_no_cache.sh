#!/usr/bin/env bash
set -euxo pipefail

mkdir -p /var/log/eb-hooks
exec >/var/log/eb-hooks/01_pip_no_cache.log 2>&1

source /var/app/venv/*/bin/activate
rm -rf /root/.cache/pip /tmp/* /var/tmp/* || true

# confirm requirements file path
ls -l /var/app/staging/requirements.txt

# install (no cache)
pip install --no-cache-dir -r /var/app/staging/requirements.txt
