#!/usr/bin/env bash
set -euxo pipefail

# Log to EB hook logs (optional but helpful for debugging)
mkdir -p /var/log/eb-hooks
exec >/var/log/eb-hooks/00_upgrade_pip.log 2>&1

# Activate Elastic Beanstalk’s virtualenv
source /var/app/venv/*/bin/activate

# Upgrade pip and setuptools to latest stable
python3 -m pip install --upgrade pip setuptools wheel
