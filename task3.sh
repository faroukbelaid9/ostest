#!/bin/bash

# Validate input parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <target_file>" >&2
    exit 1
fi

# Resolve absolute path of target
TARGET=$(realpath -e "$1" 2>/dev/null)
if [ -z "$TARGET" ]; then
    echo "Error: File '$1' does not exist" >&2
    exit 1
fi

echo "Searching for symbolic links pointing to: $TARGET"

# Initialize counter
LINK_COUNT=0

# Process each symbolic link found
find ~/ -type l -print0 2>/dev/null | while IFS= read -r -d '' LINK; do
    # Resolve where the link points
    LINK_DEST=$(realpath "$LINK" 2>/dev/null)
    
    # Compare with our target
    if [ "$LINK_DEST" = "$TARGET" ]; then
        echo "[$((++LINK_COUNT))] Found symlink: $LINK"
    fi
done | tee /dev/tty | awk 'END {print "Total symbolic links found: " NR}'

exit 0
