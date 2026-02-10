#!/bin/bash

OUTPUT_DIR="./output"
LOG_DIR="./logs"
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
    sudo apt update && sudo apt install -y ffmpeg
elif command -v dnf >/dev/null; then
    sudo dnf install -y ffmpeg
elif command -v pacman >/dev/null; then
    sudo pacman -S --noconfirm ffmpeg
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
| tee -a "$LOG_FILE"
}

hd_encode() {
read -p "Input video file: " INPUT
OUT="$OUTPUT_DIR/$(basename "${INPUT%.*}").mp4"
ffmpeg -i "$INPUT" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k "$OUT" \
| tee -a "$LOG_FILE"
}

smart_loop() {
read -p "Folder path: " DIR

for EXT in $VIDEO_EXTENSIONS; do
    find "$DIR" -type f -iname "*.$EXT"
done | while read FILE; do
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
tail -f "$LOG_FILE"
}

# Background mode handler
if [[ "$1" == "--bg-loop" ]]; then
    smart_loop "$2"
    exit 0
fi

while true; do
banner
echo "1) Fast Encode (Single File)"
echo "2) HD Encode (Single File)"
echo "3) Smart Loop Encode (Folder)"
echo "4) Smart Loop Encode (Background)"
echo "5) View Live Logs"
echo "6) Install Dependencies (1-Click)"
echo "7) Exit"
read -p "Select option: " OPT

case $OPT in
1) fast_encode ;;
2) hd_encode ;;
3) smart_loop ;;
4) smart_loop_bg ;;
5) view_logs ;;
6) install_deps ;;
7) exit 0 ;;
*) echo "Invalid option" ;;
esac

read -p "Press Enter to continue..."
done
