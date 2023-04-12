#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
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
TIME y "添加软件包"
#rm -rf package/waynesg && git clone -b js https://github.com/waynesg/OpenWrt-Software package/waynesg

rm -rf ./feeds/luci/applications/luci-app-passwall
rm -rf ./feeds/luci/themes/luci-theme-argon
git clone -b master --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/waynesg/luci-theme-argon
git clone -b master --depth 1 https://github.com/sbwml/luci-app-alist.git package/waynesg/luci-app-alist
git clone -b master --depth 1 https://github.com/sirpdboy/luci-app-autotimeset.git package/waynesg/luci-app-autotimeset
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/waynesg/luci-app-bypass
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cloudflarespeedtest package/waynesg/luci-app-cloudflarespeedtest
svn co https://github.com/immortalwrt-collections/openwrt-cdnspeedtest/trunk/cdnspeedtest package/waynesg/luci-app-cloudflarespeedtest/cdnspeedtest
svn co https://github.com/sirpdboy/luci-app-parentcontrol/trunk package/waynesg/luci-app-parentcontrol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-speedlimit package/waynesg/luci-app-control-speedlimit
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-timewol package/waynesg/luci-app-control-timewol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-webrestriction package/waynesg/luci-app-control-webrestriction
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns.git package/waynesg/luci-app-mosdns
git clone -b main --depth 1 https://github.com/waynesg/luci-app-tn-netports.git package/waynesg/luci-app-tn-netports
git clone -b master --depth 1 https://github.com/waynesg/luci-app-internet-detector.git package/waynesg/luci-app-internet-detector
git clone -b master --depth 1 https://github.com/sirpdboy/netspeedtest.git package/waynesg/luci-app-netspeedtest
git clone -b master --depth 1 https://github.com/destan19/OpenAppFilter.git package/waynesg/luci-app-oaf
svn co https://github.com/waynesg/OpenWrt-Software/trunk/luci-app-onliner package/waynesg/luci-app-onliner
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall -b luci-smartdns-new-version package/waynesg/openwrt-passwall && mvdir openwrt-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 package/waynesg/openwrt-passwall2 && mvdir openwrt-passwall2
svn co https://github.com/zzsj0928/luci-app-pushbot/trunk package/waynesg/luci-app-pushbot
svn co https://github.com/iamaluckyguy/luci-app-smartinfo/trunk package/waynesg/luci-app-smartinfo


# 后台IP设置
export Ipv4_ipaddr="192.168.2.1"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="OpenWrt"                # 修改主机名称为OpenWrt-123(填0为不作修改)

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="0"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="0"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="0"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="0"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6
export Enable_IPV6_function="0"              # 编译IPV6固件(1为启用命令,填0为不作修改)
export Disable_IPv6_option="0"               # 关闭固件里面所有IPv6选项和IPv6的DNS解析记录(1为启用命令,填0为不作修改)

# OpenClash
export OpenClash_branch="master"             # OpenClash代码选择分支（master 或 dev）(填0为不需要此插件)
export OpenClash_Core="1"                    # 编译固件增加OpenClash时,把核心下载好,核心为3MB左右大小(1为启用命令,填0为不需要核心)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="大灰狼 $(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="0"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件时把核心一起下载好
export AdGuardHome_Core="0"                  # 编译固件增加AdGuardHome时,把核心下载好,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不需要核心)

# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="0"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带次功能)(1为启用命令,填0为不作修改)
export Cancel_running="0"                    # 取消路由器每天跑分任务(个别源码本身不带次功能)(1为启用命令,填0为不作修改)



# 修改插件名字
sed -i 's/"aMule设置"/"电驴下载"/g' `egrep "aMule设置" -rl ./`
sed -i 's/"网络存储"/"NAS"/g' `egrep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `egrep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `egrep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `egrep "KMS 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"命令窗"/g' `egrep "TTYD 终端" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `egrep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web管理"/g' `egrep "Web 管理" -rl ./`
sed -i 's/"管理权"/"改密码"/g' `egrep "管理权" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `egrep "带宽监控" -rl ./`


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
