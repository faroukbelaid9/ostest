#!/bin/bash

# Verify input parameter exists
if [[ -z "$1" ]]; then
    echo "Usage: $0 <target_file>" >&2
    exit 1
fi

# Resolve absolute path of target file
TARGET_FILE=$(realpath "$1" 2>/dev/null)

# Check if target exists
if [[ ! -e "$TARGET_FILE" ]]; then
    echo "Error: Target file '$1' does not exist" >&2
    exit 1
fi

echo "Finding all symlinks pointing to: $TARGET_FILE"
echo "-----------------------------------------"

# Search for symbolic links in home directory
find ~/ -type l 2>/dev/null | while read -r SYMLINK_PATH; do
    # Resolve symlink destination
    LINK_DESTINATION=$(readlink -f "$SYMLINK_PATH" 2>/dev/null)
    
    # Compare with target
    if [[ "$LINK_DESTINATION" == "$TARGET_FILE" ]]; then
        echo "Found: $SYMLINK_PATH"
    fi
done

echo "-----------------------------------------"
echo "Search completed"
