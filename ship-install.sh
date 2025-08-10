#!/bin/bash

set -e

CURRENT_USER="$USER"
HOST_DIR="/home/$CURRENT_USER/hosted"
CONFIG_FILE="$HOME/.shiprc"
TEMPLATE_PATH="/etc/nginx/sites-available/react-template"
SHIP_PATH="/usr/local/bin/ship"
SHIP_BUILD_PATH="/usr/local/bin/ship-build"

echo "🚀 Installing Ship deployment tool for user: $CURRENT_USER"

# --- 1. Install dependencies ---
echo "📦 Installing required packages..."
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx jq rsync

# --- 2. Create hosting directory ---
if [ ! -d "$HOST_DIR" ]; then
    echo "📂 Creating hosting directory at $HOST_DIR..."
    sudo mkdir -p "$HOST_DIR"
    sudo chown -R "$CURRENT_USER":"$CURRENT_USER" "$HOST_DIR"
    sudo chmod 755 "$HOST_DIR"
else
    echo "✅ Hosting directory already exists at $HOST_DIR"
fi

# --- 3. Create Nginx template ---
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "📝 Creating Nginx template..."
    sudo tee "$TEMPLATE_PATH" >/dev/null <<EOF
server {
    listen 80;
    server_name SUBDOMAIN.BASEDOMAIN;

    root $HOST_DIR/SUBDOMAIN;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }
}
EOF
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

# --- 5. Install ship script from repo ---
if [ -f "scripts/ship" ]; then
    echo "⚙️ Installing ship command..."
    sudo cp scripts/ship "$SHIP_PATH"
    sudo chmod +x "$SHIP_PATH"
else
    echo "❌ scripts/ship not found. Please run this installer from the repo root."
    exit 1
fi

# --- 6. Install ship-build script from repo ---
if [ -f "scripts/ship-build" ]; then
    echo "⚙️ Installing ship-build command..."
    sudo cp scripts/ship-build "$SHIP_BUILD_PATH"
    sudo chmod +x "$SHIP_BUILD_PATH"
else
    echo "❌ scripts/ship-build not found. Please run this installer from the repo root."
    exit 1
fi

echo "✅ Ship installed successfully for user: $CURRENT_USER"
echo "ℹ️  No default domain set. You must use -d <domain> or set one with:"
echo "    ship --set-default-domain example.com"
echo "ℹ️  No email set. You must set one with:"
echo "    ship --set-email you@example.com"
