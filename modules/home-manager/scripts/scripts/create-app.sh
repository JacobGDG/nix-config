#!/usr/bin/env bash
set -euo pipefail

# Resolve applications directory
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
mkdir -p "$APP_DIR"

# Prompt for inputs
read -rp "Application name: " APP_NAME
read -rp "Command to run: " APP_CMD

# Basic sanitization for filename
FILE_NAME="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g').desktop"
DESKTOP_FILE="$APP_DIR/$FILE_NAME"

# Create .desktop file
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$APP_CMD
Terminal=false
Categories=Utility;
EOF

# Make it executable (recommended by spec)
chmod +x "$DESKTOP_FILE"

echo "Created: $DESKTOP_FILE"
