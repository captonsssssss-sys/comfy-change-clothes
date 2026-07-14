#!/usr/bin/env bash
set -e

jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  --ServerApp.root_dir='/root' &

cd /root/ComfyUI

exec python3 main.py \
  --listen 0.0.0.0 \
  --port 8188
