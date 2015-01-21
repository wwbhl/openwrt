--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: syncy.lua 2014-04-30 wishinlife $
SyncY Author: wishinlife
QQ: 57956720
E-Mail: wishinlife@gmail.com
Web Home: http://hi.baidu.com/wishinlife
Blog: http://syncyhome.duapp.com
]]--

module("luci.controller.syncy", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/syncy") then
		return
	end

	local page
	page = entry({"admin", "services", "syncy"}, cbi("syncy"), _("SyncY"))
	page.i18n = "syncy"
	page.dependent = true
end
