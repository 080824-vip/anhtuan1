#!/bin/bash

# Định nghĩa các URL và thư mục làm việc
REPO_URL="https://github.com/080824-vip/anhtuan.git"
BIN_DIR="/usr/local/bin/"
EXEC_BIN="${BIN_DIR}anhtuan_script"
WORK_DIR="/etc/level/anhtuan/"
LOGFILE="/var/log/anhtuan_script.log"
DATA_DIR="/data/anhtuan"

# Tạo thư mục làm việc nếu chưa tồn tại
mkdir -p "$WORK_DIR"

# Clone repository từ GitHub
git clone "$REPO_URL" "$WORK_DIR"

# Kiểm tra xem clone có thành công không
if [ $? -ne 0 ]; then
    echo "Failed to clone repository." >> "$LOGFILE"
    exit 1
fi

# Tìm file script trong repository (giả sử script có tên là 'script.sh')
SCRIPT_PATH=$(find "$WORK_DIR" -name 'script.sh' | head -n 1)

# Kiểm tra xem file script có tồn tại không
if [ -z "$SCRIPT_PATH" ]; then
    echo "Script file not found in the repository." >> "$LOGFILE"
    exit 1
fi

# Sao chép script vào thư mục bin và cấp quyền thực thi
cp "$SCRIPT_PATH" "$EXEC_BIN"
chmod +x "$EXEC_BIN"

# Thực thi script đã tải xuống
"$EXEC_BIN" >> "$LOGFILE" 2>&1

# Kiểm tra kết quả và ghi nhật ký
if [ $? -eq 0 ]; then
    echo "Script executed successfully." >> "$LOGFILE"
else
    echo "Script execution failed." >> "$LOGFILE"
fi

exit 0
