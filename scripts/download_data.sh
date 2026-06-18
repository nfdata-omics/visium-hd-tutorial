#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/workspaces/data}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKSUM_FILE="$PROJECT_DIR/checksums.md5"

DATASET_NAME="P5.zarr"
ARCHIVE_NAME="${DATASET_NAME}.tar.gz"
DOWNLOAD_URL="https://zenodo.org/records/20744512/files/${ARCHIVE_NAME}"

ARCHIVE_PATH="$DATA_DIR/$ARCHIVE_NAME"
ZARR_PATH="$DATA_DIR/$DATASET_NAME"

log() {
  printf '[download-data] %s\n' "$1"
}

step() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf '\n[download-data] ERROR: %s\n' "$1" >&2
  exit 1
}

mkdir -p "$DATA_DIR"

step "Configuration"
log "Data directory : $DATA_DIR"
log "Archive        : $ARCHIVE_NAME"
log "Zarr output    : $ZARR_PATH"

if [[ -d "$ZARR_PATH" ]]; then
  step "Dataset already available"
  log "Found existing directory: $ZARR_PATH"
  if [[ -f "$ARCHIVE_PATH" ]]; then
    rm -f "$ARCHIVE_PATH"
    log "Removed leftover archive: $ARCHIVE_PATH"
  fi
  log "Nothing to download or extract."
  exit 0
fi

step "Download"
if [[ -f "$ARCHIVE_PATH" ]]; then
  log "Found existing archive: $ARCHIVE_PATH"
  log "Skipping download."
else
  log "Downloading from: $DOWNLOAD_URL"
  wget --progress=bar:force:noscroll -O "$ARCHIVE_PATH" "$DOWNLOAD_URL"
fi

step "Checksum"
if [[ ! -f "$CHECKSUM_FILE" ]]; then
  fail "Checksum file not found: $CHECKSUM_FILE"
fi

(
  cd "$DATA_DIR"
  md5sum -c "$CHECKSUM_FILE"
)
log "Checksum verified."

step "Extract"
tar -xzf "$ARCHIVE_PATH" -C "$DATA_DIR"

if [[ ! -d "$ZARR_PATH" ]]; then
  fail "Extraction finished, but $ZARR_PATH was not created."
fi

rm -f "$ARCHIVE_PATH"
log "Extracted zarr directory: $ZARR_PATH"
log "Removed archive: $ARCHIVE_PATH"

step "Done"
log "Data ready in: $DATA_DIR"
