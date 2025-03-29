#!/bin/bash

# Check if output file is specified
[[ -z "$1" ]] && { echo "Usage: $0 <output_file>" >&2; exit 1; }

output_file="$1"
current_dir=$(pwd)

# Clear existing output file
: > "$output_file"

# Function to find and record first match of file type
record_file_type() {
    local type_char=$1
    local description=$2
    
    local match=$(ls -lR / 2>/dev/null | grep "^${type_char}" | head -n 1)
    
    if [[ -n "$match" ]]; then
        local filename=$(awk '{print $NF}' <<< "$match")
        echo "${description}: " >> "${current_dir}/${filename}" >> "$output_file"
    else
        echo "${description}: Not found" >> "$output_file"
    fi
}

# Main processing
{
    record_file_type '-' "Обычный файл"
    record_file_type 'b' "Специальный файл блочного устройства"
    record_file_type 'c' "Файл символьного устройства"
    record_file_type 'd' "Директория"
    record_file_type 'l' "Символьная ссылка"
    record_file_type 'p' "FIFO (named pipe)"
    record_file_type 's' "Сокет"
} || {
    echo "Error occurred during file search" >&2
    exit 1
}

exit 0
