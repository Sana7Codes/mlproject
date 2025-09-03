#!/bin/bash
set -e

# Check if pip is installed. If not, install it.
if ! command -v pip &> /dev/null; then
    echo "pip not found, installing..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
fi

# Now that pip is confirmed to be installed, proceed with upgrade
python3 -m pip install --upgrade pip setuptools wheel
