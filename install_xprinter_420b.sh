#!/bin/bash

# Script tự động cài driver Xprinter XP-420B trên Linux (Debian/Ubuntu)
# Tương thích qua driver Zebra EPL2 có sẵn trong hệ thống

set -e

echo "=== Cài đặt Driver Xprinter XP-420B (EPL2 Zebra) ==="

# 1. Cài đặt CUPS và bộ driver máy in phổ biến
echo "[+] Cài đặt CUPS và các driver máy in..."
sudo apt update
sudo apt install -y cups printer-driver-all

# 2. Thêm user vào nhóm lpadmin
echo "[+] Cấp quyền quản lý máy in cho user hiện tại..."
sudo usermod -aG lpadmin "$USER"

# 3. Khởi động dịch vụ CUPS
echo "[+] Khởi động dịch vụ in CUPS..."
sudo systemctl enable cups
sudo systemctl start cups

# 4. Xác định thiết bị máy in USB
echo "[+] Tìm thiết bị máy in Xprinter qua CUPS..."
DEVICE_URI=$(lpinfo -v | grep -i xprinter | awk '{print $3}')

if [ -z "$DEVICE_URI" ]; then
    echo "❌ Không tìm thấy máy in Xprinter được kết nối! Kiểm tra lại cáp USB."
    exit 1
else
    echo "✅ Phát hiện thiết bị: $DEVICE_URI"
fi

# 5. Cài đặt máy in với driver Zebra EPL2 (tương thích)
echo "[+] Cài đặt máy in với driver Zebra EPL2..."
sudo lpadmin -p XPrinter420B -E -v "$DEVICE_URI" -P /usr/share/ppd/Zebra-EPL2.ppd

# 6. Đặt làm máy in mặc định
sudo lpoptions -d XPrinter420B

echo "✅ Đã cài đặt thành công máy in 'XPrinter420B'!"
echo "🧪 Bạn có thể in thử với lệnh:"
echo "   echo 'Test Label from Xprinter' | lp"
