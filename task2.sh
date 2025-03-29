#!/bin/bash

# Verify file argument exists
if [ ! -e "$1" ]; then
    echo "Error: Target file not specified or doesn't exist" >&2
    echo "Usage: $0 <target_file>" >&2
    exit 1
fi

target="$1"

# Get inode number
file_inode=$(ls -i "$target" | awk '{print $1}')

# Search for hard links across system
echo "Found hard links for '$target' (inode $file_inode):"
echo "----------------------------------------"

# Perform the search
ls -iR / 2>/dev/null | grep "^$file_inode" | while read -r line; do
    # Extract just the filename part
    filename=$(echo "$line" | awk '{$1=""; print substr($0,2)}')
    # Skip the original file
    if [ "$filename" != "$target" ]; then
        echo "$filename"
    fi
done

echo "----------------------------------------"
echo "Search completed"
