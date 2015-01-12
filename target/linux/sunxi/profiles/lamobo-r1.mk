#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

USING_EXTERNAL_KERNEL=y

#LINUX_VERSION:=3.4

define Profile/Lamobo-R1
	NAME:=Lamobo R1
	PACKAGES:=\
		uboot-sunxi-Lamobo-R1 ata-sunxi kmod-sunxi-gmac kmod-net-rtl8188eu kmod-rtl8192cu kmod-b53 kmod-swconfig swconfig
endef

define Profile/Lamobo-R1/Description
	Package set optimized for the Lamobo R1
endef

DEFAULT_PACKAGES += swconfig
$(eval $(call Profile,Lamobo-R1))
