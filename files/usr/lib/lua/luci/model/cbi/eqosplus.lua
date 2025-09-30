-- Copyright 2022-2023 sirpdboy <herboy2008@gmail.com>
-- Licensed to the public under the Apache License 2.0.
local sys = require "luci.sys"
local ifaces = sys.net:devices()
local WADM = require "luci.tools.webadmin"
local ipc = require "luci.ip"
local a, t, e

a = Map("eqosplus", translate("Pengaturan Kecepatan Internet"))
a.description = translate("<a href=\'/usr/lib/lua/luci/model/cbi:eqosplus.lua' target=\'_blank\'> eqosplus </a>")..translate("Mengatur batas kecepatan internet tiap perangkat (berdasarkan alamatnya), baik untuk upload maupun download, dengan satuan MB per detik..")..translate("Suggested feedback:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-eqosplus.git' target=\'_blank\'> GitHub</a>")
a.template = "eqosplus/index"

t = a:section(TypedSection, "eqosplus")
t.anonymous = true

e = t:option(DummyValue, "eqosplus_status", translate("Status"))
e.template = "eqosplus/eqosplus"
e.value = translate("Mengumpulkan data...")


ipi = t:option(ListValue, "ifname", translate("Protokol"), translate("<a href='javascript:void(0);' onclick='openConverterModal()'> Konvert speed </a>")..translate(" Atur antarmuka yang digunakan untuk pembatasan"))
ipi.default = "1"
ipi:value(1,translate("Otomatis"))
ipi.rmempty = false
for _, v in pairs(ifaces) do
	net = WADM.iface_get_network(v)
	if net and net ~= "loopback" then
		ipi:value(v)
	end
end

t = a:section(TypedSection, "device")
t.template = "cbi/tblsection"
t.anonymous = true
t.addremove = true

comment = t:option(Value, "comment", translate("Ket."))
comment.size = 8

e = t:option(Flag, "enable", translate("Aktifkan"))
e.rmempty = false
e.size = 4

ip = t:option(Value, "mac", translate("IP/MAC"))

ipc.neighbors({family = 4, dev = "br-lan"}, function(n)
	if n.mac and n.dest then
		ip:value(n.dest:string(), "%s (%s)" %{ n.dest:string(), n.mac })
	end
end)
ipc.neighbors({family = 4, dev = "br-lan"}, function(n)
	if n.mac and n.dest then
		ip:value(n.mac, "%s (%s)" %{n.mac, n.dest:string() })
	end
end)

e.size = 8
dl = t:option(Value, "download", translate("Unduh MBps"))
dl.default = '0.1'
dl.size = 4

ul = t:option(Value, "upload", translate("Unggah MBps"))
ul.default = '0.1'
ul.size = 4
function validate_time(self, value, section)
        local hh, mm, ss
        hh, mm, ss = string.match (value, "^(%d?%d):(%d%d)$")
        hh = tonumber (hh)
        mm = tonumber (mm)
        if hh and mm and hh <= 23 and mm <= 59 then
            return value
        else
            return nil, "Time HH:MM or space"
        end
end

e = t:option(Value, "timestart", translate("Mulai jam"))
e.placeholder = '00:00'
e.default = '00:00'
e.validate = validate_time
e.rmempty = true
e.size = 4

e = t:option(Value, "timeend", translate("Berakhir jam"))
e.placeholder = '00:00'
e.default = '00:00'
e.validate = validate_time
e.rmempty = true
e.size = 4

week=t:option(Value,"week",translate("Hari"))
week.rmempty = true
week:value('0', translate("Setiap Hari"))
week:value(1, translate("Senin"))
week:value(2, translate("Selasa"))
week:value(3, translate("Rabu"))
week:value(4, translate("Kamis"))
week:value(5, translate("Jumat"))
week:value(6, translate("Sabtu"))
week:value(7, translate("Minggu"))
week:value('1,2,3,4,5', translate("Hari Kerja (senin-jumat)"))
week:value('6,7', translate("Hari Libur (sabtu-minggu)"))
week.default = '0'
week.size = 6

return a

