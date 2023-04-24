#!/bin/bash
#Kernel
latest_release="$(curl -s https://github.com/openwrt/openwrt/tags | grep -Eo "v[0-9\.]+\-*r*c*[0-9]*.tar.gz" | sed -n '/[2-9][0-9]/p' | sed -n 1p | sed 's/.tar.gz//g')"
git clone --single-branch -b ${latest_release} https://github.com/openwrt/openwrt ${GITHUB_WORKSPACE}/openwrt_release
rm -f ${GITHUB_WORKSPACE}/openwrt/include/version.mk
rm -f ${GITHUB_WORKSPACE}/openwrt/include/kernel.mk
rm -f ${GITHUB_WORKSPACE}/openwrt/include/kernel-5.10
rm -f ${GITHUB_WORKSPACE}/openwrt/include/kernel-version.mk
rm -f ${GITHUB_WORKSPACE}/openwrt/include/toolchain-build.mk
rm -f ${GITHUB_WORKSPACE}/openwrt/include/kernel-defaults.mk
rm -f ${GITHUB_WORKSPACE}/openwrt/package/base-files/image-config.in
rm -rf ${GITHUB_WORKSPACE}/openwrt/target/linux/*
rm -rf ${GITHUB_WORKSPACE}/openwrt/package/kernel/linux/*
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/version.mk ${GITHUB_WORKSPACE}/openwrt/include/version.mk
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/kernel.mk ${GITHUB_WORKSPACE}/openwrt/include/kernel.mk
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/kernel-5.10 ${GITHUB_WORKSPACE}/openwrt/include/kernel-5.10
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/kernel-version.mk ${GITHUB_WORKSPACE}/openwrt/include/kernel-version.mk
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/toolchain-build.mk ${GITHUB_WORKSPACE}/openwrt/include/toolchain-build.mk
cp -f ${GITHUB_WORKSPACE}/openwrt_release/include/kernel-defaults.mk ${GITHUB_WORKSPACE}/openwrt/include/kernel-defaults.mk
cp -f ${GITHUB_WORKSPACE}/openwrt_release/package/base-files/image-config.in ${GITHUB_WORKSPACE}/openwrt/package/base-files/image-config.in
cp -f ${GITHUB_WORKSPACE}/openwrt_release/version ${GITHUB_WORKSPACE}/openwrt/version
cp -f ${GITHUB_WORKSPACE}/openwrt_release/version.date ${GITHUB_WORKSPACE}/openwrt/version.date
cp -rf ${GITHUB_WORKSPACE}/openwrt_release/target/linux/* ${GITHUB_WORKSPACE}/openwrt/target/linux/
cp -rf ${GITHUB_WORKSPACE}/openwrt_release/package/kernel/linux/* ${GITHUB_WORKSPACE}/openwrt/package/kernel/linux/
#Repo
git clone -b js --depth 1 --single-branch https://github.com/waynesg/OpenWrt-Software ${GITHUB_WORKSPACE}/me
git clone -b master --depth 1 https://github.com/immortalwrt/immortalwrt.git ${GITHUB_WORKSPACE}/immortalwrt
git clone -b openwrt-21.02 --depth 1 https://github.com/immortalwrt/immortalwrt.git ${GITHUB_WORKSPACE}/immortalwrt_21
git clone -b openwrt-21.02 --depth 1 https://github.com/immortalwrt/packages.git ${GITHUB_WORKSPACE}/immortalwrt_pkg
git clone -b openwrt-21.02 --depth 1 https://github.com/immortalwrt/luci.git ${GITHUB_WORKSPACE}/immortalwrt_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/lede.git ${GITHUB_WORKSPACE}/lede
git clone -b master --depth 1 https://github.com/coolsnowwolf/luci.git ${GITHUB_WORKSPACE}/lede_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/packages.git ${GITHUB_WORKSPACE}/lede_pkg
git clone -b master --depth 1 https://github.com/openwrt/openwrt.git ${GITHUB_WORKSPACE}/openwrt_ma
git clone -b master --depth 1 https://github.com/openwrt/packages.git ${GITHUB_WORKSPACE}/openwrt_pkg_ma
git clone -b master --depth 1 https://github.com/openwrt/luci.git ${GITHUB_WORKSPACE}/openwrt_luci_ma
git clone -b master --depth 1 https://github.com/Lienol/openwrt.git ${GITHUB_WORKSPACE}/Lienol

# create directory
[[ ! -d package/waynesg ]] && mkdir -p package/waynesg

# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk

#download.pl
rm -rf scripts/download.pl
rm -rf include/download.mk
cp -rf ${GITHUB_WORKSPACE}/immortalwrt/scripts/download.pl scripts/download.pl
cp -rf ${GITHUB_WORKSPACE}/immortalwrt/include/download.mk include/download.mk
sed -i '/unshift/d' scripts/download.pl
sed -i '/mirror02/d' scripts/download.pl
echo "net.netfilter.nf_conntrack_helper = 1" >>./package/kernel/linux/files/sysctl-nf-conntrack.conf

### 必要的 Patches ######################################################################
# introduce "MG-LRU" Linux kernel patches
cp -rf ${BUILD_PATH}/PATCH/backport/MG-LRU/* target/linux/generic/pending-5.10/
# TCP optimizations
cp -rf ${BUILD_PATH}/PATCH/backport/TCP/* target/linux/generic/backport-5.10/
wget -P target/linux/generic/pending-5.10/ https://github.com/openwrt/openwrt/raw/v22.03.3/target/linux/generic/pending-5.10/613-netfilter_optional_tcp_window_check.patch
# Patch arm64 型号名称
cp -rf ${GITHUB_WORKSPACE}/immortalwrt/target/linux/generic/hack-5.10/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch target/linux/generic/hack-5.10/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# BBRv2
cp -rf ${BUILD_PATH}/PATCH/BBRv2/kernel/* target/linux/generic/hack-5.10/
cp -rf ${BUILD_PATH}/PATCH/BBRv2/openwrt/package ./
wget -qO - https://github.com/openwrt/openwrt/commit/7db9763.patch | patch -p1
# LRNG
cp -rf ${BUILD_PATH}/PATCH/LRNG/* target/linux/generic/hack-5.10/
# SSL
rm -rf ${GITHUB_WORKSPACE}/package/libs/mbedtls
cp -rf ${GITHUB_WORKSPACE}/immortalwrt/package/libs/mbedtls package/libs/mbedtls
rm -rf ${GITHUB_WORKSPACE}/package/libs/openssl
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_21/package/libs/openssl package/libs/openssl
# fstool
wget -qO - https://github.com/coolsnowwolf/lede/commit/8a4db76.patch | patch -p1

### Fullcone-NAT 部分 #####################################################################
# Patch Kernel 以解决 FullCone 冲突
cp -rf ${GITHUB_WORKSPACE}/lede/target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch
cp -rf ${GITHUB_WORKSPACE}/lede/target/linux/generic/hack-5.10/982-add-bcm-fullconenat-support.patch target/linux/generic/hack-5.10/982-add-bcm-fullconenat-support.patch
# Patch FireWall 以增添 FullCone 功能
# FW3
mkdir -p package/network/config/firewall/patches
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_21/package/network/config/firewall/patches/100-fullconenat.patch package/network/config/firewall/patches/100-fullconenat.patch
cp -rf ${GITHUB_WORKSPACE}/lede/package/network/config/firewall/patches/101-bcm-fullconenat.patch package/network/config/firewall/patches/101-bcm-fullconenat.patch
# iptables
cp -rf ${GITHUB_WORKSPACE}/lede/package/network/utils/iptables/patches/900-bcm-fullconenat.patch package/network/utils/iptables/patches/900-bcm-fullconenat.patch
# network
wget -qO - https://github.com/openwrt/openwrt/commit/bbf39d07.patch | patch -p1
# Patch LuCI 以增添 FullCone 开关
pushd feeds/luci
wget -qO- https://github.com/openwrt/luci/commit/471182b2.patch | patch -p1
popd
# FullCone PKG
git clone --depth 1 https://github.com/fullcone-nat-nftables/nft-fullcone package/waynesg/nft-fullcone
cp -rf ${GITHUB_WORKSPACE}/Lienol/package/network/utils/fullconenat package/waynesg/fullconenat

### 获取额外的基础软件包 ######################################################################
# Dnsmasq
rm -rf ${GITHUB_WORKSPACE}/package/network/services/dnsmasq
cp -rf ${GITHUB_WORKSPACE}/openwrt_ma/package/network/services/dnsmasq package/network/services/dnsmasq
cp -rf ${GITHUB_WORKSPACE}/openwrt_luci_ma/modules/luci-mod-network/htdocs/luci-static/resources/view/network/dhcp.js feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/


### 获取额外的 LuCI 应用、主题和依赖 ################################################################
# mount cgroupv2
pushd feeds/packages
wget -qO - https://github.com/openwrt/packages/commit/7a64a5f4.patch | patch -p1
popd
# i915
wget -qO - https://github.com/openwrt/openwrt/commit/c21a3570.patch | patch -p1
cp -rf ${GITHUB_WORKSPACE}/lede/target/linux/x86/64/config-5.10 target/linux/x86/64/config-5.10
# Haproxy
rm -rf ${GITHUB_WORKSPACE}/feeds/packages/net/haproxy
cp -rf ${GITHUB_WORKSPACE}/openwrt_pkg_ma/net/haproxy feeds/packages/net/haproxy
pushd feeds/packages
wget -qO - https://github.com/openwrt/packages/commit/a09cbcd.patch | patch -p1
popd
# AutoCore
cp -rf ${GITHUB_WORKSPACE}/me/openwrt-diy/autocore package/waynesg/autocore
sed -i 's/"getTempInfo" /"getTempInfo", "getCPUBench", "getCPUUsage" /g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json
sed -i '/"$threads"/d' package/waynesg/autocore/files/x86/autocore
rm -rf ${GITHUB_WORKSPACE}/feeds/packages/utils/coremark
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_pkg/utils/coremark feeds/packages/utils/coremark
# grant getCPUUsage access
sed -i 's|"getTempInfo"|"getTempInfo", "getCPUBench", "getCPUUsage"|g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json
# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/waynesg/r8168
patch -p1 <${BUILD_PATH}/PATCH/r8168/r8168-fix_LAN_led-for_r4s-from_TL.patch
# R8152驱动
cp -rf ${GITHUB_WORKSPACE}/immortalwrt/package/kernel/r8152 package/waynesg/r8152
# r8125驱动
git clone https://github.com/sbwml/package_kernel_r8125 package/waynesg/r8125
# igc-backport
cp -rf ${BUILD_PATH}/PATCH/igc-files-5.10 target/linux/x86/files-5.10
# UPX 可执行软件压缩
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile
cp -rf ${GITHUB_WORKSPACE}/Lienol/tools/ucl tools/ucl
cp -rf ${GITHUB_WORKSPACE}/Lienol/tools/upx tools/upx

#########################################################################################################
#########################################################################################################
rm -rf feeds/luci/applications/{luci-app-apinger,luci-app-smartdns}
#rm -rf feeds/luci/libs/luci-lib-ipkg
rm -rf feeds/packages/net/{socat,v2ray*,kcptun,trojan-go}

# Access Control
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-accesscontrol package/waynesg/luci-app-accesscontrol

#advanced
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-advanced package/waynesg/luci-app-advanced

# Argon 主题
cp -rf ${GITHUB_WORKSPACE}/me/luci-theme-argon package/waynesg/luci-theme-argon
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-argon-config package/waynesg/luci-app-argon-config

# arpbind--MAC 地址与 IP 绑定
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-arpbind feeds/luci/applications/luci-app-arpbind

# autoreboot-定时重启
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-autoreboot feeds/luci/applications/luci-app-autoreboot

# Airconnect
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-airconnect package/waynesg/luci-app-airconnect

#Alist
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-alist package/waynesg/luci-app-alist

#autotimeset
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-autotimeset package/waynesg/luci-app-autotimeset

#Bypass
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-bypass package/waynesg/luci-app-bypass
rm -rf package/waynesg/luci-app-bypass/luci-lib-ipkg

# cpufreq
# CPU 控制相关
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-cpufreq package/waynesg/luci-app-cpufreq
sed -i 's,1608,1800,g' package/waynesg/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
sed -i 's,2016,2208,g' package/waynesg/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
sed -i 's,1512,1608,g' package/waynesg/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-cpulimit feeds/luci/applications/luci-app-cpulimit

#Cloudflarespeedtest
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-cloudflarespeedtest package/waynesg/luci-app-cloudflarespeedtest

#control-Parentcontrol
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-parentcontrol package/waynesg/luci-app-parentcontrol

#control-speedlimit
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-control-speedlimit package/waynesg/luci-app-control-speedlimit

#control-timewol
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-control-timewol package/waynesg/luci-app-control-timewol

#control-webrestriction
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-control-webrestriction package/waynesg/luci-app-control-webrestriction

# DDNS
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_pkg/net/ddns-scripts_{aliyun,dnspod} package/waynesg/

# DiskMan
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-diskman package/waynesg/luci-app-diskman

#fileassistant
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-fileassistant package/waynesg/luci-app-fileassistant

#internet-detector
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-internet-detector package/waynesg/luci-app-internet-detector

# IPSec
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-ipsec-vpnd package/waynesg/luci-app-ipsec-vpnd

# Mosdns
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-mosdns package/waynesg/luci-app-mosdns

#msd_lite
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-msd_lite package/waynesg/luci-app-msd_lite

# netdata
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-netdata package/waynesg/luci-app-netdata

#luci-app-netspeedtest
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-netspeedtest package/waynesg/luci-app-netspeedtest

# oaf
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-oaf package/waynesg/luci-app-oaf

#onliner
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-onliner package/waynesg/luci-app-onliner

#openvpn-server
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-openvpn-server package/waynesg/luci-app-openvpn-server

#passwall
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-passwall package/waynesg/luci-app-passwall
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-passwall2 package/waynesg/luci-app-passwall2
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-dependence package/waynesg/luci-app-dependence
rm -rf package/waynesg/luci-app-dependence/xray-core

#Pushbot
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-pushbot package/waynesg/luci-app-pushbot


#ssr-plus
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-ssr-plus package/waynesg/luci-app-ssr-plus

#smartdns
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-smartdns package/waynesg/luci-app-smartdns

#socat
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-socat package/waynesg/luci-app-socat
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_pkg/net/socat package/waynesg/socat

#tn-netports
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-tn-netports package/waynesg/luci-app-tn-netports

#turboacc
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-turboacc package/waynesg/luci-app-turboacc

# UnblockNeteaseMusic
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-unblockneteasemusic package/waynesg/luci-app-unblockneteasemusic

# USB Printer
cp -rf ${GITHUB_WORKSPACE}/immortalwrt_luci/applications/luci-app-usb-printer package/waynesg/luci-app-usb-printer



# upnp--Boost 通用即插即用
rm -rf ${GITHUB_WORKSPACE}/feeds/packages/net/miniupnpd
cp -rf ${GITHUB_WORKSPACE}/openwrt_pkg_ma/net/miniupnpd feeds/packages/net/miniupnpd
pushd feeds/packages
wget -qO- https://github.com/openwrt/packages/commit/785bbcb.patch | patch -p1
wget -qO- https://github.com/openwrt/packages/commit/d811cb4.patch | patch -p1
wget -qO- https://github.com/openwrt/packages/commit/9a2da85.patch | patch -p1
wget -qO- https://github.com/openwrt/packages/commit/71dc090.patch | patch -p1
popd
wget -P feeds/packages/net/miniupnpd/patches/ https://github.com/ptpt52/openwrt-packages/raw/master/net/miniupnpd/patches/201-change-default-chain-rule-to-accept.patch
wget -P feeds/packages/net/miniupnpd/patches/ https://github.com/ptpt52/openwrt-packages/raw/master/net/miniupnpd/patches/500-0004-miniupnpd-format-xml-to-make-some-app-happy.patch
wget -P feeds/packages/net/miniupnpd/patches/ https://github.com/ptpt52/openwrt-packages/raw/master/net/miniupnpd/patches/500-0005-miniupnpd-stun-ignore-external-port-changed.patch
wget -P feeds/packages/net/miniupnpd/patches/ https://github.com/ptpt52/openwrt-packages/raw/master/net/miniupnpd/patches/500-0006-miniupnpd-fix-stun-POSTROUTING-filter-for-openwrt.patch
rm -rf ${GITHUB_WORKSPACE}/feeds/luci/applications/luci-app-upnp
cp -rf ${GITHUB_WORKSPACE}/openwrt_luci_ma/applications/luci-app-upnp feeds/luci/applications/luci-app-upnp
pushd feeds/luci
wget -qO- https://github.com/openwrt/luci/commit/0b5fb915.patch | patch -p1
popd

#vsftpd
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-vsftpd package/waynesg/luci-app-vsftpd

#vssr
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-vssr package/waynesg/luci-app-vssr

#wizard
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-wizard package/waynesg/luci-app-wizard

#wrtbwmon
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-wrtbwmon package/waynesg/luci-app-wrtbwmon

#zerotier
cp -rf ${GITHUB_WORKSPACE}/me/luci-app-zerotier package/waynesg/luci-app-zerotier

# fix include luci.mk
find package/waynesg/ -type f -name Makefile -exec sed -i 's,././luci.mk,$(TOPDIR)/feeds/luci/luci.mk,g' {} +
find package/waynesg/ -type f -name Makefile -exec sed -i 's,../../luci.mk,$(TOPDIR)/feeds/luci/luci.mk,g' {} +

