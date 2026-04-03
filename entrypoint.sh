#!/bin/bash
set -e

RULES_SRC="/opt/librealsense/config/99-realsense-libusb.rules"
RULES_DST="/etc/udev/rules.d/99-realsense-libusb.rules"

if [ ! -f "$RULES_DST" ] || ! diff -q "$RULES_SRC" "$RULES_DST" > /dev/null 2>&1; then
    echo "[realsense] Installing udev rules on host"
    cp "$RULES_SRC" "$RULES_DST"
    udevadm control --reload-rules 2>/dev/null || true
    udevadm trigger 2>/dev/null || true
    echo "[realsense] udev rules installed, please unplug and replug your RealSense if this is the first run"
else
    echo "[realsense] udev rules already up to date"
fi

exec gosu rsuser "$@"