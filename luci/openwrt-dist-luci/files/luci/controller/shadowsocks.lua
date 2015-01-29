--[[
openwrt-dist-luci: ShadowSocks
]]--

module("luci.controller.shadowsocks", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/shadowsocks") then
		return
	end
	local page
	page = node("admin", "wwbhl")
	page.target = firstchild()
	page.title = _("wwbhl")
	page.order  = 65
	entry({"admin", "wwbhl", "shadowsocks"}, cbi("shadowsocks"), _("ShadowSocks"), 74).dependent = true
end
