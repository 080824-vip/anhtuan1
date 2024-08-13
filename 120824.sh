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

# Kiểm tra xem biến môi trường REPO_URL có tồn tại không
if [ -z "$REPO_URL" ]; then
    echo "Biến môi trường REPO_URL không tồn tại! Vui lòng thiết lập biến này."
    exit 1
fi

# Clone the repository using the environment variable
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
    
    # Thiết lập biến môi trường để lưu đường dẫn gốc của script (ẩn đi đường dẫn thật)
    export SCRIPT_PATH="$(pwd)/run_encrypted_script.py"
    
    # Add alias to .bashrc with hidden path and source it immediately.
    echo "alias anhtuan='${SCRIPT_PATH}'" >> ~/.bashrc
    
    # Source .bashrc to apply changes immediately.
    source ~/.bashrc
    
    # Sử dụng nội dung từ biến môi trường thay vì tệp key.key (nếu cần)
    if [ -z "$KEY_CONTENT" ]; thì 
        echo "Biến môi trường KEY_CONTENT không tồn tại! Vui lòng thiết lập biến này."
        exit 1
    else 
        # Tạo tệp key.key tạm thời trong /tmp và ghi nội dung vào đó.
        TEMP_KEY_FILE="/tmp/key.key.tmp"
        echo "$KEY_CONTENT" > "$TEMP_KEY_FILE"
        
        # Đảm bảo tệp tạm thời được xóa sau khi sử dụng xong để bảo mật.
        trap 'rm -f "$TEMP_KEY_FILE"' EXIT
        
        echo "Tệp key.key đã được tạo tạm thời."
        
        # Chạy script với tệp key.key tạm thời (nếu cần)
        python3 run_encrypted_script.py --keyfile "$TEMP_KEY_FILE"
        
        # Xóa tệp key.key tạm thời sau khi sử dụng.
        rm -f "$TEMP_KEY_FILE"
        
        echo "Tệp key.key đã bị xóa."
    fi
    
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
