#!/bin/bash

# Hàm kiểm tra và cài đặt gói
install_package() {
    local package=$1
    sudo DEBIAN_FRONTEND=noninteractive apt install -y "$package"
    if [ $? -ne 0 ]; then
        echo "Cài đặt $package thất bại!"
        exit 1
    fi
}

# Cập nhật danh sách gói
sudo DEBIAN_FRONTEND=noninteractive apt update

# Cài đặt jq và unzip
install_package jq
install_package unzip
apt update
apt install parallel

# Cài đặt git nếu chưa có
if ! command -v git &> /dev/null; then
    install_package git
fi

# Kiểm tra và xóa thư mục anhtuan nếu đã tồn tại
if [ -d "anhtuan" ]; then
    rm -rf anhtuan
fi

# Kiểm tra và xóa thư mục proxyserver nếu đã tồn tại
if [ -d "/root/proxyserver" ]; then
    rm -rf /root/proxyserver
fi

# Clone repository từ GitHub
git clone https://github.com/080824-vip/anhtuan.git
if [ $? -ne 0 ]; then
    echo "Clone repository thất bại!"
    exit 1
fi

# Chuyển đến thư mục repository
cd anhtuan

# Kiểm tra xem tệp zip có tồn tại không trước khi giải nén
if [ -f "anhtuan500.zip" ]; then
    # Giải nén tệp
    unzip anhtuan500.zip
    if [ $? -ne 0 ]; then
        echo "Giải nén thất bại!"
        exit 1
    fi

    # Thiết lập quyền thực thi cho script Python
    chmod +x run_encrypted_script.py

    # Thêm alias vào .bashrc và source nó ngay lập tức
    echo "alias anhtuan='/root/anhtuan/run_encrypted_script.py'" >> ~/.bashrc
    source ~/.bashrc

    # Tạo thư mục proxyserver và tệp used_keys.log nếu chưa tồn tại
    mkdir -p /root/proxyserver
    touch /root/proxyserver/used_keys.log

    # Kiểm tra xem tệp key.key có tồn tại không
    if [ ! -f "key.key" ]; then
        echo "Tệp key.key không tồn tại! Vui lòng tạo hoặc sao chép tệp key.key vào thư mục anhtuan."
        exit 1
    fi

    echo "########################"
    echo -e "\e[32mLiên hệ hỗ trợ telegram @ipv6anhtuan\e[0m"
    echo -e "\e[32m+44 7529 643977\e[0m"
    echo "########################"

    echo -e "Thiết lập hoàn tất! Vui lòng nhập '\e[31mcd ~/anhtuan\e[0m' sau đó nhập tiếp '\e[33manhtuan\e[0m' để chạy script."
else
    echo "Tệp anhtuan500.zip không tồn tại!"
    exit 1
fi
