#!/bin/sh

# EQOSPlus Mod Indonesia Installer
# Repository: https://github.com/Hnatta/equosplusmodid

echo "Starting EQOSPlus Mod Indonesia installation..."

# Repository configuration
REPO_URL="https://raw.githubusercontent.com/Hnatta/equosplusmodid/main"

# Step 1: Remove existing files
echo "Step 1: Removing existing files..."
[ -f "/usr/lib/lua/luci/model/cbi/eqosplus.lua" ] && rm -f "/usr/lib/lua/luci/model/cbi/eqosplus.lua" && echo "Removed eqosplus.lua"
[ -f "/www/uci-static/eqosplus/custom.css" ] && rm -f "/www/uci-static/eqosplus/custom.css" && echo "Removed custom.css"
[ -f "/www/uci-static/eqosplus/custom.js" ] && rm -f "/www/uci-static/eqosplus/custom.js" && echo "Removed custom.js"
[ -f "/www/konversi.html" ] && rm -f "/www/konversi.html" && echo "Removed konversi.html"

# Step 2: Create necessary directories
echo "Step 2: Creating directories..."
mkdir -p /usr/lib/lua/luci/model/cbi
mkdir -p /www/uci-static/eqosplus

# Step 3: Download and install files
echo "Step 3: Downloading and installing files..."

echo "Downloading eqosplus.lua..."
if wget -q -O "/usr/lib/lua/luci/model/cbi/eqosplus.lua" "$REPO_URL/usr/lib/lua/luci/model/cbi/eqosplus.lua"; then
    echo "Successfully installed: eqosplus.lua"
else
    echo "Failed to download: eqosplus.lua"
    exit 1
fi

echo "Downloading custom.css..."
if wget -q -O "/www/uci-static/eqosplus/custom.css" "$REPO_URL/www/uci-static/eqosplus/custom.css"; then
    echo "Successfully installed: custom.css"
else
    echo "Failed to download: custom.css"
    exit 1
fi

echo "Downloading custom.js..."
if wget -q -O "/www/uci-static/eqosplus/custom.js" "$REPO_URL/www/uci-static/eqosplus/custom.js"; then
    echo "Successfully installed: custom.js"
else
    echo "Failed to download: custom.js"
    exit 1
fi

echo "Downloading konversi.html..."
if wget -q -O "/www/konversi.html" "$REPO_URL/www/konversi.html"; then
    echo "Successfully installed: konversi.html"
else
    echo "Failed to download: konversi.html"
    exit 1
fi

# Step 4: Set proper permissions
echo "Step 4: Setting permissions..."
chmod 644 /usr/lib/lua/luci/model/cbi/eqosplus.lua
chmod 644 /www/uci-static/eqosplus/custom.css
chmod 644 /www/uci-static/eqosplus/custom.js
chmod 644 /www/konversi.html

# Step 5: Restart LuCI service
echo "Step 5: Restarting LuCI service..."
if [ -f /etc/init.d/uhttpd ]; then
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
echo "  ✓ /usr/lib/lua/luci/model/cbi/eqosplus.lua"
echo "  ✓ /www/uci-static/eqosplus/custom.css"
echo "  ✓ /www/uci-static/eqosplus/custom.js"
echo "  ✓ /www/konversi.html"
echo ""
echo "Please refresh your browser to see the changes."
echo "Access EQOSPlus at: http://[router-ip]/cgi-bin/luci/admin/network/eqosplus"
echo "Access Konversi at: http://[router-ip]/konversi.html"
echo ""
