#!/bin/bash
# ====================================================================
#               OSCM — Sovereign Repository Sync & Protection Engine
#                    Universal Scraper Prepper v1.1 - Hardened
# ====================================================================

# Intelligently determine if script is running in local installer directory or live environment
if [ -d "./config" ] && [ -d "./scripts" ]; then
    SOURCE_DIR="$(pwd)"
    TARGET_DIR="$(pwd)/tftpboot/backup_repo"
else
    SOURCE_DIR="/var/www/oscm"
    TARGET_DIR="/var/www/oscm/tftpboot/backup_repo"
fi

echo "===================================================="
echo "   🗄️ OSCM Repository Scraper Preparation Initiated"
echo "   Source Path: $SOURCE_DIR"
echo "   Target Path: $TARGET_DIR"
echo "===================================================="

# 1. Ensure the dedicated isolation directory exists
mkdir -p "$TARGET_DIR"

# 2. Recursively find and copy all configuration files and python scripts
echo " -> Migrating application configuration matrices and scripts..."
find "$SOURCE_DIR" -type f \( -name "*.py" -o -name "*.conf" -o -name "*.sh" -o -name "*.json" -o -name "*.service" \) | while read -r file; do
    # Skip files already inside the tftpboot branch to prevent infinite recursive loops
    if [[ "$file" == *"/tftpboot/"* ]]; then
        continue
    fi
    
    # Mirror the filename into the flat target folder with a .txt safety flag
    filename=$(basename "$file")
    cp "$file" "$TARGET_DIR/${filename}.txt"
done

# 3. Target the frontend layout and handle the index.html collision safely
echo " -> Securing UI layout assets and neutralizing index headers..."
find "$SOURCE_DIR/ui" "$SOURCE_DIR/apps" -type f -name "index.html" 2>/dev/null | while read -r ui_file; do
    # Extract directory name to prevent collisions when backup runs multiple times
    dir_prefix=$(basename "$(dirname "$ui_file")")
    cp "$ui_file" "$TARGET_DIR/ui_${dir_prefix}_index.html.txt"
done

# 4. Guard and handle any raw index.html that slips into the target root directory
if [ -f "$TARGET_DIR/index.html" ]; then
    mv "$TARGET_DIR/index.html" "$TARGET_DIR/index.html.txt"
fi

# Ensure permissions allow full RAG indexing or terminal extraction
chmod -R 644 "$TARGET_DIR"

echo "===================================================="
echo "   🟢 Sync Complete! Folder listing wide open for RAG Scrape."
echo "===================================================="
