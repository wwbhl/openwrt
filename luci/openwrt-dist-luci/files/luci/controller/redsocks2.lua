--[[
openwrt-dist-luci: RedSocks2
]]--

module("luci.controller.redsocks2", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/redsocks2") then
		return
	end
	local page
	page = node("admin", "wwbhl")
	page.target = firstchild()
	page.title = _("wwbhl")
	page.order  = 65
	entry({"admin", "wwbhl", "redsocks2"}, cbi("redsocks2"), _("RedSocks2"), 72).dependent = true
end
