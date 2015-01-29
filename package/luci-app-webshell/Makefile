include $(TOPDIR)/rules.mk


PKG_NAME:=luci-app-webshell
PKG_VERSION:=3
PKG_RELEASE:=0
PKG_MAINTAINER:=wwbhl <8489216@qq.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/webshell
  SECTION:=luci
  CATEGORY:=wwbhl
  SUBMENU:=1. Luci Applications
  DEPENDS:=
  TITLE:=luci-app-webshell
  PKGARCH:=all
endef


define Package/luci-app-webshell/description
LuCI Support for webshell
endef
define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef




define Package/luci-app-webshell/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/webshell.lua $(1)/usr/lib/lua/luci/controller/webshell.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/view/webshell.htm $(1)/usr/lib/lua/luci/view/webshell.htm
endef

$(eval $(call BuildPackage,luci-app-webshell))
