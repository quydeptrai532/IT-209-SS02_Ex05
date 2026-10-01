#!/usr/bin/env bash
#
# Bài 5 - Phân quyền thư mục web tĩnh cho Nginx
# Owner: devops (rw) - Group: www-data (r) - Others: không truy cập
#
# Cách dùng:
#   chmod +x setup-permissions.sh
#   sudo ./setup-permissions.sh

set -euo pipefail

WEB_DIR="/var/www/ptit-web"
WEB_USER="devops"
WEB_GROUP="www-data"

if [ ! -d "$WEB_DIR" ]; then
  echo "LỖI: Không tìm thấy thư mục $WEB_DIR" >&2
  exit 1
fi

echo "==> Đổi chủ sở hữu sang ${WEB_USER}:${WEB_GROUP} (đệ quy)"
chown -R "${WEB_USER}:${WEB_GROUP}" "$WEB_DIR"

echo "==> Phân quyền: thư mục 750, tệp tin 640"
find "$WEB_DIR" -type d -exec chmod 750 {} \;
find "$WEB_DIR" -type f -exec chmod 640 {} \;

echo "==> Đảm bảo thư mục cha cho phép Nginx đi qua"
chmod 755 /var/www

echo "==> Khởi động lại Nginx"
systemctl restart nginx

echo "==> Kết quả phân quyền"
ls -la "$WEB_DIR"

echo "==> Hoàn tất. Kiểm tra ghi file bằng user ${WEB_USER}:"
echo "    echo \"Update\" >> ${WEB_DIR}/html/index.html"
