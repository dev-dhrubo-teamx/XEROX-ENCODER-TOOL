#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/dev-dhrubo-teamx/XEROX-ENCODER-TOOL.git"
INSTALL_DIR="/opt/xerox-encoder"
BIN_PATH="/usr/local/bin/xerox"

echo "======================================"
echo "  Installing Xerox Encoder Tool"
echo "======================================"

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root (use sudo)"
  exit 1
fi

# -------- SMART DEP CHECK (NO APT IF NOT NEEDED) --------
echo "[+] Checking dependencies..."

MISSING_PKGS=()

command -v git >/dev/null 2>&1 || MISSING_PKGS+=("git")
command -v ffmpeg >/dev/null 2>&1 || MISSING_PKGS+=("ffmpeg")

if [ "${#MISSING_PKGS[@]}" -ne 0 ]; then
  echo "[!] Missing packages: ${MISSING_PKGS[*]}"
  echo "[!] Installing missing packages only..."

  if command -v apt >/dev/null 2>&1; then
    apt update
    apt install -y "${MISSING_PKGS[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y "${MISSING_PKGS[@]}"
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm "${MISSING_PKGS[@]}"
  else
    echo "[ERROR] Unsupported package manager"
    exit 1
  fi
else
  echo "[✓] All dependencies already installed (skipping apt)"
fi

# -------- INSTALL XEROX --------
rm -rf "$INSTALL_DIR"

echo "[+] Cloning repository..."
git clone "$REPO_URL" "$INSTALL_DIR"

chmod +x "$INSTALL_DIR/xerox.sh"

ln -sf "$INSTALL_DIR/xerox.sh" "$BIN_PATH"

echo
echo "======================================"
echo " ✅ Installation completed"
echo " 🚀 Launching Xerox Encoder Tool..."
echo "======================================"

# AUTO RUN
echo xerox
