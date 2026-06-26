#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/workspaces/data}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKSUM_FILE="$PROJECT_DIR/checksums.md5"

BASE_URL="https://zenodo.org/records/20920057/files"
DATASET_NAMES=(
  "P5_crop_slide.zarr"
  "P5_full_slide.zarr"
)
ARCHIVE_NAMES=(
  "P5_crop_slide.zarr.tgz"
  "P5_full_slide.zarr.tgz"
)
DIRECT_FILE_NAMES=(
  "P5_crop_nuclei_masks.tif"
)

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

verify_checksum() {
  local file_name="$1"
  local required="${2:-true}"
  local file_path="$DATA_DIR/$file_name"
  local checksum_line

  if [[ ! -f "$file_path" ]]; then
    return
  fi

  checksum_line="$(awk -v file="$file_name" '$2 == file { print }' "$CHECKSUM_FILE")"
  if [[ -z "$checksum_line" ]]; then
    if [[ "$required" == true ]]; then
      fail "Checksum not found for file: $file_name"
    fi

    log "Checksum not found for optional file; skipping verification: $file_name"
    return
  fi

  (
    cd "$DATA_DIR"
    printf '%s\n' "$checksum_line" | md5sum -c -
  )
  log "Checksum verified: $file_name"
}

mkdir -p "$DATA_DIR"

step "Configuration"
log "Data directory : $DATA_DIR"
for i in "${!DATASET_NAMES[@]}"; do
  log "Archive        : ${ARCHIVE_NAMES[$i]}"
  log "Zarr output    : $DATA_DIR/${DATASET_NAMES[$i]}"
done
for file_name in "${DIRECT_FILE_NAMES[@]}"; do
  log "Direct file    : $DATA_DIR/$file_name"
done

all_available=true
for i in "${!DATASET_NAMES[@]}"; do
  zarr_path="$DATA_DIR/${DATASET_NAMES[$i]}"
  archive_path="$DATA_DIR/${ARCHIVE_NAMES[$i]}"

  if [[ -d "$zarr_path" ]]; then
    log "Found existing directory: $zarr_path"
    if [[ -f "$archive_path" ]]; then
      rm -f "$archive_path"
      log "Removed leftover archive: $archive_path"
    fi
  else
    all_available=false
  fi
done
for file_name in "${DIRECT_FILE_NAMES[@]}"; do
  file_path="$DATA_DIR/$file_name"

  if [[ -f "$file_path" ]]; then
    log "Found existing file: $file_path"
  else
    all_available=false
  fi
done

if [[ "$all_available" == true ]]; then
  step "Datasets already available"
  log "Nothing to download or extract."
  exit 0
fi

step "Download"
for i in "${!DATASET_NAMES[@]}"; do
  zarr_path="$DATA_DIR/${DATASET_NAMES[$i]}"
  archive_name="${ARCHIVE_NAMES[$i]}"
  archive_path="$DATA_DIR/$archive_name"
  download_url="$BASE_URL/$archive_name"

  if [[ -d "$zarr_path" ]]; then
    log "Skipping download; dataset already available: $zarr_path"
  elif [[ -f "$archive_path" ]]; then
    log "Found existing archive: $archive_path"
    log "Skipping download."
  else
    log "Downloading from: $download_url"
    wget --progress=bar:force:noscroll -O "$archive_path" "$download_url"
  fi
done
for file_name in "${DIRECT_FILE_NAMES[@]}"; do
  file_path="$DATA_DIR/$file_name"
  download_url="$BASE_URL/$file_name"

  if [[ -f "$file_path" ]]; then
    log "Skipping download; file already available: $file_path"
  else
    log "Downloading from: $download_url"
    wget --progress=bar:force:noscroll -O "$file_path" "$download_url"
  fi
done

step "Checksum"
if [[ ! -f "$CHECKSUM_FILE" ]]; then
  fail "Checksum file not found: $CHECKSUM_FILE"
fi

for archive_name in "${ARCHIVE_NAMES[@]}"; do
  verify_checksum "$archive_name" true
done
for file_name in "${DIRECT_FILE_NAMES[@]}"; do
  verify_checksum "$file_name" true
done

step "Extract"
for i in "${!DATASET_NAMES[@]}"; do
  zarr_path="$DATA_DIR/${DATASET_NAMES[$i]}"
  archive_path="$DATA_DIR/${ARCHIVE_NAMES[$i]}"

  if [[ -d "$zarr_path" ]]; then
    log "Skipping extraction; dataset already available: $zarr_path"
    continue
  fi

  tar -xzf "$archive_path" -C "$DATA_DIR"

  if [[ ! -d "$zarr_path" ]]; then
    fail "Extraction finished, but $zarr_path was not created."
  fi

  rm -f "$archive_path"
  log "Extracted zarr directory: $zarr_path"
  log "Removed archive: $archive_path"
done

step "Done"
log "Data ready in: $DATA_DIR"
