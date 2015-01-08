#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/DG834GTPN
  NAME:=Netgear DG834GT/PN
  PACKAGES:=kmod-ath5k wpad-mini
endef
define Profile/DG834GTPN/Description
  Package set optimized for DG834GT/PN.
endef
$(eval $(call Profile,DG834GTPN))
