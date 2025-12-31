#!/bin/bash
# Enable Touch ID for sudo commands on macOS Sonoma+
# This creates /etc/pam.d/sudo_local which persists across system updates

set -e

SUDO_LOCAL="/etc/pam.d/sudo_local"
TEMPLATE="/etc/pam.d/sudo_local.template"

if [[ ! -f "$TEMPLATE" ]]; then
    echo "Error: $TEMPLATE not found. This script requires macOS Sonoma or later."
    exit 1
fi

if [[ -f "$SUDO_LOCAL" ]]; then
    if grep -q "^auth.*pam_tid.so" "$SUDO_LOCAL"; then
        echo "Touch ID for sudo is already enabled."
        exit 0
    fi
fi

echo "Enabling Touch ID for sudo..."
sed 's/^#auth/auth/' "$TEMPLATE" | sudo tee "$SUDO_LOCAL" > /dev/null

echo "Done! Touch ID is now enabled for sudo commands."
echo "Test it with: sudo echo 'Touch ID works!'"
