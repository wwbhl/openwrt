include $(TOPDIR)/rules.mk


PKG_NAME:=syncy
PKG_VERSION:=2.1.1
PKG_RELEASE:=1
PKG_MAINTAINER:=wwbhl <8489216@qq.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/syncy
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=File Transfer
  DEPENDS:=+python +python-curl +libcurl +libc +kmod-nls-utf8 +libopenssl
  TITLE:=syncy
  PKGARCH:=all
endef


define Package/syncy/description
LuCI Support for syncy
endef
define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/syncy/conffiles
/etc/config/syncy
endef

define Package/syncy/postinst
#!/bin/sh
[ -f /etc/config/syncy.bak.syy ] && mv /etc/config/syncy.bak.syy /etc/config/syncy
exit 0
endef

define Package/syncy/preinst
#!/bin/sh
[ -f /etc/config/syncy ] && cp /etc/config/syncy /etc/config/syncy.bak.syy
exit 0
endef

Package/syncy/prerm = $(Package/syncy/preinst)

define Package/syncy/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/syncy $(1)/etc/config/syncy
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/syncy.py $(1)/usr/bin/syncy.py
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/syncy $(1)/etc/init.d/syncy
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/syncy.lua $(1)/usr/lib/lua/luci/controller/syncy.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/syncy.lua $(1)/usr/lib/lua/luci/model/cbi/syncy.lua
endef

$(eval $(call BuildPackage,syncy))
