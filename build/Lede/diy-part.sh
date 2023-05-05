#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好

# 后台IP设置
export Ipv4_ipaddr="192.168.1.1"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="OpenWrt"                    # 修改主机名称为OpenWrt(填0为不作修改)

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
#export Gateway_Settings="192.168.1.1"       # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
#export DNS_Settings="0"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
#export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
#export Disable_DHCP="0"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
#export Disable_Bridge="0"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
#export Create_Ipv6_Lan="1"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6
#export Enable_IPV6_function="1"              # 编译IPV6固件(1为启用命令,填0为不作修改)
#export Disable_IPv6_option="0"               # 关闭固件里面所有IPv6选项和IPv6的DNS解析记录(1为启用命令,填0为不作修改)

# OpenClash
#export OpenClash_branch="master"             # OpenClash代码选择分支（master 或 dev）(填0为不需要此插件)
#export OpenClash_Core="0"                    # 编译固件增加OpenClash时,把核心下载好,核心为3MB左右大小(1为启用命令,填0为不需要核心)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
# export Customized_Information="@waynesg $(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
# export Replace_Kernel="6.1"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件时把核心一起下载好
# export AdGuardHome_Core="0"                  # 编译固件增加AdGuardHome时,把核心下载好,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不需要核心)

# 其他
export Ttyd_account_free_login="1"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
#export Delete_unnecessary_items="1"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
#export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带次功能)(1为启用命令,填0为不作修改)
#export Cancel_running="1"                    # 取消路由器每天跑分任务(个别源码本身不带次功能)(1为启用命令,填0为不作修改)


TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}
echo
TIME r "删除无用主题"
rm -rf ./feeds/freifunk/themes
TIME r "删除重复插件"
rm -rf ./feeds/packages/net/adguardhome
rm -rf ./feeds/packages/net/go-aliyundrive-webdav
rm -rf ./feeds/packages/net/pdnsd-alt
rm -rf ./feeds/packages/net/v2ray-geodata


echo
TIME b "修改 系统文件..."
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/zzz-default-settings > ./package/lean/default-settings/files/zzz-default-settings
curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/index.htm > ./package/lean/autocore/files/x86/index.htm
curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/ethinfo > ./package/lean/autocore/files/x86/sbin/ethinfo
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/autocore > ./package/lean/autocore/files/x86/autocore
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/tempinfo > ./package/lean/autocore/files/x86/sbin/tempinfo
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/cntime > ./package/lean/autocore/files/x86/sbin/cntime
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/cpuinfo > ./package/lean/autocore/files/x86/sbin/cpuinfo
# curl -fsSL https://raw.githubusercontent.com/immortalwrt/packages/master/net/dnsproxy/Makefile > feeds/packages/net/dnsproxy/Makefile
# rm -rf ./package/lean/autocore/files/x86/sbin/getcpu
TIME b "系统文件 修改完成"

#echo 
#TIME y "更换内核为5.4"
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' ./target/linux/x86/Makefile

echo 
TIME y "更新固件 编译日期"
sed -i "s/2022.02.01/$(TZ=UTC-8 date "+%Y.%m.%d")/g" package/lean/autocore/files/x86/index.htm

echo 
TIME y "自定义固件版本名字"
sed -i "s/OpenWrt /AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

echo
TIME y "更换golang版本"
rm -rf feeds/packages/lang/golang
svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang

echo 
TIME y "调整网络诊断地址到www.baidu.com"
sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
cat <<EOF >>package/lean/default-settings/files/zzz-default-settings
uci set luci.diag.ping=www.baidu.com
uci set luci.diag.route=www.baidu.com
uci set luci.diag.dns=www.baidu.com
uci commit luci
exit 0
EOF

echo 
TIME y ”关闭开机串口跑码“
sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

#echo
#TIME y "添加upx"
#sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host"/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host upx\/host"/g' package/waynesg/netspeedtest/homebox/Makefile
#sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host"/"PKG_BUILD_DEPENDS:=golang\/host upx\/host"/g' package/waynesg/luci-app-mosdns/mosdns/Makefile

echo
TIME b "菜单 调整..."
sed -i 's/\"services\"/\"control\"/g' feeds/luci/applications/luci-app-wol/luasrc/controller/wol.lua
#sed -i 's/\"services\"/\"control\"/g' package/waynesg/luci-app-accesscontrol-plus/luasrc/controller/miaplus.lua
sed -i 's/\"network\"/\"control\"/g'  package/waynesg/luci-app-oaf/luci-app-oaf/luasrc/controller/appfilter.lua
echo             
TIME b "插件 重命名..."
echo "重命名系统菜单"
#system menu
sed -i 's/"Web 管理"/"Web管理"/g' `grep "Web 管理" -rl ./`
sed -i 's/"备份\/升级"/"备份升级"/g' `grep "备份\/升级" -rl ./`
sed -i 's/"管理权"/"权限管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"重启"/"立即重启"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
#sed -i 's/"系统"/"系统设置"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"挂载点"/"挂载路径"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"启动项"/"启动管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"软件包"/"软件管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"TTYD 终端"/"命令终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh-cn/terminal.po
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
#sed -i 's/"Design 主题设置"/"Design设置"/g' package/waynesg/luci-app-design-config/po/zh-cn/design-config.po
echo "重命名控制菜单"
#others
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' feeds/luci/applications/luci-app-turboacc/po/zh-cn/turboacc.po
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"在线用户"/"在线设备"/g' package/waynesg/luci-app-onliner/luasrc/controller/onliner.lua
#sed -i 's/"上网时间控制Plus"/"上网时间"/g' package/waynesg/luci-app-accesscontrol-plus/po/zh-cn/miaplus.po
#sed -i 's/"autoipsetadder"/"自动设置IP"/g' `grep "autoipsetadder" -rl ./`
echo "重命名服务菜单"
#services menu
#sed -i 's/WireGuard 状态/WG状态/g' feeds/luci/applications/luci-app-wireguard/po/zh-cn/wireguard.po
sed -i 's/"PassWall 2"/"PassWall+"/g' package/waynesg/luci-app-passwall2/luasrc/controller/passwall2.lua
sed -i 's/"MultiSD_Lite"/"组播路由"/g'  package/waynesg/luci-app-msd_lite/luasrc/controller/msd_lite.lua
#sed -i 's/"解锁网易云灰色歌曲"/"网易音乐"/g' feeds/luci/applications/luci-app-unblockmusic/po/zh-cn/unblockmusic.po
sed -i 's/"解除网易云音乐播放限制"/"网易音乐"/g' package/waynesg/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
#sed -i 's/天翼家庭云\/云盘提速/天翼云盘/g' feeds/luci/applications/luci-app-familycloud/luasrc/controller/familycloud.lua
#sed -i 's/"AdGuard Home"/"AdHome"/g' `grep "AdGuard Home" -rl ./`
#sed -i 's/"Frp 内网穿透"/"Frp客户端"/g' `grep "Frp 内网穿透" -rl ./`
sed -i 's/ShadowSocksR Plus+/SSRPlus+/g' package/waynesg/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/msgstr "UPnP"/msgstr "UPnP服务"/g' feeds/luci/applications/luci-app-upnp/po/zh-cn/upnp.po
sed -i 's/Hello World/VssrVPN/g'  package/waynesg/luci-app-vssr/luasrc/controller/vssr.lua
sed -i 's/"Cloudflare速度测试"/"Cloudflare"/g' package/waynesg/luci-app-cloudflarespeedtest/po/zh-cn/cloudflarespeedtest.po
#sed -i 's/"TelegramBot"/"Telegram"/g'  package/waynesg/luci-app-telegrambot/luasrc/controller/telegrambot.lua
#sed -i 's/"DDNS.to内网穿透"/"DDNSTO"/g' `grep "DDNS.to内网穿透" -rl ./`
#sed -i 's/"网页快捷菜单"/"快捷菜单"/g'  package/waynesg/luci-app-shortcutmenu/po/zh-cn/shortcutmenu.po
#sed -i 's/Adblock Plus+/Adb Plus+/g'  package/waynesg/luci-app-adblock-plus/luasrc/controller/adblock.lua
#sed -i 's/CPU占用率限制/CPU调节/g' package/waynesg/luci-app-cpulimit/po/zh_Hans/cpulimit.po
#sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
#sed -i 's/"WebGuide"/"网页导航"/g' package/waynesg/luci-app-webguide/luasrc/controller/webguide.lua
#sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' package/waynesg/luci-app-ikoolproxy/luasrc/controller/koolproxy.lua
#sed -i 's/"Nezha Agent"/"哪吒面板"/g'  package/waynesg/luci-app-nezha/luasrc/controller/nezha-agent.lua
#sed -i 's/"WebGuide"/"网页导航"/g'  package/waynesg/luci-app-webguide/luasrc/controller/webguide.lua
#sed -i 's/"Webd 网盘"/"WebDisk"/g'  package/waynesg/luci-app-webd/po/zh-cn/webd.po
#sed -i 's/"Go 阿里云盘 WebDAV"/"阿里云盘"/g' `grep "Go 阿里云盘 WebDAV" -rl ./`
#sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
#sed -i 's/京东签到服务/京东签到/g' feeds/luci/applications/luci-app-jd-dailybonus/luasrc/controller/jd-dailybonus.lua
#sed -i 's/"UU游戏加速器"/"UU加速器"/g' `grep "UU游戏加速器" -rl ./`
#sed -i 's/UU游戏加速器/UU加速器/g' feeds/luci/applications/luci-app-uugamebooster/po/zh-cn/uuplugin.po
#sed -i 's/"Rclone"/"Rclone挂载"/g' feeds/luci/applications/luci-app-rclone/luasrc/controller/rclone.lua
echo "重命名网络菜单"
#network
sed -i 's/"IP\/MAC 绑定"/"地址绑定"/g' feeds/luci/applications/luci-app-arpbind/po/zh-cn/arpbind.po
#sed -i 's/"netports_info"/"网口信息"/g' `grep "netports_info" -rl ./`
sed -i 's/"主机名"/"主机名称"/g' `grep "主机名" -rl ./`
sed -i 's/"接口"/"网络接口"/g' `grep "接口" -rl ./`
sed -i 's/"Socat"/"IPv6转发"/g'  feeds/luci/applications/luci-app-socat/luasrc/controller/socat.lua
echo "重命名存储菜单"
#nas
# sed -i 's/"文件浏览器"/"文件管理"/g' package/waynesg/luci-app-filebrowser/po/zh-cn/filebrowser.po
sed -i 's/"FTP 服务器"/"FTP 服务"/g' feeds/luci/applications/luci-app-vsftpd/po/zh-cn/vsftpd.po
sed -i 's/"Alist 文件列表"/"Alist列表"/g' package/waynesg/luci-app-alist/luci-app-alist/po/zh-cn/alist.po
#vpn
sed -i 's/"ZeroTier"/"ZeroTier虚拟网络"/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
TIME b "重命名 完成"
echo
TIME b "自定义文件修复权限"
chmod -R 755 package/waynesg
echo
TIME g "配置更新完成"


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
sha256sums
version.buildinfo
EOF

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
