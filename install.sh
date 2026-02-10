#!/bin/bash
set -e

REPO_URL="https://github.com/dev-dhrubo-teamx/XEROX-ENCODER-TOOL.git"
INSTALL_DIR="/opt/xerox-encoder"
BIN="/usr/local/bin/xerox"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)"
  exit 1
fi

echo "[+] Installing dependencies..."
if command -v apt >/dev/null; then
  apt update && apt install -y ffmpeg git
elif command -v dnf >/dev/null; then
  dnf install -y ffmpeg git
elif command -v pacman >/dev/null; then
  pacman -Sy --noconfirm ffmpeg git
else
  echo "Unsupported package manager"
  exit 1
fi

rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

chmod +x "$INSTALL_DIR/xerox.sh"
ln -sf "$INSTALL_DIR/xerox.sh" "$BIN"

echo "===================================="
echo " XEROX ENCODER TOOL INSTALLED"
echo " Run command: xerox"
echo "===================================="
