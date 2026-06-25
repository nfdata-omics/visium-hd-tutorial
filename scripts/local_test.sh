#!/bin/bash

PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p ${HOME}/visium-hd-tutorial-workspace/data

docker run --rm -it \
  --name visium-hd-tutorial-local \
  --cpus="2" \
  --memory="8g" \
  --memory-swap="8g" \
  -v "${HOME}/visium-hd-tutorial-workspace:/workspaces/" \
  -v "${PARENT_DIR}:/workspaces/nfdata-omics-visium-hd-tutorial" \
  -w /workspaces/nfdata-omics-visium-hd-tutorial \
  -e DATA_DIR=/workspaces/data \
  -e HOST_PROJECT_PATH=/workspaces/nfdata-omics-visium-hd-tutorial \
  -p 8888:8888 \
  ghcr.io/nfdata-omics/visium-hd-tutorial:2026-06-25 \
  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
