// Fungsi untuk membuka modal
function openConverterModal() {
  let modal = document.getElementById('converterModal');
  if (!modal) {
    // Suntikkan modal ke dalam DOM jika belum ada
    const modalHtml = `
      <div id="converterModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.6); z-index:1000; display:flex; align-items:center; justify-content:center; transition:opacity 0.3s ease;">
        <div class="form-konversi" style="position:relative; background:#fff; border-radius:16px; padding:24px; max-width:400px; width:90%; max-height:80vh; overflow-y:auto; box-shadow:0 4px 20px rgba(0,0,0,0.15); transform:scale(0.95); transition:transform 0.3s ease;">
          <button class="close-btn" onclick="closeConverterModal()" style="position:absolute; top:12px; right:12px; background:none; border:none; font-size:24px; cursor:pointer; color:#666;">&times;</button>
          <h2 style="margin:0 0 16px; font-size:1.5em; font-weight:600; color:#1f2a44;">Konversi Kecepatan</h2>
          <label for="mb" style="display:block; margin:8px 0 4px; color:#1f2a44; font-weight:500;">MBps (Megabyte):</label>
          <input type="number" id="mb" value="1" min="0" step="any" oninput="render()" style="width:100%; padding:10px; border:1px solid #d1d5db; border-radius:8px; font-size:1em;">
          <label for="mbit" style="display:block; margin:8px 0 4px; color:#1f2a44; font-weight:500;">Mbps (Megabit):</label>
          <input type="number" id="mbit" value="8" min="0" step="any" oninput="render()" style="width:100%; padding:10px; border:1px solid #d1d5db; border-radius:8px; font-size:1em;">
          <label for="kb" style="display:block; margin:8px 0 4px; color:#1f2a44; font-weight:500;">KBps (Kilobyte):</label>
          <input type="number" id="kb" value="1024" min="0" step="any" oninput="render()" style="width:100%; padding:10px; border:1px solid #d1d5db; border-radius:8px; font-size:1em;">
          <div class="hasil" id="hasil" style="margin-top:20px; background:#f1f5f9; padding:16px; border-radius:10px;">
            <div class="hasil-row" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
              <span class="hasil-label" style="font-weight:500; color:#1f2a44;">MB/s: <span id="out-mb">1</span></span>
              <button class="copy-btn" id="copyBtn" style="padding:6px 16px; border-radius:8px; border:none; background:#3b82f6; color:#fff; font-size:0.9em; font-weight:500; cursor:pointer; transition:background 0.2s;">Salin</button>
            </div>
            <div class="hasil-row" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
              <span class="hasil-label" style="font-weight:500; color:#1f2a44;">Mb/s: <span id="out-mbit">8</span></span>
            </div>
            <div class="hasil-row" style="display:flex; justify-content:space-between; align-items:center;">
              <span class="hasil-label" style="font-weight:500; color:#1f2a44;">KB/s: <span id="out-kb">1024</span></span>
            </div>
          </div>
          <button class="clear-btn" id="clearBtn" style="width:100%; margin-top:16px; padding:10px; border-radius:8px; border:none; background:#ef4444; color:#fff; font-size:1em; font-weight:500; cursor:pointer; transition:background 0.2s;">Bersihkan</button>
        </div>
      </div>`;
    document.body.insertAdjacentHTML('beforeend', modalHtml);
    modal = document.getElementById('converterModal');
    // Tambahkan event listener setelah modal disuntikkan
    document.getElementById('copyBtn').addEventListener('click', copyToClipboard);
    document.getElementById('clearBtn').addEventListener('click', clearInputs);
    document.getElementById('mb').addEventListener('input', render);
    document.getElementById('mbit').addEventListener('input', render);
    document.getElementById('kb').addEventListener('input', render);
  }
  modal.style.display = 'flex';
  setTimeout(() => modal.classList.add('show'), 10); // Animasi masuk
  render(); // Update nilai awal
}

// Fungsi untuk menutup modal
function closeConverterModal() {
  const modal = document.getElementById('converterModal');
  modal.classList.remove('show');
  setTimeout(() => modal.style.display = 'none', 300); // Tunggu animasi selesai
}

// Fungsi untuk format angka
function formatAngka(num) {
  let n = Number(num);
  if (Number.isNaN(n)) return "0";
  return (Math.round(n * 1000) / 1000).toString();
}

// Fungsi untuk menghitung dan memperbarui nilai
function render() {
  let mb = parseFloat(document.getElementById('mb').value) || 0;
  let mbit = mb * 8;
  let kb = mb * 1024;
  if (document.activeElement.id === "mbit") {
    mbit = parseFloat(document.getElementById("mbit").value) || 0;
    mb = mbit / 8;
    kb = mb * 1024;
    document.getElementById('mb').value = formatAngka(mb);
    document.getElementById('kb').value = formatAngka(kb);
  } else if (document.activeElement.id === "kb") {
    kb = parseFloat(document.getElementById("kb").value) || 0;
    mb = kb / 1024;
    mbit = mb * 8;
    document.getElementById('mb').value = formatAngka(mb);
    document.getElementById('mbit').value = formatAngka(mbit);
  } else {
    document.getElementById('mbit').value = formatAngka(mbit);
    document.getElementById('kb').value = formatAngka(kb);
  }
  document.getElementById('out-mb').textContent = formatAngka(mb);
  document.getElementById('out-mbit').textContent = formatAngka(mbit);
  document.getElementById('out-kb').textContent = formatAngka(kb);
}

// Fungsi untuk menyalin ke clipboard
function copyToClipboard() {
  const out = document.getElementById('out-mb');
  const text = (out?.textContent || '').trim();
  if (!text) return;
  try {
    if (navigator.clipboard?.writeText) {
      navigator.clipboard.writeText(text);
    } else {
      const ta = document.createElement('textarea');
      ta.value = text;
      ta.setAttribute('readonly', '');
      ta.style.position = 'fixed';
      ta.style.opacity = '0';
      document.body.appendChild(ta);
      ta.select();
      document.execCommand('copy');
      document.body.removeChild(ta);
    }
    const copyBtn = document.getElementById('copyBtn');
    const oldText = copyBtn.textContent;
    copyBtn.textContent = 'Disalin!';
    copyBtn.style.background = '#22c55e';
    setTimeout(() => {
      copyBtn.textContent = oldText;
      copyBtn.style.background = '#3b82f6';
    }, 1200);
  } catch (e) {
    console.error('Gagal menyalin:', e);
  }
}

// Fungsi untuk mengosongkan input
function clearInputs() {
  document.getElementById('mb').value = '';
  document.getElementById('mbit').value = '';
  document.getElementById('kb').value = '';
  render();
}

// Inisialisasi event listener saat halaman dimuat
document.addEventListener('DOMContentLoaded', () => {
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  if (copyBtn) copyBtn.addEventListener('click', copyToClipboard);
  if (clearBtn) clearBtn.addEventListener('click', clearInputs);
  render();
});


// script dropdown 
document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.querySelector('ul.dropdown');
    const trigger = document.querySelector('#cbid.eqosplus.week'); // Elemen pemicu dropdown

    // Jika dropdown belum ada, keluar dari fungsi
    if (!dropdown || !trigger) return;

    // Fungsi untuk menampilkan dropdown di atas
    function showDropdown() {
        // Dapatkan posisi elemen pemicu
        const triggerRect = trigger.getBoundingClientRect();
        const dropdownHeight = dropdown.offsetHeight;

        // Atur posisi dropdown di atas elemen pemicu
        dropdown.style.position = 'absolute';
        dropdown.style.top = `${triggerRect.top - dropdownHeight - 10}px`; // 10px sebagai jarak
        dropdown.style.left = `${triggerRect.left}px`;
        dropdown.classList.add('active');
    }

    // Fungsi untuk menyembunyikan dropdown
    function hideDropdown() {
        dropdown.classList.remove('active');
    }

    // Tambahkan event listener untuk klik pada elemen pemicu
    trigger.addEventListener('click', function(e) {
        e.stopPropagation(); // Cegah event bubbling
        if (dropdown.classList.contains('active')) {
            hideDropdown();
        } else {
            showDropdown();
        }
    });

    // Sembunyikan dropdown saat klik di luar
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target) && e.target !== trigger) {
            hideDropdown();
        }
    });

    // Update posisi saat window di-resize
    window.addEventListener('resize', function() {
        if (dropdown.classList.contains('active')) {
            showDropdown();
        }
    });

    // Highlight item yang dipilih
    const items = dropdown.querySelectorAll('li:not([placeholder]):not([unselectable])');
    items.forEach(item => {
        item.addEventListener('click', function() {
            items.forEach(i => i.removeAttribute('selected'));
            this.setAttribute('selected', '');
            hideDropdown(); // Sembunyikan dropdown setelah memilih
        });
    });
});
