#!/bin/bash

# Script tự động cài đặt QZ Tray trên Ubuntu/Debian
# Bao gồm:
# 1. Kiểm tra và cài đặt Java nếu chưa có
# 2. Tải và cài đặt QZ Tray (.deb)
# 3. Khởi chạy QZ Tray
# 4. Thiết lập tự động chạy QZ Tray khi khởi động máy

set -e

echo "=== QZ Tray Auto Installer ==="

# Bước 1: Kiểm tra Java
if ! command -v java &> /dev/null; then
    echo "[+] Java chưa được cài. Đang cài đặt OpenJDK..."
    sudo apt update
    sudo apt install -y default-jre
else
    echo "[+] Java đã được cài."
fi

# Bước 2: Tải QZ Tray bản mới nhất (.run)
QZ_URL="https://github.com/qzind/tray/releases/download/v2.2.4%2B3/qz-tray-2.2.4+1-x86_64.run"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "[+] Đang tải QZ Tray từ $QZ_URL ..."
wget -O qztray.run "$QZ_URL"
chmod +x qztray.run

# Bước 3: Giải nén và cài đặt từ file .run
echo "[+] Đang chạy installer..."
./qztray.run --accept-license --noexec --keep --target ./qztray-install
cd qztray-install
./install.sh

# Bước 4: Khởi chạy QZ Tray lần đầu
echo "[+] Khởi chạy QZ Tray..."
nohup qztray > /dev/null 2>&1 &

# Bước 5: Thiết lập tự động chạy khi khởi động
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat <<EOF > "$AUTOSTART_DIR/qztray.desktop"
[Desktop Entry]
Type=Application
Exec=qztray
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=QZ Tray
Comment=Khởi chạy QZ Tray khi đăng nhập
EOF

echo "✅ Hoàn tất! QZ Tray đã được cài và thiết lập tự động chạy khi khởi động."

# Bước 6: Dọn dẹp
cd ~
rm -rf "$TEMP_DIR"
