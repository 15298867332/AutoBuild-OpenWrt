#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
####################################################################
#rm -rf package/feeds/luci/luci-app-openclash
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/smartdns
#########################################################################
#src-git small8 https://github.com/kenzok8/small-package
./scripts/feeds update -a && ./scripts/feeds install -a
###go版本升级######################################################
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
##############################################################################################
# xfsprogs
#sed -i 's/DHAVE_MAP_SYNC/DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' package/feeds/packages/xfsprogs/Makefile
# 更改默认 Shell 为 zsh
#sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
# speedtest
sed -i 's/PKG_BUILD_DEPENDS:=golang/host/PKG_BUILD_DEPENDS:=golang/host upx/host/g' package/feeds/small8/speedtest-web/Makefile
# Modify default IP
#sed -i 's/192.168.1./192.168.2./g' package/base-files/files/bin/config_generate
# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

./scripts/feeds update -a && ./scripts/feeds install -a
