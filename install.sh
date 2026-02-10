#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/dev-dhrubo-teamx/XEROX-ENCODER-TOOL.git"
INSTALL_DIR="/opt/xerox-encoder"
BIN_PATH="/usr/local/bin/xerox"

echo "======================================"
echo "  Installing Xerox Encoder Tool"
echo "======================================"

# Root permission check
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root (use sudo)"
  exit 1
fi

# Install dependencies
echo "[+] Installing dependencies..."
if command -v apt >/dev/null 2>&1; then
  apt update
  apt install -y ffmpeg git
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y ffmpeg git
elif command -v pacman >/dev/null 2>&1; then
  pacman -Sy --noconfirm ffmpeg git
else
  echo "[ERROR] Unsupported package manager"
  exit 1
fi

# Remove old installation
rm -rf "$INSTALL_DIR"

# Clone repository
echo "[+] Cloning repository..."
git clone "$REPO_URL" "$INSTALL_DIR"

# Make main CLI executable
chmod +x "$INSTALL_DIR/xerox.sh"

# Create system-wide command
ln -sf "$INSTALL_DIR/xerox.sh" "$BIN_PATH"

echo
echo "======================================"
echo " ✅ Installation completed"
echo " 🚀 Launching Xerox Encoder Tool..."
echo "======================================"

# 🔥 AUTO RUN (THIS WAS MISSING)
exec xerox
