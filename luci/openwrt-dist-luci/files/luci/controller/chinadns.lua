--[[
openwrt-dist-luci: ChinaDNS
]]--

module("luci.controller.chinadns", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/chinadns") then
		return
	end
	local page
	page = node("admin", "wwbhl")
	page.target = firstchild()
	page.title = _("wwbhl")
	page.order  = 65
	entry({"admin", "wwbhl", "chinadns"}, cbi("chinadns"), _("ChinaDNS"), 70).dependent = true
end
