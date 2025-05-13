#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file.ova>"
    exit 1
fi

OVA_FILE="$1"
BASENAME=$(basename "$OVA_FILE" .ova)

if [[ ! -f "$OVA_FILE" || "$OVA_FILE" != *.ova ]]; then
    echo "Error: File not found or not a .ova file"
    exit 1
fi

TMP_DIR="${BASENAME}_tmp"
mkdir -p "$TMP_DIR"

echo "[*] Extracting OVA: $OVA_FILE"
tar -xf "$OVA_FILE" -C "$TMP_DIR"

VMDK_FILE=$(find "$TMP_DIR" -name '*.vmdk' | head -n 1)

if [ -z "$VMDK_FILE" ]; then
    echo "Error: No VMDK file found in the OVA."
    rm -rf "$TMP_DIR"
    exit 1
fi

QCOW2_FILE="${BASENAME}.qcow2"
echo "[*] Converting $VMDK_FILE to $QCOW2_FILE"

qemu-img convert -f vmdk -O qcow2 "$VMDK_FILE" "$QCOW2_FILE"

if [ $? -ne 0 ]; then
    echo "Error: Conversion failed."
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "[*] Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo "[+] Conversion complete: $QCOW2_FILE"

