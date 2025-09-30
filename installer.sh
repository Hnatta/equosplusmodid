#!/bin/sh

# EQOSPlus Mod Indonesia Installer
# Repository: https://github.com/Hnatta/equosplusmodid

echo "Starting EQOSPlus Mod Indonesia installation..."

# Repository configuration
REPO_URL="https://raw.githubusercontent.com/Hnatta/equosplusmodid/main"

# File paths
FILES=(
    "usr/lib/lua/luci/model/cbi/eqosplus.lua:/usr/lib/lua/luci/model/cbi/eqosplus.lua"
    "www/uci-static/eqosplus/custom.css:/www/uci-static/eqosplus/custom.css"
    "www/uci-static/eqosplus/custom.js:/www/uci-static/eqosplus/custom.js"
    "www/konversi.html:/www/konversi.html"
)

# Step 1: Remove existing files
echo "Step 1: Removing existing files..."
for file_pair in "${FILES[@]}"; do
    local_path=$(echo "$file_pair" | cut -d':' -f2)
    if [ -f "$local_path" ]; then
        echo "Removing $local_path"
        rm -f "$local_path"
    fi
done

# Step 2: Create necessary directories
echo "Step 2: Creating directories..."
mkdir -p /usr/lib/lua/luci/model/cbi
mkdir -p /www/uci-static/eqosplus

# Step 3: Download and install files
echo "Step 3: Downloading and installing files..."
for file_pair in "${FILES[@]}"; do
    github_path=$(echo "$file_pair" | cut -d':' -f1)
    local_path=$(echo "$file_pair" | cut -d':' -f2)
    
    echo "Downloading $github_path..."
    if wget -q -O "$local_path" "$REPO_URL/$github_path"; then
        echo "Successfully installed: $local_path"
    else
        echo "Failed to download: $github_path"
        exit 1
    fi
done

# Step 4: Set proper permissions
echo "Step 4: Setting permissions..."
chmod 644 /usr/lib/lua/luci/model/cbi/eqosplus.lua
chmod 644 /www/uci-static/eqosplus/custom.css
chmod 644 /www/uci-static/eqosplus/custom.js
chmod 644 /www/konversi.html

# Step 5: Restart LuCI service
echo "Step 5: Restarting LuCI service..."
if which service >/dev/null 2>&1; then
    service uhttpd restart
elif [ -f /etc/init.d/uhttpd ]; then
    /etc/init.d/uhttpd restart
else
    echo "Warning: Could not restart LuCI service automatically"
fi

# Step 6: Clear LuCI cache
echo "Step 6: Clearing LuCI cache..."
rm -rf /tmp/luci-*

echo ""
echo "=========================================="
echo "EQOSPlus Mod Indonesia installation completed!"
echo "=========================================="
echo ""
echo "Files installed:"
for file_pair in "${FILES[@]}"; do
    local_path=$(echo "$file_pair" | cut -d':' -f2)
    echo "  ✓ $local_path"
done
echo ""
echo "Please refresh your browser to see the changes."
echo "Access EQOSPlus at: http://[router-ip]/cgi-bin/luci/admin/network/eqosplus"
echo "Access Konversi at: http://[router-ip]/konversi.html"
echo ""
