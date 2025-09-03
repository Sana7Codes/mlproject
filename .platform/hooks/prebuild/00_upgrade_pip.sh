#!/usr/bin/env bash
set -euo pipefail

source /var/app/venv/*/bin/activate

# clean caches before install
rm -rf /root/.cache/pip /tmp/* /var/tmp/* || true

# install CPU-only, no-cache, only wheels
pip install --no-cache-dir --only-binary=:all: -r /var/app/staging/requirements.txt

