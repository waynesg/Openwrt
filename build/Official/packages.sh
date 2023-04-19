#!/bin/bash

# create directory
[[ ! -d package/waynesg ]] && mkdir -p package/waynesg

# AutoCore
cp -rf ../immortalwrt/package/emortal/autocore package/waynesg/
cp -rf ../immortalwrt/package/utils/mhz package/utils/
cp -rf ../immortalwrt-luci/modules/luci-base/root/usr/libexec/rpcd/luci feeds/luci/modules/luci-base/root/usr/libexec/rpcd/
# grant getCPUUsage access
sed -i 's|"getTempInfo"|"getTempInfo", "getCPUBench", "getCPUUsage"|g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json

# automount
cp -rf ../lede/package/lean/automount package/waynesg/
cp -rf ../lede/package/lean/ntfs3-mount package/waynesg/
# backport ntfs3 patches
cp -rf ../lede/target/linux/generic/files-5.10 target/linux/generic/

# FullCone nat for nftables
# patch kernel
cp -f ../immortalwrt/target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.10/
# fullconenat-nft
cp -rf ../immortalwrt/package/network/utils/fullconenat-nft package/network/utils/
# patch libnftnl
cp -rf ../immortalwrt/package/libs/libnftnl/patches package/libs/libnftnl/
sed -i '/PKG_INSTALL:=1/i\PKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
# patch nftables
#cp -f ../immortalwrt/package/network/utils/nftables/patches/002-nftables-add-fullcone-expression-support.patch package/network/utils/nftables/patches/
rm -rf package/network/utils/nftables/
cp -rf ../immortalwrt/package/network/utils/nftables package/network/utils/
# patch firewall4
cp -rf ../immortalwrt/package/network/config/firewall4/patches package/network/config/firewall4/
sed -i 's|+kmod-nft-nat +kmod-nft-nat6|+kmod-nft-nat +kmod-nft-nat6 +kmod-nft-fullcone|g' package/network/config/firewall4/Makefile
# patch luci
patch -d feeds/luci -p1 -i ../../../patches/fullconenat-luci.patch

# dnsmasq: add filter aaa option
cp -rf ../patches/910-add-filter-aaaa-option-support.patch package/network/services/dnsmasq/patches/
patch -p1 -i ../patches/dnsmasq-add-filter-aaaa-option.patch
patch -d feeds/luci -p1 -i ../../../patches/filter-aaaa-luci.patch

# dnsmasq: use nft ruleset for dns_redirect
patch -p1 -i ../patches/dnsmasq-use-nft-ruleset-for-dns_redirect.patch

# mbedtls
rm -rf package/libs/mbedtls
cp -rf ../immortalwrt/package/libs/mbedtls package/libs/

##-------------------------------------------------------------------------------------------------------
# cpufreq
cp -rf ../immortalwrt-luci/applications/luci-app-cpufreq package/waynesg/

# DDNS
cp -rf ../immortalwrt-packages/net/ddns-scripts_{aliyun,dnspod} package/waynesg/

# Access Control
cp -rf ../immortalwrt-luci/applications/luci-app-accesscontrol package/waynesg/

# arpbind
cp -rf ../immortalwrt-luci/applications/luci-app-arpbind package/waynesg/

# Filetransfer
cp -rf ../immortalwrt-luci/applications/luci-app-filetransfer package/waynesg/
cp -rf ../immortalwrt-luci/libs/luci-lib-fs package/waynesg/

# OLED
svn export -q https://github.com/NateLol/luci-app-oled/trunk package/waynesg/luci-app-oled

# OpenClash
svn export -q https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/waynesg/luci-app-openclash

# Realtek R8125, RTL8152/8153, RTL8192EU
cp -rf ../immortalwrt/package/kernel/{r8125,r8152,rtl8192eu} package/waynesg/

# Release Ram
cp -rf ../immortalwrt-luci/applications/luci-app-ramfree package/waynesg/

# Scheduled Reboot
cp -rf ../immortalwrt-luci/applications/luci-app-autoreboot package/waynesg/

# SeverChan
svn export -q https://github.com/tty228/luci-app-serverchan/trunk package/waynesg/luci-app-serverchan

# ShadowsocksR Plus+
svn export -q https://github.com/fw876/helloworld/trunk package/helloworld
svn export -q https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/helloworld/shadowsocks-libev
rm -rf ./feeds/packages/net/{xray-core,shadowsocks-libev}

# USB Printer
cp -rf ../immortalwrt-luci/applications/luci-app-usb-printer package/waynesg/

# vlmcsd
cp -rf ../immortalwrt-luci/applications/luci-app-vlmcsd package/waynesg/
cp -rf ../immortalwrt-packages/net/vlmcsd package/waynesg/

# xlnetacc
cp -rf ../immortalwrt-luci/applications/luci-app-xlnetacc package/waynesg/

# Zerotier
cp -rf ../immortalwrt-luci/applications/luci-app-zerotier package/waynesg/

# default settings and translation
#cp -rf ../default-settings package/waynesg/

# fix include luci.mk
find package/waynesg/ -type f -name Makefile -exec sed -i 's,../../luci.mk,$(TOPDIR)/feeds/luci/luci.mk,g' {} +

#Alist
git clone -b master --depth 1 https://github.com/sbwml/luci-app-alist.git package/waynesg/luci-app-alist

#autotimeset
svn co https://github.com/sirpdboy/luci-app-autotimeset/trunk package/waynesg/luci-app-autotimeset

#Bypass
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/waynesg/luci-app-bypass

#Cloudflarespeedtest
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cloudflarespeedtest package/waynesg/luci-app-cloudflarespeedtest
svn co https://github.com/immortalwrt-collections/openwrt-cdnspeedtest/trunk/cdnspeedtest package/waynesg/luci-app-cloudflarespeedtest/cdnspeedtest

#Parentcontrol
svn co https://github.com/sirpdboy/luci-app-parentcontrol/trunk package/waynesg/luci-app-parentcontrol

#speedlimit
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-speedlimit package/waynesg/luci-app-control-speedlimit

#timewol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-timewol package/waynesg/luci-app-control-timewol

#webrestriction
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-webrestriction package/waynesg/luci-app-control-webrestriction

#mosdns
svn co https://github.com/sbwml/luci-app-mosdns/trunk package/waynesg/luci-app-mosdns

#tn-netports
svn co https://github.com/waynesg/luci-app-tn-netports/trunk package/waynesg/luci-app-tn-netports

#luci-app-netspeedtest
svn co https://github.com/sirpdboy/netspeedtest/trunk package/waynesg/luci-app-netspeedtest

#luci-app-oaf
svn co https://github.com/destan19/OpenAppFilter/trunk package/waynesg/luci-app-oaf

#onliner
svn co https://github.com/Hyy2001X/AutoBuild-Packages/trunk/luci-app-onliner package/waynesg/luci-app-onliner

#Pushbot
svn co https://github.com/zzsj0928/luci-app-pushbot/trunk package/waynesg/luci-app-pushbot

#airconnect
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/luci-app-airconnect package/waynesg/luci-app-airconnect
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/airconnect package/waynesg/luci-app-airconnect/airconnect

#wizard
svn co https://github.com/kiddin9/luci-app-wizard/trunk package/waynesg/luci-app-wizard

#advanced
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-advanced package/waynesg/luci-app-advanced

#wrtbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/waynesg/luci-app-wrtbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/waynesg/luci-app-wrtbwmon/wrtbwmon

#socat
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-socat package/waynesg/luci-app-socat
cp -rf ../immortalwrt-packages/net/socat package/waynesg/

#passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall -b luci-smartdns-new-version package/waynesg/openwrt-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 package/waynesg/openwrt-passwall2
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall -b packages /package/waynesg/packages

#internet-detector
git clone -b master --depth 1 https://github.com/waynesg/luci-app-internet-detector package/waynesg/luci-app-internet-detector
