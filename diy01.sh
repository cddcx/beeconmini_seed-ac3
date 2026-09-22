#!/bin/bash

# 拉取仓库文件夹
merge_package() {
	# 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
	# 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
	# 示例:
	# merge_package master https://github.com/WYC-2020/openwrt-packages package/openwrt-packages luci-app-eqos luci-app-openclash luci-app-ddnsto ddnsto 
	# merge_package master https://github.com/lisaac/luci-app-dockerman package/lean applications/luci-app-dockerman
	if [[ $# -lt 3 ]]; then
		echo "Syntax error: [$#] [$*]" >&2
		return 1
	fi
	trap 'rm -rf "$tmpdir"' EXIT
	branch="$1" curl="$2" target_dir="$3" && shift 3
	rootdir="$PWD"
	localdir="$target_dir"
	[ -d "$localdir" ] || mkdir -p "$localdir"
	tmpdir="$(mktemp -d)" || exit 1
	git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
	cd "$tmpdir"
	git sparse-checkout init --cone
	git sparse-checkout set "$@"
	# 使用循环逐个移动文件夹
	for folder in "$@"; do
		mv -f "$folder" "$rootdir/$localdir"
	done
	cd "$rootdir"
}

drop_package(){
	find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}

merge_feed(){
	./scripts/feeds update $1
	./scripts/feeds install -a -p $1
}

echo "开始 DIY1 配置……"
echo "========================="

##原版op添加ac3支持
cp -f ${GITHUB_WORKSPACE}/patch/Makefile package/kernel/rtl8373n-ac3/Makefile
cp -f ${GITHUB_WORKSPACE}/patch/mt7986a-beeconmini-seed-ac3.dts target/linux/mediatek/dts/mt7986a-beeconmini-seed-ac3.dts
rm -rf target/linux/mediatek/filogic/base-files/etc/board.d/02_network
cp -f ${GITHUB_WORKSPACE}/patch/02_network target/linux/mediatek/filogic/base-files/etc/board.d/02_network
rm -rf target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh
cp -f ${GITHUB_WORKSPACE}/patch/platform.sh target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh
rm -rf target/linux/mediatek/image/filogic.mk
cp -f ${GITHUB_WORKSPACE}/patch/filogic.mk target/linux/mediatek/image/filogic.mk
#merge_package 25.12.5 https://github.com/BeeconMini/openwrt package/ac3 target/linux/mediatek
#cp -f package/ac3/mediatek/filogic/base-files/etc/board.d/02_network target/linux/mediatek/filogic/base-files/etc/board.d/02_network
#cp -f package/ac3/mediatek/filogic/base-files/lib/upgrade/platform.sh target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh
#cp -f package/ac3/mediatek/image/filogic.mk target/linux/mediatek/image/filogic.mk
#cp -f package/ac3/mediatek/dts/mt7986a-beeconmini-seed-ac3.dts target/linux/mediatek/dts/mt7986a-beeconmini-seed-ac3.dts
#merge_package 25.12.5 https://github.com/BeeconMini/openwrt package/kernel package/kernel/rtl8373n-ac3
#rm -rf package/ac3

## autocore automount default-settings
merge_package master https://github.com/immortalwrt/immortalwrt package/emortal package/emortal/default-settings

echo "========================="
echo " DIY1 配置完成……"
