#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好


# 后台IP设置
export Ipv4_ipaddr="192.168.1.1"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="OpenWrt"                    # 修改主机名称为OpenWrt-123(填0为不作修改)

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
export Enable_IPV6_function="1"              # 编译IPV6固件(1为启用命令,填0为不作修改)
export Disable_IPv6_option="0"               # 关闭固件里面所有IPv6选项和IPv6的DNS解析记录(1为启用命令,填0为不作修改)

# OpenClash
export OpenClash_branch="0"                  # OpenClash代码选择分支（master 或 dev）(填0为不需要此插件)
export OpenClash_Core="0"                    # 编译固件增加OpenClash时,把核心下载好,核心为3MB左右大小(1为启用命令,填0为不需要核心)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="@waynesg $(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件时把核心一起下载好
export AdGuardHome_Core="0"                  # 编译固件增加AdGuardHome时,把核心下载好,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不需要核心)

# 其他
export Ttyd_account_free_login="1"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="0"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带次功能)(1为启用命令,填0为不作修改)
export Cancel_running="1"                    # 取消路由器每天跑分任务(个别源码本身不带次功能)(1为启用命令,填0为不作修改)


# 修改插件名字
sed -i 's/"概览"/"首页概览"/g' `egrep "概览" -rl ./`
sed -i 's/"路由"/"路由表"/g' `egrep "路由" -rl ./`
sed -i 's/"管理权"/"访问密码"/g' `egrep "管理权" -rl ./`
sed -i 's/"终端"/"命令终端"/g' `egrep "终端" -rl ./`
sed -i 's/"挂载点"/"挂载路径"/g' `egrep "挂载点" -rl ./`
sed -i 's/"启动项"/"启动管理"/g' `egrep "启动项" -rl ./`
sed -i 's/"软件包"/"软件管理"/g' `egrep "软件包" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `egrep "网络存储" -rl ./`
sed -i 's/"备份与升级"/"备份升级"/g' `egrep "备份与升级" -rl ./`
sed -i 's/"Argon 主题设置"/"主题设置"/g' `egrep "Argon 主题设置" -rl ./`
sed -i 's/"重启"/"系统重启"/g' `egrep "重启" -rl ./`

sed -i 's/"PassWall 2"/"PassWall+"/g' `egrep "PassWall 2" -rl ./`
sed -i 's/"上网时间控制"/"上网时间"/g' `egrep "上网时间控制" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"网易音乐"/g' `egrep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"MultiSD_Lite"/"组播路由"/g' `egrep "MultiSD_Lite" -rl ./`
sed -i 's/"Internet Detector"/"网络探测"/g' `egrep "Internet Detector" -rl ./`
sed -i 's/"AirConnect"/"隔空传送"/g' `egrep "AirConnect" -rl ./`
sed -i 's/"UPnP"/"UPnP服务"/g' `egrep "UPnP" -rl ./`
sed -i 's/"Hello World"/"VssrVPN"/g' `egrep "Hello World" -rl ./`

sed -i 's/"Alist 文件列表"/"Alist列表"/g' `egrep "Alist 文件列表" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `egrep "USB 打印服务器" -rl ./`

sed -i 's/"接口"/"网络接口"/g' `egrep "接口" -rl ./`
sed -i 's/"路由"/"路由规则"/g' `egrep "路由" -rl ./`
sed -i 's/"IP\/MAC绑定"/"地址绑定"/g' `egrep "IP\/MAC绑定" -rl ./`
sed -i 's/"Socat"/"端口转发"/g' `egrep "Socat" -rl ./`
sed -i 's/"Turbo ACC Center"/"网络加速"/g' `egrep "Turbo ACC Center" -rl ./`

sed -i 's/"ZeroTier"/"ZeroTier虚拟网络"/g' `egrep "ZeroTier" -rl ./`
sed -i 's/"OpenVPN"/"OpenVPN 客户端"/g' `egrep "OpenVPN" -rl ./`

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
-uefi-
sha256sums
version.buildinfo
EOF

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
