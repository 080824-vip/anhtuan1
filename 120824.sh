#!/bin/bash

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

# Clone the repository
git clone https://github.com/080824-vip/anhtuan.git

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
    echo "alias anhtuan='/root/anhtuan/run_encrypted_script.py'" >> ~/.bashrc
    
    # Source .bashrc to apply changes immediately.
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
    echo " liên hệ hỗ trợ telegram @ipv6anhtuan"
    echo " +44 7529 643977 "
    echo "########################"
    echo -e "Thiết lập hoàn tất! Vui lòng nhập '\e[31mcd ~/anhtuan\e[0m' sau đó nhập tiếp 'anhtuan' để chạy script."
else
    echo "Tệp anhtuan500.zip không tồn tại!"
    exit 1
fi

 # Source .bashrc to apply changes immediately.
    source ~/.bashrc

# Source .bashrc to apply changes immediately.
    source ~/.bashrc
    
