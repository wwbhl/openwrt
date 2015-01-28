--[[
openwrt-dist-luci: ShadowVPN
]]--

module("luci.controller.shadowvpn", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/shadowvpn") then
		return
	end
	local page
	page = node("admin", "wwbhl")
	page.target = firstchild()
	page.title = _("wwbhl")
	page.order  = 65
	entry({"admin", "wwbhl", "shadowvpn"}, cbi("shadowvpn"), _("ShadowVPN"), 76).dependent = true
end
