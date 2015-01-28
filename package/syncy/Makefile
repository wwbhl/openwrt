include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for syncy
LUCI_DEPENDS:=+python +python-curl +libcurl +libc +kmod-nls-utf8 +libopenssl


PKG_NAME:=syncy
PKG_VERSION:=2.1.1
PKG_RELEASE:=1
PKG_RELEASE=$(PKG_SOURCE_VERSION)


PKG_MAINTAINER:=wwbhl <8489216@qq.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/syncy-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/syncy/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=File Transfer
  TITLE:=syncy
	URL:=http://syncyhome.duapp.com
endef

define Package/syncy
  $(call Package/syncy/Default)
endef

define Package/syncy/description
LuCI Support for syncy
endef

define Package/syncy/conffiles
/etc/config/syncy
endef

Package/syncy/conffiles = $(Pakage/syncy/conffiles)

define Package/syncy/postinst
#!/bin/sh
[ -f /etc/config/syncy.bak.syy ] && mv /etc/config/syncy.bak.syy /etc/config/syncy
exit 0

endef

Package/syncy/postinst = $(Package/syncy/postinst)


define Package/syncy/prerm
#!/bin/sh
[ -f /etc/config/syncy ] && cp /etc/config/syncy /etc/config/syncy.bak.syy
exit 0


endef

Package/syncy/prerm = $(Package/syncy/prerm)

define Package/syncy/preinst
#!/bin/sh
[ -f /etc/config/syncy ] && cp /etc/config/syncy /etc/config/syncy.bak.syy
exit 0

endef

Package/syncy/preinst = $(Package/syncy/preinst)



define Package/syncy/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/syncy $(1)/etc/config/syncy
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/syncy.py $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/syncy $(1)/etc/init.d/syncy
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/syncy.lua $(1)/usr/lib/lua/luci/controller/syncy.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/syncy.lua $(1)/usr/lib/lua/luci/model/cbi/syncy.lua
	

	
endef

Package/syncy/install = $(Package/syncy/install)

$(eval $(call BuildPackage,syncy))
