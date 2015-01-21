#
# Copyright (C) 2008-2015 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for syncy
LUCI_DEPENDS:=+python +python-curl +libcurl +libc +kmod-nls-utf8 +libopenssl

PKG_NAME:=luci-app-syncy
PKG_VERSION:=2.1.0
PKG_RELEASE:=0
PKG_LICENSE:=Apache-2.0
PKGARCH:=all

PKG_MAINTAINER:=wwbhl <8489216@qq.com>

include $(INCLUDE_DIR)/package.mk

define Package/openwrt-dist-luci/Default
        SECTION:=luci
        CATEGORY:=LuCI
        SUBMENU:=3. Applications
        TITLE:=$(1) LuCI interface
        PKGARCH:=all
endef

define Package/openwrt-dist-luci/install
        $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
        $(INSTALL_DATA) ./files/luci/controller/$(2).lua $(1)/usr/lib/lua/luci/controller/$(2).lua
        $(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
        $(INSTALL_DATA) ./files/luci/model/cbi/$(2).lua $(1)/usr/lib/lua/luci/model/cbi/$(2).lua
endef


$(eval $(call BuildPackage,luci-app-syncy))

# call BuildPackage - OpenWrt buildroot signature

