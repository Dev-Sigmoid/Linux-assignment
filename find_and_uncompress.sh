#!/bin/bash

# Find the file named 'research' with known compressed extensions
echo "Searching for compressed 'research' file..."
file_path=$(find / -type f \( -name "research.gz" -o -name "research.zip" -o -name "research.xz" -o -name "research.bz2" \) 2>/dev/null | head -n 1)

# If no file found, exit
if [[ -z "$file_path" ]]; then
    echo "No compressed file named 'research' found."
    exit 1
fi

echo "Found: $file_path"

# Extract extension
extension="${file_path##*.}"

# Change to the file's directory
file_dir=$(dirname "$file_path")
cd "$file_dir" || exit

# Uncompress based on type
case "$extension" in
    gz)
        echo "Uncompressing with gunzip..."
        gunzip research.gz
        ;;
    zip)
        echo "Uncompressing with unzip..."
        unzip research.zip
        ;;
    xz)
        echo "Uncompressing with unxz..."
        unxz research.xz
        ;;
    bz2)
        echo "Uncompressing with bunzip2..."
        bunzip2 research.bz2
        ;;
    *)
        echo "Unsupported file type: .$extension"
        exit 2
        ;;
esac

echo "File uncompressed successfully."
