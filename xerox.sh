#!/usr/bin/env bash

# ===============================
# Xerox Encoder Tool (Bash CLI)
# ===============================

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$BASE_DIR/output"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/encoder.log"

VIDEO_EXTENSIONS="mkv mp4 avi mov flv webm"

mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

banner() {
clear
cat << "EOF"
╔══════════════════════════════════════╗
║        XEROX ENCODER TOOL            ║
╚══════════════════════════════════════╝
EOF
}

install_deps() {
echo "[+] Installing dependencies..." | tee -a "$LOG_FILE"
if command -v apt >/dev/null; then
    apt update && apt install -y ffmpeg
elif command -v dnf >/dev/null; then
    dnf install -y ffmpeg
elif command -v pacman >/dev/null; then
    pacman -S --noconfirm ffmpeg
else
    echo "[-] Unsupported package manager" | tee -a "$LOG_FILE"
    exit 1
fi
echo "[✓] Dependencies installed" | tee -a "$LOG_FILE"
}

fast_encode() {
read -p "Input video file: " INPUT
OUT="$OUTPUT_DIR/$(basename "${INPUT%.*}").mp4"
ffmpeg -i "$INPUT" -c:v libx264 -preset veryfast -crf 28 -c:a copy "$OUT" \
>> "$LOG_FILE" 2>&1
echo "[✓] Done: $OUT"
}

hd_encode() {
read -p "Input video file: " INPUT
OUT="$OUTPUT_DIR/$(basename "${INPUT%.*}").mp4"
ffmpeg -i "$INPUT" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k "$OUT" \
>> "$LOG_FILE" 2>&1
echo "[✓] Done: $OUT"
}

smart_loop() {
read -p "Folder path: " DIR

for EXT in $VIDEO_EXTENSIONS; do
    find "$DIR" -type f -iname "*.$EXT"
done | while read -r FILE; do
    BASENAME=$(basename "${FILE%.*}")
    OUT="$OUTPUT_DIR/$BASENAME.mp4"

    if [ -f "$OUT" ]; then
        echo "[SKIP] $BASENAME already encoded" | tee -a "$LOG_FILE"
        continue
    fi

    echo "[ENCODE] $FILE" | tee -a "$LOG_FILE"
    ffmpeg -i "$FILE" -c:v libx264 -preset veryfast -crf 26 "$OUT" \
    >> "$LOG_FILE" 2>&1
done

echo "[✓] Loop encoding completed" | tee -a "$LOG_FILE"
}

smart_loop_bg() {
read -p "Folder path: " DIR
nohup bash "$0" --bg-loop "$DIR" >> "$LOG_FILE" 2>&1 &
echo "[✓] Background loop started"
}

view_logs() {
echo "Press CTRL+C to exit logs"
sleep 1
tail -f "$LOG_FILE"
}

# -------------------------------
# Background mode handler
# -------------------------------
if [[ "$1" == "--bg-loop" ]]; then
    smart_loop "$2"
    exit 0
fi

# -------------------------------
# Main CLI Loop (minipanel style)
# -------------------------------
while true; do
banner
echo "1) Fast Encode (Single File)"
echo "2) HD Encode (Single File)"
echo "3) Smart Loop Encode (Folder)"
echo "4) Smart Loop Encode (Background)"
echo "5) View Live Logs"
echo "6) Install Dependencies (1-Click)"
echo "7) Exit"
echo
read -p "Select option: " OPT

case "$OPT" in
1) fast_encode ;;
2) hd_encode ;;
3) smart_loop ;;
4) smart_loop_bg ;;
5) view_logs ;;
6) install_deps ;;
7) exit 0 ;;
*) echo "Invalid option"; sleep 1 ;;
esac

read -p "Press Enter to continue..."
done
