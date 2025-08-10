#!/bin/bash

set -e

# --- CONFIG ---
CURRENT_USER="$USER"
HOST_DIR="/home/$CURRENT_USER/hosted"
CONFIG_FILE="$HOME/.shiprc"
TEMPLATE_PATH="/etc/nginx/sites-available/react-template"
SHIP_PATH="/usr/local/bin/ship"
SHIP_BUILD_PATH="/usr/local/bin/ship-build"
REPO_RAW="https://raw.githubusercontent.com/lyes2k/ship/main"

echo "🚀 Installing Ship deployment tool for user: $CURRENT_USER"

# --- 1. Install dependencies ---
echo "📦 Installing required packages..."
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx jq rsync curl

# --- 2. Create hosting directory ---
if [ ! -d "$HOST_DIR" ]; then
    echo "📂 Creating hosting directory at $HOST_DIR..."
    sudo mkdir -p "$HOST_DIR"
    sudo chown -R "$CURRENT_USER":"$CURRENT_USER" "$HOST_DIR"
    sudo chmod 755 "$HOST_DIR"
else
    echo "✅ Hosting directory already exists at $HOST_DIR"
fi

# --- 3. Download Nginx template ---
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "⬇️ Downloading Nginx template..."
    sudo curl -fsSL "$REPO_RAW/templates/react-template" -o "$TEMPLATE_PATH"
else
    echo "✅ Nginx template already exists."
fi

# --- 4. Create config file ---
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📝 Creating Ship config file..."
    echo '{"default_domain": "", "email": "", "deployments": {}}' > "$CONFIG_FILE"
else
    echo "✅ Config file already exists at $CONFIG_FILE"
fi

# --- 5. Download latest ship script ---
echo "⬇️ Downloading ship script..."
sudo curl -fsSL "$REPO_RAW/scripts/ship" -o "$SHIP_PATH"
sudo chmod +x "$SHIP_PATH"

# --- 6. Download latest ship-build script ---
echo "⬇️ Downloading ship-build script..."
sudo curl -fsSL "$REPO_RAW/scripts/ship-build" -o "$SHIP_BUILD_PATH"
sudo chmod +x "$SHIP_BUILD_PATH"

echo "✅ Ship installed successfully for user: $CURRENT_USER"
echo "ℹ️  No default domain set. You must use -d <domain> or set one with:"
echo "    ship --set-default-domain example.com"
echo "ℹ️  No email set. You must set one with:"
echo "    ship --set-email you@example.com"
