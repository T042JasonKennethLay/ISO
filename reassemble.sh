#!/usr/bin/env bash
# Download + reassemble Ubuntu 24.04.1 Live Server ISO from GitHub Release parts.
# Usage: ./reassemble.sh
set -euo pipefail

TAG="v24.04.1"
REPO="T042JasonKennethLay/ISO"
ISO="ubuntu-24.04.1-live-server-amd64.iso"
BASE="https://github.com/${REPO}/releases/download/${TAG}"
PARTS=("${ISO}.part00" "${ISO}.part01")

cd "$(dirname "$0")"

echo ">> Downloading parts (skipped if already present)..."
for p in "${PARTS[@]}"; do
  if [ -f "$p" ]; then
    echo "   - $p already here, skipping"
  else
    echo "   - fetching $p"
    curl -fL --progress-bar -o "$p" "${BASE}/${p}"
  fi
done

echo ">> Verifying parts..."
sha256sum -c PARTS.sha256

echo ">> Reassembling into ${ISO}..."
cat "${PARTS[@]}" > "$ISO"

echo ">> Verifying final ISO..."
sha256sum -c ORIGINAL.sha256

echo ""
echo "OK. ${ISO} is ready ($(du -h "$ISO" | cut -f1))."
echo "Delete the .part00/.part01 files if you no longer need them."
