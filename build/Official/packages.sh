#!/bin/bash
#Kernel
latest_release="$(curl -s https://github.com/openwrt/openwrt/tags | grep -Eo "v[0-9\.]+\-*r*c*[0-9]*.tar.gz" | sed -n '/[2-9][0-9]/p' | sed -n 1p | sed 's/.tar.gz//g')"
git clone --single-branch -b ${latest_release} https://github.com/openwrt/openwrt ${GITHUB_WORKSPACE}/openwrt_release
rm -f ./openwrt/include/version.mk
rm -f ./openwrt/include/kernel.mk
rm -f ./openwrt/include/kernel-5.10
rm -f ./openwrt/include/kernel-version.mk
rm -f ./openwrt/include/toolchain-build.mk
rm -f ./openwrt/include/kernel-defaults.mk
rm -f ./openwrt/package/base-files/image-config.in
rm -rf ./openwrt/target/linux/*
rm -rf ./openwrt/package/kernel/linux/*
cp -f ../openwrt_release/include/version.mk ./openwrt/include/version.mk
cp -f ../openwrt_release/include/kernel.mk ./openwrt/include/kernel.mk
cp -f ..openwrt_release/include/kernel-5.10 ./openwrt/include/kernel-5.10
cp -f ../openwrt_release/include/kernel-version.mk ./openwrt/include/kernel-version.mk
cp -f ../openwrt_release/include/toolchain-build.mk ./openwrt/include/toolchain-build.mk
cp -f ../openwrt_release/include/kernel-defaults.mk ./openwrt/include/kernel-defaults.mk
cp -f ../openwrt_release/package/base-files/image-config.in ./openwrt/package/base-files/image-config.in
cp -f ../openwrt_release/version ./openwrt/version
cp -f ../openwrt_release/version.date ./openwrt/version.date
cp -rf ../openwrt_release/target/linux/* ./openwrt/target/linux/
cp -rf ../openwrt_release/package/kernel/linux/* ./openwrt/package/kernel/linux/

#Repo
git clone -b js --depth 1 --single-branch https://github.com/waynesg/OpenWrt-Software ${GITHUB_WORKSPACE}/me
git clone -b master --depth 1 https://github.com/immortalwrt/immortalwrt.git ${GITHUB_WORKSPACE}/immortalwrt
git clone -b openwrt-21.02 --depth 1 https://github.com/immortalwrt/immortalwrt.git ${GITHUB_WORKSPACE}/immortalwrt_21
git clone -b master --depth 1 https://github.com/immortalwrt/packages.git ${GITHUB_WORKSPACE}/immortalwrt_pkg
git clone -b master --depth 1 https://github.com/immortalwrt/luci.git ${GITHUB_WORKSPACE}/immortalwrt_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/lede.git ${GITHUB_WORKSPACE}/lede
git clone -b master --depth 1 https://github.com/coolsnowwolf/luci.git ${GITHUB_WORKSPACE}/lede_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/packages.git ${GITHUB_WORKSPACE}/lede_pkg
git clone -b master --depth 1 https://github.com/openwrt/openwrt.git ${GITHUB_WORKSPACE}/openwrt_ma
git clone -b master --depth 1 https://github.com/openwrt/packages.git ${GITHUB_WORKSPACE}/openwrt_pkg_ma
git clone -b master --depth 1 https://github.com/openwrt/luci.git ${GITHUB_WORKSPACE}/openwrt_luci_ma
git clone -b master --depth 1 https://github.com/Lienol/openwrt.git ${GITHUB_WORKSPACE}/Lienol
git clone -b main --depth 1 https://github.com/Lienol/openwrt-package ${GITHUB_WORKSPACE}/Lienol_pkg

# create directory
[[ ! -d package/waynesg ]] && mkdir -p package/waynesg

# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk

#download.pl
rm -rf ./scripts/download.pl
rm -rf ./include/download.mk
cp -rf ../immortalwrt/scripts/download.pl ./scripts/download.pl
cp -rf ../immortalwrt/include/download.mk ./include/download.mk
sed -i '/unshift/d' scripts/download.pl
sed -i '/mirror02/d' scripts/download.pl
echo "net.netfilter.nf_conntrack_helper = 1" >>./package/kernel/linux/files/sysctl-nf-conntrack.conf

### 必要的 Patches ######################################################################
# introduce "MG-LRU" Linux kernel patches
cp -rf ${BUILD_PATH}/PATCH/backport/MG-LRU/* ./target/linux/generic/pending-5.10/
# TCP optimizations
cp -rf ${BUILD_PATH}/PATCH/backport/TCP/* ./target/linux/generic/backport-5.10/
wget -P target/linux/generic/pending-5.10/ https://github.com/openwrt/openwrt/raw/v22.03.3/target/linux/generic/pending-5.10/613-netfilter_optional_tcp_window_check.patch
# Patch arm64 型号名称
cp -rf ../immortalwrt/target/linux/generic/hack-5.10/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch ./target/linux/generic/hack-5.10/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# BBRv2
cp -rf ${BUILD_PATH}/PATCH/BBRv2/kernel/* ./target/linux/generic/hack-5.10/
cp -rf ${BUILD_PATH}/PATCH/BBRv2/openwrt/package ./
wget -qO - https://github.com/openwrt/openwrt/commit/7db9763.patch | patch -p1
# LRNG
cp -rf ${BUILD_PATH}/PATCH/LRNG/* ./target/linux/generic/hack-5.10/
# SSL
rm -rf ./package/libs/mbedtls
cp -rf ../immortalwrt/package/libs/mbedtls ./package/libs/mbedtls
rm -rf ./package/libs/openssl
cp -rf ../immortalwrt_21/package/libs/openssl ./package/libs/openssl
# fstool
wget -qO - https://github.com/coolsnowwolf/lede/commit/8a4db76.patch | patch -p1

### Fullcone-NAT 部分 #####################################################################
# Patch Kernel 以解决 FullCone 冲突
cp -rf ../lede/target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch ./target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch
cp -rf ../lede/target/linux/generic/hack-5.10/982-add-bcm-fullconenat-support.patch ./target/linux/generic/hack-5.10/982-add-bcm-fullconenat-support.patch
# Patch FireWall 以增添 FullCone 功能
# FW4
rm -rf ./package/network/config/firewall4
cp -rf ../immortalwrt/package/network/config/firewall4 ./package/network/config/firewall4
cp -f ../PATCH/firewall/990-unconditionally-allow-ct-status-dnat.patch ./package/network/config/firewall4/patches/990-unconditionally-allow-ct-status-dnat.patch
rm -rf ./package/libs/libnftnl
cp -rf ../immortalwrt/package/libs/libnftnl ./package/libs/libnftnl
rm -rf ./package/network/utils/nftables
cp -rf ../immortalwrt/package/network/utils/nftables ./package/network/utils/nftables
# FW3
mkdir -p package/network/config/firewall/patches
cp -rf ../immortalwrt_21/package/network/config/firewall/patches/100-fullconenat.patch ./package/network/config/firewall/patches/100-fullconenat.patch
cp -rf ../lede/package/network/config/firewall/patches/101-bcm-fullconenat.patch ./package/network/config/firewall/patches/101-bcm-fullconenat.patch
# iptables
cp -rf ../lede/package/network/utils/iptables/patches/900-bcm-fullconenat.patch ./package/network/utils/iptables/patches/900-bcm-fullconenat.patch
# network
wget -qO - https://github.com/openwrt/openwrt/commit/bbf39d07.patch | patch -p1
# Patch LuCI 以增添 FullCone 开关
pushd feeds/luci
wget -qO- https://github.com/openwrt/luci/commit/471182b2.patch | patch -p1
popd
# FullCone PKG
git clone --depth 1 https://github.com/fullcone-nat-nftables/nft-fullcone package/waynesg/nft-fullcone
cp -rf ../Lienol/package/network/utils/fullconenat ./package/waynesg/fullconenat

### 获取额外的基础软件包 ######################################################################
# 更换为 ImmortalWrt Uboot 以及 Target
rm -rf ./target/linux/rockchip
cp -rf ../lede/target/linux/rockchip ./target/linux/rockchip
rm -rf ./target/linux/rockchip/Makefile
cp -rf ../openwrt_release/target/linux/rockchip/Makefile ./target/linux/rockchip/Makefile
rm -rf ./target/linux/rockchip/armv8/config-5.10
cp -rf ../openwrt_release/target/linux/rockchip/armv8/config-5.10 ./target/linux/rockchip/armv8/config-5.10
rm -rf ./target/linux/rockchip/patches-5.10/002-net-usb-r8152-add-LED-configuration-from-OF.patch
rm -rf ./target/linux/rockchip/patches-5.10/003-dt-bindings-net-add-RTL8152-binding-documentation.patch
cp -rf ${BUILD_PATH}//PATCH/rockchip-5.10/* ./target/linux/rockchip/patches-5.10/
rm -rf ./package/firmware/linux-firmware/intel.mk
cp -rf ../lede/package/firmware/linux-firmware/intel.mk ./package/firmware/linux-firmware/intel.mk
rm -rf ./package/firmware/linux-firmware/Makefile
cp -rf ../lede/package/firmware/linux-firmware/Makefile ./package/firmware/linux-firmware/Makefile
mkdir -p target/linux/rockchip/files-5.10
cp -rf ../PATCH/files-5.10 ./target/linux/rockchip/
sed -i 's,+LINUX_6_1:kmod-drm-display-helper,,g' target/linux/rockchip/modules.mk
sed -i '/drm_dp_aux_bus\.ko/d' target/linux/rockchip/modules.mk
rm -rf ./package/boot/uboot-rockchip
cp -rf ../lede/package/boot/uboot-rockchip ./package/boot/uboot-rockchip
cp -rf ../lede/package/boot/arm-trusted-firmware-rockchip-vendor ./package/boot/arm-trusted-firmware-rockchip-vendor
rm -rf ./package/kernel/linux/modules/video.mk
cp -rf ../immortalwrt/package/kernel/linux/modules/video.mk ./package/kernel/linux/modules/video.mk
sed -i '/nouveau\.ko/d' package/kernel/linux/modules/video.mk
# Disable Mitigations
sed -i 's,rootwait,rootwait mitigations=off,g' target/linux/rockchip/image/mmc.bootscript
sed -i 's,rootwait,rootwait mitigations=off,g' target/linux/rockchip/image/nanopi-r2s.bootscript
sed -i 's,rootwait,rootwait mitigations=off,g' target/linux/rockchip/image/nanopi-r4s.bootscript
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-efi.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-iso.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-pc.cfg
# Dnsmasq
rm -rf ./package/network/services/dnsmasq
cp -rf ../openwrt_ma/package/network/services/dnsmasq ./package/network/services/dnsmasq
cp -rf ../openwrt_luci_ma/modules/luci-mod-network/htdocs/luci-static/resources/view/network/dhcp.js ./feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/

### 获取额外的 LuCI 应用、主题和依赖 ################################################################
rm -rf package/feeds/luci/luci-app-apinger
rm -rf ./feeds/packages/net/{xray-core,socat,v2ray*,shadowsocks-libev}

# dae ready
cp -rf ../immortalwrt/config/Config-kernel.in ./config/Config-kernel.in
rm -rf ./tools/dwarves
cp -rf ../openwrt_ma/tools/dwarves ./tools/dwarves
wget -qO - https://github.com/openwrt/openwrt/commit/aa95787e.patch | patch -p1
wget -qO - https://github.com/openwrt/openwrt/commit/29d7d6a8.patch | patch -p1
rm -rf ./tools/elfutils
cp -rf ../openwrt_ma/tools/elfutils ./tools/elfutils
rm -rf ./package/libs/elfutils
cp -rf ../openwrt_ma/package/libs/elfutils ./package/libs/elfutils
wget -qO - https://github.com/openwrt/openwrt/commit/b839f3d5.patch | patch -p1
rm -rf ./feeds/packages/net/frr
cp -rf ../openwrt_pkg_ma/net/frr feeds/packages/net/frr
cp -rf ../immortalwrt_pkg/net/dae ./feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
# mount cgroupv2
pushd feeds/packages
wget -qO - https://github.com/openwrt/packages/commit/7a64a5f4.patch | patch -p1
popd
# i915
wget -qO - https://github.com/openwrt/openwrt/commit/c21a3570.patch | patch -p1
cp -rf ../lede/target/linux/x86/64/config-5.10 ./target/linux/x86/64/config-5.10
# Haproxy
rm -rf ./feeds/packages/net/haproxy
cp -rf ../openwrt_pkg_ma/net/haproxy feeds/packages/net/haproxy
pushd feeds/packages
wget -qO - https://github.com/openwrt/packages/commit/a09cbcd.patch | patch -p1
popd

# AutoCore
cp -rf ../me/openwrt-diy/autocore ./package/waynesg/autocore
sed -i 's/"getTempInfo" /"getTempInfo", "getCPUBench", "getCPUUsage" /g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json
sed -i '/"$threads"/d' package/waynesg/autocore/files/x86/autocore
rm -rf ./feeds/packages/utils/coremark
cp -rf ../immortalwrt_pkg/utils/coremark ./feeds/packages/utils/coremark
# grant getCPUUsage access
sed -i 's|"getTempInfo"|"getTempInfo", "getCPUBench", "getCPUUsage"|g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/waynesg/r8168
patch -p1 <../PATCH/r8168/r8168-fix_LAN_led-for_r4s-from_TL.patch
# R8152驱动
cp -rf ../immortalwrt/package/kernel/r8152 ./package/waynesg/r8152
# r8125驱动
git clone https://github.com/sbwml/package_kernel_r8125 package/waynesg/r8125
# igc-backport
cp -rf ${BUILD_PATH}/PATCH/igc-files-5.10 ./target/linux/x86/files-5.10

# UPX 可执行软件压缩
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile
cp -rf ../Lienol/tools/ucl ./tools/ucl
cp -rf ../Lienol/tools/upx ./tools/upx

# MAC 地址与 IP 绑定
cp -rf ../immortalwrt_luci/applications/luci-app-arpbind ./feeds/luci/applications/luci-app-arpbind
ln -sf ../../../feeds/luci/applications/luci-app-arpbind ./package/feeds/luci/luci-app-arpbind

# 定时重启
cp -rf ../immortalwrt_luci/applications/luci-app-autoreboot ./feeds/luci/applications/luci-app-autoreboot
ln -sf ../../../feeds/luci/applications/luci-app-autoreboot ./package/feeds/luci/luci-app-autoreboot

# Boost 通用即插即用
rm -rf ./feeds/packages/net/miniupnpd
cp -rf ../openwrt_pkg_ma/net/miniupnpd ./feeds/packages/net/miniupnpd
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
rm -rf ./feeds/luci/applications/luci-app-upnp
cp -rf ../openwrt_luci_ma/applications/luci-app-upnp ./feeds/luci/applications/luci-app-upnp
pushd feeds/luci
wget -qO- https://github.com/openwrt/luci/commit/0b5fb915.patch | patch -p1
popd


##-------------------------------------------------------------------------------------------------------
# Argon 主题
cp -rf ../me/luci-theme-argon package/waynesg/luci-theme-argon
cp -rf ../me/luci-app-argon-config package/waynesg/luci-app-argon-config

# Airconnect
cp -rf ../me/luci-app-airconnect ./package/waynesg/luci-app-airconnect
cp -rf ../me/luci-app-airconnect/airconnect ./package/waynesg/luci-app-airconnect/airconnect

# cpufreq
# CPU 控制相关
cp -rf ../me/luci-app-cpufreq ./feeds/luci/applications/luci-app-cpufreq
ln -sf ../../../feeds/luci/applications/luci-app-cpufreq ./package/feeds/luci/luci-app-cpufreq
sed -i 's,1608,1800,g' feeds/luci/applications/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
sed -i 's,2016,2208,g' feeds/luci/applications/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
sed -i 's,1512,1608,g' feeds/luci/applications/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
cp -rf ../me/luci-app-cpulimit ./package/waynesg/luci-app-cpulimit
cp -rf ../immortalwrt_pkg/utils/cpulimit ./feeds/packages/utils/cpulimit
ln -sf ../../../feeds/packages/utils/cpulimit ./package/feeds/packages/cpulimit

# DDNS
cp -rf ../immortalwrt_pkg/net/ddns-scripts_{aliyun,dnspod} package/waynesg/

# DiskMan
cp -rf ../me/luci-app-diskman ./package/waynesg/luci-app-diskman
mkdir -p package/waynesg/parted && \
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O package/waynesg/parted/Makefile

# IPSec
cp -rf ../lede_luci/applications/luci-app-ipsec-server ./package/waynesg/luci-app-ipsec-server

# Mosdns
cp -rf ../me/luci-app-mosdns ./package/waynesg/luci-app-mosdns

# 上网 APP 过滤
cp -rf ../me/luci-app-oaf ./package/waynesg/luci-app-oaf

# Access Control
cp -rf ../immortalwrt-luci/applications/luci-app-accesscontrol package/waynesg/

# 流量监管
cp -rf ../lede_luci/applications/luci-app-netdata ./package/waynesg/luci-app-netdata

# arpbind
cp -rf ../immortalwrt-luci/applications/luci-app-arpbind package/waynesg/

# Filetransfer
cp -rf ../immortalwrt-luci/applications/luci-app-filetransfer package/waynesg/
cp -rf ../immortalwrt-luci/libs/luci-lib-fs package/waynesg/

# ShadowsocksR Plus+
svn export -q https://github.com/fw876/helloworld/trunk package/helloworld
svn export -q https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/helloworld/shadowsocks-libev

# USB Printer
cp -rf ./immortalwrt-luci/applications/luci-app-usb-printer package/waynesg/

# Zerotier
cp -rf ./immortalwrt-luci/applications/luci-app-zerotier package/waynesg/

# 网易云音乐解锁
git clone -b js --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/waynesg/UnblockNeteaseMusic


# fix include luci.mk
find package/waynesg/ -type f -name Makefile -exec sed -i 's,././luci.mk,$(TOPDIR)/feeds/luci/luci.mk,g' {} +

#Alist
cp -rf ../me/luci-app-alist package/waynesg/luci-app-alist

#autotimeset
svn co https://github.com/sirpdboy/luci-app-autotimeset/trunk package/waynesg/luci-app-autotimeset

#Bypass
cp -rf ../me/luci-app-bypass package/waynesg/luci-app-bypass

#Cloudflarespeedtest
cp -rf ../me/luci-app-cloudflarespeedtest package/waynesg/luci-app-cloudflarespeedtest

#Parentcontrol
cp -rf ../me/luci-app-parentcontrol package/waynesg/luci-app-parentcontrol

#speedlimit
cp -rf ../me/luci-app-control-speedlimit package/waynesg/luci-app-control-speedlimit

#timewol
cp -rf ../me/luci-app-control-timewol package/waynesg/luci-app-control-timewol

#webrestriction
cp -rf ../me/luci-app-control-webrestriction package/waynesg/luci-app-control-webrestriction

#tn-netports
cp -rf ../me/luci-app-tn-netports/trunk package/waynesg/luci-app-tn-netports

#luci-app-netspeedtest
cp -rf ../me/netspeedtest package/waynesg/luci-app-netspeedtest

#onliner
cp -rf ../me/luci-app-onliner package/waynesg/luci-app-onliner

#Pushbot
cp -rf ../me/luci-app-pushbot package/waynesg/luci-app-pushbot

#wizard
cp -rf ../me/luci-app-wizard/trunk package/waynesg/luci-app-wizard

#advanced
cp -rf ../me/luci-app-advanced package/waynesg/luci-app-advanced

#wrtbwmon
cp -rf ../me/luci-app-wrtbwmon package/waynesg/luci-app-wrtbwmon

#socat
cp -rf ../me/luci-app-socat package/waynesg
cp -rf ../immortalwrt-packages/net/socat package/waynesg/

#passwall
cp -rf ../me/luci-app-passwall package/waynesg/luci-app-passwall
cp -rf ../me/luci-app-passwall2 package/waynesg/luci-app-passwall2
cp -rf ../me/luci-app-dependence package/waynesg/luci-app-dependence

#ssr-plus
cp -rf ../me/luci-app-ssr-plus package/waynesg/luci-app-ssr-plus

#smartdns
cp -rf ../me/luci-app-smartdns package/waynesg/luci-app-smartdns

#internet-detector
cp -rf ../me/luci-app-internet-detector package/waynesg/luci-app-internet-detector

#zerotier
cp -rf ../me/luci-app-zerotier package/waynesg/luci-app-zerotier
