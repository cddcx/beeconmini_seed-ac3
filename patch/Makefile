include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=switch-rtl8373n-ac3
PKG_VERSION:=0.0.1

PKG_SOURCE_URL=https://github.com/BeeconMini/beeconmini_drivers.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=main
PKG_SOURCE_BRANCH:=main

include $(INCLUDE_DIR)/package.mk

define KernelPackage/switch-rtl8373n-ac3
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  TITLE:=Realtek RTL8373N switch support
  DEPENDS:=+kmod-i2c-gpio
  FILES:= $(PKG_BUILD_DIR)/rtl8373n.ko
  AUTOLOAD:=$(call AutoProbe,rtl8373n)
endef

define Build/Compile
	if [ -f "$(PKG_BUILD_DIR)/seed_ac3/rtl8373n/$(LINUX_VERSION)/rtl8373n.ko" ]; then \
		$(CP) "$(PKG_BUILD_DIR)/seed_ac3/rtl8373n/$(LINUX_VERSION)/rtl8373n.ko" $(PKG_BUILD_DIR); \
	else \
		$(CP) "$(PKG_BUILD_DIR)/seed_ac3/rtl8373n/generic/rtl8373n.ko" $(PKG_BUILD_DIR); \
	fi
endef

$(eval $(call KernelPackage,switch-rtl8373n-ac3))
