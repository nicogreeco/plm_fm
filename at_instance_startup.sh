#!/bin/bash

set -euo pipefail

LOG_DIR="/workspace/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/provision-$(date +'%Y%m%d-%H%M%S').log"
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'echo "ERROR on line $LINENO: $BASH_COMMAND"; exit 1' ERR

echo "=== Provisioning started: $(date -Is) ==="

git config --global user.name "Nicola Greco"
git config --global user.email "niccogreek@gmail.com"
cd /workspace
git clone https://github.com/nicogreeco/plm_fm.git

cd plm_fm
source /venv/main/bin/activate
uv pip install -r requirements.txt
uv pip install packaging psutil ninja vastai huggingface_hub
MAX_JOBS=4 uv pip install --no-build-isolation flash-attn==2.8.3

mkdir -p /workspace/plm_fm/datasets/dataset
# hf download niccogreek/plm_fm --repo-type dataset \
#   --local-dir /workspace/plm_fm/datasets/dataset

uv pip install python-dateutil --upgrade

sudo apt update && sudo apt install screen -y

echo "=== Provisioning finished OK: $(date -Is) ==="