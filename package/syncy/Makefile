include $(TOPDIR)/rules.mk


PKG_NAME:=luci-app-syncy
PKG_VERSION:=2.1.2
PKG_RELEASE:=2
PKG_MAINTAINER:=wwbhl <8489216@qq.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-syncy
  SECTION:=luci
  CATEGORY:=wwbhl
  SUBMENU:=1. Luci Applications
  DEPENDS:=+python +python-curl +libcurl +libc +kmod-nls-utf8 +libopenssl
  TITLE:=syncy
  PKGARCH:=all
endef


define Package/luci-app-syncy/description
LuCI Support for syncy
endef
define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-syncy/conffiles
/etc/config/syncy
endef

define Package/luci-app-syncy/postinst
#!/bin/sh
[ -f /etc/config/syncy.bak.syy ] && mv /etc/config/syncy.bak.syy /etc/config/syncy
exit 0
endef

define Package/luci-app-syncy/preinst
#!/bin/sh
[ -f /etc/config/syncy ] && cp /etc/config/syncy /etc/config/syncy.bak.syy
exit 0
endef

Package/luci-app-syncy/prerm = $(Package/luci-app-syncy/preinst)

define Package/luci-app-syncy/install
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

$(eval $(call BuildPackage,luci-app-syncy))
