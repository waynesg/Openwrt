git clone -b master --depth 1 https://github.com/sbwml/luci-app-alist.git package/waynesg/luci-app-alist
svn co https://github.com/sirpdboy/luci-app-autotimeset/trunk package/waynesg/luci-app-autotimeset
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/waynesg/luci-app-bypass
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cloudflarespeedtest package/waynesg/luci-app-cloudflarespeedtest
svn co https://github.com/immortalwrt-collections/openwrt-cdnspeedtest/trunk/cdnspeedtest package/waynesg/luci-app-cloudflarespeedtest/cdnspeedtest
svn co https://github.com/sirpdboy/luci-app-parentcontrol/trunk package/waynesg/luci-app-parentcontrol
rm -rf package/waynesg/luci-app-parentcontrol/po/zh_Hans
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-speedlimit package/waynesg/luci-app-control-speedlimit
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-timewol package/waynesg/luci-app-control-timewol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-webrestriction package/waynesg/luci-app-control-webrestriction
svn co https://github.com/sbwml/luci-app-mosdns/trunk package/waynesg/luci-app-mosdns
svn co https://github.com/waynesg/luci-app-tn-netports/trunk package/waynesg/luci-app-tn-netports
svn co https://github.com/sirpdboy/netspeedtest/trunk package/waynesg/luci-app-netspeedtest
rm -rf package/waynesg/luci-app-netspeedtest/luci-app-netspeedtest/po/zh_Hans
svn co https://github.com/destan19/OpenAppFilter/trunk package/waynesg/luci-app-oaf
svn co https://github.com/Hyy2001X/AutoBuild-Packages/trunk/luci-app-onliner package/waynesg/luci-app-onliner
svn co https://github.com/zzsj0928/luci-app-pushbot/trunk package/waynesg/luci-app-pushbot
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/luci-app-airconnect package/waynesg/luci-app-airconnect
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/airconnect package/waynesg/luci-app-airconnect/airconnect
svn co https://github.com/kiddin9/luci-app-wizard/trunk package/waynesg/luci-app-wizard
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-advanced package/waynesg/luci-app-advanced
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/waynesg/luci-app-wrtbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/waynesg/luci-app-wrtbwmon/wrtbwmon
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-socat package/waynesg/luci-app-socat
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall -b luci-smartdns-new-version package/waynesg/openwrt-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 package/waynesg/openwrt-passwall2
git clone -b master --depth 1 https://github.com/waynesg/luci-app-internet-detector package/waynesg/luci-app-internet-detector
git clone -b master --depth 1 https://github.com/waynesg/luci-app-cpu-status-mini package/waynesg/luci-app-cpu-status-mini
git clone -b master --depth 1 https://github.com/waynesg/luci-app-disks-info package/waynesg/luci-app-disks-info
