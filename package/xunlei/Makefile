include $(TOPDIR)/rules.mk


PKG_NAME:=luci-app-xunlei
PKG_VERSION:=0.11
PKG_RELEASE:=14
PKG_MAINTAINER:=wwbhl <8489216@qq.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-xunlei
  SECTION:=luci
  CATEGORY:=wwbhl
  SUBMENU:=3. Download Applications
  DEPENDS:=+libc
  TITLE:=xunlei
  PKGARCH:=all
endef


define Package/luci-app-xunlei/description
LuCI Support for xunlei
endef
define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/xunlei/conffiles
/etc/config/xunlei
endef

define Package/luci-app-xunlei/postinst
#!/bin/sh 
[ -n "${IPKG_INSTROOT}" ] || {
	( . /etc/uci-defaults/luci-xunlei ) && rm -f /etc/uci-defaults/luci-xunlei
	/etc/init.d/xunlei enable >/dev/null 2>&1
	exit 0
}

endef


define Package/luci-app-xunlei/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/xunlei $(1)/etc/config/xunlei
	$(INSTALL_DIR) $(1)/etc/xware
	$(INSTALL_BIN) ./files/etc/xware/cfg $(1)/etc/xware/cfg
	$(INSTALL_BIN) ./files/etc/xware/xlatest $(1)/etc/xware/xlatest
	$(INSTALL_BIN) ./files/etc/xware/xlup $(1)/etc/xware/xlup
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/xunlei $(1)/etc/init.d/xunlei
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/luci-xunlei $(1)/etc/uci-defaults/luci-xunlei
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/xunlei.lua $(1)/usr/lib/lua/luci/controller/xunlei.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/xunlei.lua $(1)/usr/lib/lua/luci/model/cbi/xunlei.lua
endef

$(eval $(call BuildPackage,luci-app-xunlei))

