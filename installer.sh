#!/bin/sh

# EQOSPlus Mod Indonesia Installer
# Sumber repository: https://github.com/Hnatta/equosplusmodid

echo "=== Memulai instalasi EQOSPlus Mod Indonesia ==="

REPO_URL="https://raw.githubusercontent.com/Hnatta/equosplusmodid/main"

# 1. Hapus file lama jika ada
echo "Langkah 1: Menghapus file lama..."
[ -f "/usr/lib/lua/luci/model/cbi/eqosplus.lua" ] && rm -f "/usr/lib/lua/luci/model/cbi/eqosplus.lua" && echo "✓ eqosplus.lua dihapus"   # Hapus file eqosplus.lua lama
[ -f "/usr/lib/lua/luci/view/eqosplus/index.htm" ] && rm -f "/usr/lib/lua/luci/view/eqosplus/index.htm" && echo "✓ index.htm dihapus"   # Hapus file index.htm lama
[ -f "/www/luci-static/eqosplus/custom.css" ] && rm -f "/www/uci-static/eqosplus/custom.css" && echo "✓ custom.css dihapus"             # Hapus file custom.css lama
[ -f "/www/luci-static/eqosplus/custom.js" ] && rm -f "/www/uci-static/eqosplus/custom.js" && echo "✓ custom.js dihapus"               # Hapus file custom.js lama
[ -f "/www/konversi.html" ] && rm -f "/www/konversi.html" && echo "✓ konversi.html dihapus"                                           # Hapus file konversi.html lama

# 2. Pastikan direktori tujuan ada
echo "Langkah 2: Membuat direktori (jika belum ada)..."
mkdir -p /usr/lib/lua/luci/model/cbi      # Pastikan direktori model cbi tersedia
mkdir -p /lib/lua/luci/view/eqosplus    # Pastikan direktori view eqosplus
mkdir -p /www/luci-static/eqosplus         # Pastikan direktori eqosplus tersedia pada uci-static

# 3. Download file baru dari GitHub ke path masing-masing
echo "Langkah 3: Mengunduh dan menempatkan file..."
echo "→ Mengunduh eqosplus.lua..."
curl -fsSL "$REPO_URL/files/usr/lib/lua/luci/model/cbi/eqosplus.lua" -o "/usr/lib/lua/luci/model/cbi/eqosplus.lua" && echo "✓ eqosplus.lua berhasil dipasang" || { echo "Gagal download eqosplus.lua"; exit 1; }

echo "→ Mengunduh index.htm..."
curl -fsSL "$REPO_URL/files/usr/lib/lua/luci/view/eqosplus/index.htm" -o "/usr/lib/lua/luci/view/eqosplus/index.htm" && echo "✓ index.htm berhasil dipasang" || { echo "Gagal download index.htm"; exit 1; }

echo "→ Mengunduh custom.css..."
curl -fsSL "$REPO_URL/files/www/%20luci-static/eqosplus/custom.css" -o "/www/luci-static/eqosplus/custom.css" && echo "✓ custom.css berhasil dipasang" || { echo "Gagal download custom.css"; exit 1; }

echo "→ Mengunduh custom.js..."
curl -fsSL "$REPO_URL/files/www/%20luci-static/eqosplus/custom.js" -o "/www/luci-static/eqosplus/custom.js" && echo "✓ custom.js berhasil dipasang" || { echo "Gagal download custom.js"; exit 1; }

echo "→ Mengunduh konversi.html..."
curl -fsSL "$REPO_URL/files/www/konversi.html" -o "/www/konversi.html" && echo "✓ konversi.html berhasil dipasang" || { echo "Gagal download konversi.html"; exit 1; }

# 4. Set permission baca agar file dapat diakses LuCI/web (umum di OpenWrt 644)
echo "Langkah 4: Mengatur permissions file..."
chmod 644 /usr/lib/lua/luci/model/cbi/eqosplus.lua
chmod 644 /usr/lib/lua/luci/view/eqosplus/index.htm
chmod 644 /www/luci-static/eqosplus/custom.css
chmod 644 /www/luci-static/eqosplus/custom.js
chmod 644 /www/konversi.html

# 5. Restart service LuCI (uhttpd) agar perubahan langsung diterapkan
echo "Langkah 5: Restart service LuCI (web)..."
if [ -f /etc/init.d/uhttpd ]; then
    /etc/init.d/uhttpd restart && echo "✓ Service uhttpd (LuCI) berhasil direstart" || echo "Gagal restart uhttpd"
else
    echo "Peringatan: uhttpd tidak ditemukan, restart manual jika perlu"
fi

# 6. Bersihkan cache LuCI
echo "Langkah 6: Bersihkan cache LuCI..."
rm -rf /tmp/luci-*

echo ""
echo "=========================================="
echo "Instalasi EQOSPlus Mod Indonesia selesai!"
echo "=========================================="
echo "File terpasang:"
echo "  ✓ /usr/lib/lua/luci/model/cbi/eqosplus.lua"
echo "  ✓ /usr/lib/lua/luci/view/eqosplus/index.htm"
echo "  ✓ /www/luci-static/eqosplus/custom.css"
echo "  ✓ /www/luci-static/eqosplus/custom.js"
echo "  ✓ /www/konversi.html"
echo ""
echo "Silakan refresh browser untuk melihat perubahan."
echo "Akses EQOSPlus: http://[router-ip]/cgi-bin/luci/admin/network/eqosplus"
echo "Akses Konversi: http://[router-ip]/konversi.html"
echo ""
