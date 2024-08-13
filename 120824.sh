#!/bin/bash

# Kiểm tra xem biến môi trường KEY_CONTENT đã được thiết lập chưa
if [ -z "$KEY_CONTENT" ]; then
    echo "Biến môi trường KEY_CONTENT không tồn tại! Vui lòng thiết lập biến này trước khi chạy script."
    echo "Sử dụng lệnh sau để thiết lập biến môi trường:"
    echo "export KEY_CONTENT=\"nội dung của key\""
    exit 1
fi

# Kiểm tra xem biến môi trường REPO_URL đã được thiết lập chưa
if [ -z "$REPO_URL" ]; then
    echo "Biến môi trường REPO_URL không tồn tại! Vui lòng thiết lập biến này trước khi chạy script."
    echo "Sử dụng lệnh sau để thiết lập biến môi trường:"
    echo "export REPO_URL=\"https://github.com/080824-vip/anhtuan.git\""
    exit 1
fi

# Cập nhật danh sách gói
sudo apt update

# Cài đặt jq
sudo apt install -y jq
if [ $? -ne 0 ]; then
    echo "Cài đặt jq thất bại!"
    exit 1
fi

# Cài đặt unzip
sudo apt install -y unzip
if [ $? -ne 0 ]; then
    echo "Cài đặt unzip thất bại!"
    exit 1
fi

# Cài đặt git nếu chưa có
if ! command -v git &> /dev/null; then
    sudo apt install -y git
    if [ $? -ne 0 ]; then
        echo "Cài đặt git thất bại!"
        exit 1
    fi
fi

# Clone the repository using the REPO_URL environment variable
git clone "$REPO_URL"

# Kiểm tra xem quá trình clone có thành công không
if [ $? -ne 0 ]; then
    echo "Clone repository thất bại!"
    exit 1
fi

# Change to the repository directory
cd anhtuan

# Kiểm tra xem tệp zip có tồn tại không trước khi giải nén
if [ -f "anhtuan500.zip" ]; then
    # Unzip the file
    unzip anhtuan500.zip

    # Kiểm tra xem quá trình giải nén có thành công không
    if [ $? -ne 0 ]; then
        echo "Giải nén thất bại!"
        exit 1
    fi

    # Make the Python script executable
    chmod +x run_encrypted_script.py

    # Add alias to .bashrc with fixed path and source it immediately.
    echo "alias anhtuan='~/anhtuan/run_encrypted_script.py'" >> ~/.bashrc

    # Source .bashrc to apply changes immediately.
    source ~/.bashrc

    # Sử dụng nội dung từ biến môi trường thay vì tệp key.key
    echo "$KEY_CONTENT" > /tmp/key.key.tmp
     
    # Đảm bảo tệp tạm thời được xóa sau khi sử dụng xong để bảo mật.
    trap 'rm -f /tmp/key.key.tmp' EXIT
     
    echo "Tệp key.key đã được tạo tạm thời."

    # Chạy script Python với file key tạm thời
    ./run_encrypted_script.py /tmp/key.key.tmp

    echo "########################"
    echo " liên hệ hỗ trợ telegram @ipv6anhtuan"
    echo " +44 7529 643977 "
    echo "########################"
    echo -e "Thiết lập hoàn tất! Vui lòng nhập 'cd ~/anhtuan' sau đó nhập tiếp 'anhtuan' để chạy script."
else
    echo "Tệp anhtuan500.zip không tồn tại!"
    exit 1
fi

# Source .bashrc to apply changes immediately.
source ~/.bashrc
