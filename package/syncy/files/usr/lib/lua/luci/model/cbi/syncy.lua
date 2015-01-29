--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: syncy.lua 2015-01-22 wishinlife $
SyncY Author: wishinlife
QQ: 57956720
E-Mail: wishinlife@gmail.com
Web Home: http://hi.baidu.com/wishinlife
Blog: http://syncyhome.duapp.com
]]--

local _version='2.1.1'
local running=(luci.sys.call("kill -0 `cat /var/run/syncy.pid`") == 0)

m = Map("syncy", translate("SyncY--百度网盘同步设置"), translate("<font color=\"Red\"><strong>修改配置文件前最好先停止程序，防止新修改的配置文件被程序中缓存的配置覆盖。<br/>配置文件被修改后也需要重新启动程序方可生效。</strong></font><br/>"))

s = m:section(TypedSection, "syncy", translate("SyncY"))
s.anonymous = true

s:tab("setting", translate("同步设置"))
s:tab("errlog", translate("错误日志"), translate("清空错误日志时，至少须保留1个字符或1空行，否则无法清空日志！"))
s:tab("help", translate("帮助"), translate("作者：WishInLife<br/>版本：%s<br/>使用前请阅读<a target=\"_blank\" href=\"http://syncyhome.duapp.com/index.php/about/license/\">使用协议</a><br/><strong>更多帮助内容及更新信息请访问：<a target=\"_blank\" href=\"http://syncyhome.duapp.com\">http://syncyhome.duapp.com</a></strong><br/><br/><span style=\"color:blue;\">如果您觉得SyncY还不错，可通过<a style=\"color: #ff0000;\" href=\"https://shenghuo.alipay.com/send/payment/fill.htm\" target=\"_blank\">支付宝</a>给作者捐赠。收款人：<span style=\"color:red;\">wishinlife@gmail.com</span><br/>感谢您对SyncY的认可和支持。</span>" %{_version}))

--[[帮助]]--
helpt = s:taboption("help",TextValue,"helptext")
helpt.rows = 27
helpt.readonly = "readonly"
helpt.wrap = "off"
function helpt.cfgvalue(self, section)
	helptext = "同步目录设置：\n" ..
	"  把本地指定的目录同步至服务器端指定的目录，本地目录为相对于系统根目录的完成路径名\n" ..
	"  云端目录为相对于网盘目录“/我的应用程序/SyncY”的相对路径名\n" ..
	"  文件名或路径中不能有以下字符：\\?|\"<>:* \n" ..
	"  同步类型:[0-4]\n" ..
	"	[0,upload]:只检查本地文件并上传修改过的文件，忽略远端的所有修改或删除，远端删除的也不再上传\n" ..
	"	[1,upload+]:远端是本地的完全镜像，忽略远端的修改，远端删除的文件在下一次同步时将上传，远端新增的文件如果本地不存在，将不做任何变化\n" ..
	"	[2,download]:只检查远端文件是否修改，如有修改下载到本地，忽略本地的修改；如本地文件被删除，将不再下载\n" ..
	"	[3,download+]:检查远端和本地文件，如远端有修改，下载到本地，忽略本地的修改；如本地有文件被删除，将重新下载\n" ..
	"	[4,sync]:同时检查远端和本地文件，如只有远端被修改，则下载到本地；如只有本地修改，则上传到远端；如本地和远端都被修改，则以冲突设置方式为准。\n" ..
	"	4模式下，当远端目录更改后，请删除本地根目录下的.syncy.info.db文件，否则在下次同步时将会删除本地的所有文件（系统会认为远程文件不需要被用户删除，也会删除本地的相应文件）\n" ..
	"上传块大小：\n" ..
	"	默认值为 10 (10M)\n" ..
	"	分片上传的块大小（单位：M），此大小决定了能上传的最大文件大小（文件最大大小 = blocksize * 1024）\n" ..
	"排除文件：\n" ..
	"	排除文件或文件夹，将会同时应用于本地和远端，有多个排除项时用分号(;)隔开\n" ..
	"	例：'*/Thumbs.db;*/excludefilename.*'\n" ..
	"	只支持通配符*? (*代表零个或更多个任意字符，?代表零个或一个字符)\n" ..
	"每次检查获取远程的文件数：\n" ..
	"	默认值为 100\n" ..
	"	同步时每次获取的远端文件列表数量，数量过大时返回的字符串长度很大，将占用更多的内存\n" ..
	"运行期间：\n" ..
	"	运行时间段（小时），默认值为 '0-24'\n" ..
	"	判断规则为[0,24)即包含设定的开始时间截止于设定的结束时间\n" ..
	"	如想从零点至6点之间才允许运行，应设置为'0-6'，如24小时都运行，则设置为'0-24'\n" ..
	"间隔时间：\n" ..
	"	每次同步完成之后与下一次开始同步的间隔时间（单位：秒），默认值为 3600(1小时)" 
	return helptext
end

--[[读取错误日志]]--
er = s:taboption("errlog", TextValue, "errlog")
er.rows = 30
local cfg = nixio.fs.readfile("/etc/config/syncy")
local logfile = cfg:match("option[ ]+syncyerrlog[ ]+'([^']*)'")
function er.cfgvalue(self, section)
	if logfile then
		return nixio.fs.readfile(logfile)
	end
end
function er.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile(logfile, value)
end


--[[同步设置
]]--
en=s:taboption("setting", Flag, "enabled", translate("开机自动启动"))
en.rmempty = false
en.enabled = "1"
en.disabled = "0"
function en.cfgvalue(self,section)
	return luci.sys.init.enabled("syncy") and self.enabled or self.disabled
end
function en.write(self,section,value)
	if value == "1" then
		luci.sys.call("/etc/init.d/syncy enable >/dev/null")
	else
		luci.sys.call("/etc/init.d/syncy disable >/dev/null")
	end
end

if running then
	op = s:taboption("setting", Button, "stop", translate("停止运行.."),translate("<strong><font color=\"red\">SyncY正在运行.......</font></strong>"))
	op.inputstyle = "remove"
else
	op = s:taboption("setting",Button, "start", translate("启动.."),translate("<strong>SyncY尚未启动.......</strong>"))
	op.inputstyle = "apply"
end
op.write = function(self, section)
	opstatus = (luci.sys.call("/etc/init.d/syncy %s >/dev/null" %{ self.option }) == 0)
	if self.option == "start" and opstatus then
		self.inputstyle = "remove"
		self.title = "停止运行.."
		self.description = "<strong><font color=\"red\">SyncY正在运行.......</font></strong>"
		self.option = "stop"
	elseif opstatus then
		self.inputstyle = "apply"
		self.title = "启动.."
		self.description = "<strong>SyncY尚未启动.......</strong>"
		self.option = "start"
	end
end


if nixio.fs.access("/tmp/syncy.bind") then
	local usercode = nixio.fs.readfile("/tmp/syncy.bind")
	usercode = usercode:match(".*\"user_code\":\"([0-9a-z]+)\".*")
	if usercode then
		sybind = s:taboption("setting",Button, "cpbind", translate("已完成百度授权，继续帐号绑定"))
		sybind.inputstyle = "save"
		sybind.description = "<strong>绑定操作步骤：</strong><br/>1、打开百度授权页面：<a target=\"_blank\" href=\"https://openapi.baidu.com/device\">https://openapi.baidu.com/device</a><br/>2、登录百度帐号并输入用户码：<strong><font color=\"red\">%s</font></strong>，点击继续按钮完成授权<br/>3、完成授权后点击上面的按钮完成绑定操作<br/><strong><font color=\"red\">请在30分钟内完成以上操作<br/>要取消绑定操作，直接点击上面完成按钮即可（不会修改原有授权信息）</font></strong>" %{usercode}
	else
		sybind = s:taboption("setting", Button, "sybind", translate("帐号绑定/重新绑定"))
		sybind.inputstyle = "apply"
		local binded = nixio.fs.readfile("/etc/config/syncy")
		binded = binded:match(".*option (device_code) '([0-9a-z]+)'.*")
		if binded == "device_code" then
			sybind.title = "重新绑定百度帐号"
			sybind.description = "要想重新绑定必须先在百度帐号管理中解除SyncY的绑定。"
		else
			sybind.title = "绑定百度帐号"
		end
	end
else
	sybind = s:taboption("setting", Button, "sybind", translate("帐号绑定/重新绑定"))
	sybind.inputstyle = "apply"
	local binded = nixio.fs.readfile("/etc/config/syncy")
	binded = binded:match(".*option (device_code) '([0-9a-z]+)'.*")
	if binded == "device_code" then
		sybind.title = "重新绑定百度帐号"
		sybind.description = "要想重新绑定必须先在百度帐号管理中解除SyncY的绑定。"
	else
		sybind.title = "绑定百度帐号"
	end
end
sybind.write = function(self, section, value)
	local opstatus = luci.sys.call("/usr/bin/syncy.py %s" %{self.option})
	if self.option == "cpbind" then
		self.option = "sybind"
		self.inputstyle = "apply"
		local binded = nixio.fs.readfile("/etc/config/syncy")
		binded = binded:match(".*option (device_code) '([0-9a-z]+)'.*")
		if binded == "device_code" then
			sybind.title = "重新绑定百度帐号"
		else
			sybind.title = "绑定百度帐号"
		end
		if opstatus == 0 then
			self.description = "<strong><font color=\"red\">绑定完成！</font></strong><br/>要想重新绑定必须先在百度帐号管理中解除SyncY的绑定。"
			if running then
				luci.sys.call("/etc/init.d/syncy restart >/dev/null")
			end
		else
			self.description = "<strong><font color=\"red\">绑定失败！</font></strong>"
		end
	else
		if opstatus == 0 and nixio.fs.access("/tmp/syncy.bind") then
			local usercode = nixio.fs.readfile("/tmp/syncy.bind")
			usercode = usercode:match(".*\"user_code\":\"([0-9a-z]+)\".*")
			self.option = "sybind"
			self.inputstyle = "save"
			self.title = "已完成百度授权，继续帐号绑定"
			self.description = "<script language=\"JavaScript\">window.location=location;</script>"
		else
			self.description = "<strong><font color=\"red\">获取用户码失败！</font></strong>"
		end
	end
end


s:taboption("setting", Value, "syncyerrlog", translate("错误日志文件"),translate("日志文件名必须包含路径名，且不能指向已存在的目录，必须指向普通文件。"))
s:taboption("setting", Value, "syncylog", translate("运行日志文件"),translate("日志文件名必须包含路径名，且不能指向已存在的目录，必须指向普通文件。"))
s:taboption("setting", Value, "tasknumber", translate("同时同步的任务数")).rmempty = false
s:taboption("setting", Value, "threadnumber", translate("每个任务的线程数")).rmempty = false
s:taboption("setting", Value, "blocksize", translate("分片上传下载块大小(M)")).rmempty = false
o = s:taboption("setting", ListValue, "ondup", translate("重名处理方式"))
o.default = "rename"
o:value("rename", translate("重命名文件"))
o:value("overwrite", translate("覆盖重名文件"))
o = s:taboption("setting", ListValue, "datacache", translate("是否开启缓存"))
o.default = "on"
o:value("on", translate("开启"))
o:value("off", translate("关闭"))
--[[
o = s:taboption("setting", ListValue, "slicedownload", translate("分片下载大文件"), translate("开启后将根据分片上传下载块大小的设置来分片下载大文件。"))
o.default = "on"
o:value("on", translate("开启"))
o:value("off", translate("关闭"))
o = s:taboption("setting", ListValue, "fileconsistency", translate("文件一致性检查"), translate("是否通过文件的md5值来检查上传或下载的文件与原文件是否一致，如关闭将只检查文件大小是否一致。"))
o.default = "on"
o:value("on", translate("开启"))
o:value("off", translate("关闭"))
]]--
s:taboption("setting", Value, "excludefiles", translate("排除文件")).rmempty = false
s:taboption("setting", Value, "listnumber", translate("每次检查获取远程的文件数")).rmempty = false
s:taboption("setting", Value, "retrytimes", translate("失败重试次数")).rmempty = false
s:taboption("setting", Value, "retrydelay", translate("重试延时时间(秒)")).rmempty = false
s:taboption("setting", Value, "speedlimitperiod", translate("限速时间段")).rmempty = false
s:taboption("setting", Value, "maxsendspeed", translate("最大上传速度(字节/秒)")).rmempty = false
s:taboption("setting", Value, "maxrecvspeed", translate("最大下载速度(字节/秒)")).rmempty = false
s:taboption("setting", Value, "syncperiod", translate("运行时间段")).rmempty = false
s:taboption("setting", Value, "syncinterval", translate("同步间隔时间(秒)")).rmempty = false

--[[同步目录设置
]]--
s = m:section(TypedSection, "syncpath", translate("同步目录"))
s.anonymous = true
s.addremove = true
s.sortable  = true
s.template = "cbi/tblsection"

sen = s:option(Flag, "enable", translate("启用"))
sen.default = "1"
sen.rmempty = false
sen.enabled = "1"
sen.disabled = "0"

pth = s:option(Value, "localpath", translate("本地目录"))
pth.rmempty = false
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

s:option(Value, "remotepath", translate("云端目录"), translate("与云端目录“/我的应用程序/SyncY”的相对路径")).rmempty = false

st = s:option(ListValue, "synctype", translate("同步类型"))
st.default = "upload"
st:value("upload", translate("0-单向上传"))
st:value("upload+", translate("1-单向上传+"))
st:value("download", translate("2-单向下载"))
st:value("download+", translate("3-单向下载+"))
st:value("sync", translate("4-双向同步"))

return m
