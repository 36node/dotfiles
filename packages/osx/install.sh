#!/bin/bash
#
# osx 相关


# 如需安装系统更新，请手动执行：sudo softwareupdate -i -a
# 这里默认不自动跑，避免一键脚本里触发非预期的大版本升级

message "设置 macos"

###############################################################################
# 常规                                                                        #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
# LocalHostName 不允许空格、点、下划线，统一清洗为连字符
LOCAL_HOST_NAME=$(echo "${COMPUTER_NAME}" | tr ' ._' '-')
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${LOCAL_HOST_NAME}"

# 打开关闭窗口时禁用动画
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# 注意：现代 macOS（Mojave 10.14+）下，Safari 偏好被沙盒在
# ~/Library/Containers/com.apple.Safari/，defaults 无权限写入会导致 exiting。
# 想开 Safari 开发者菜单，请用 GUI：Safari → 设置 → 高级 → 「在菜单栏中显示开发菜单」


###############################################################################
# 屏幕截图                                                                        #
###############################################################################

# 屏幕截屏保存到 ~/Pictures/Screenshots
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# 截图禁用阴影
defaults write com.apple.screencapture disable-shadow -bool true


###############################################################################
# Finder                                                                      #
###############################################################################

# 显示文件的扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 显示状态栏
defaults write com.apple.finder ShowStatusBar -bool true

# 显示路径栏
defaults write com.apple.finder ShowPathbar -bool true

# 更改文件名时不警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 避免在网络卷上创建.DS_Store文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# 清空垃圾箱前不显示警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false


###############################################################################
# Dock                                                                        #
###############################################################################

# Dock 项目图标大小设置
defaults write com.apple.dock tilesize -int 48

# 最小化/最大化窗口效果
defaults write com.apple.dock mineffect -string "scale"

# 不显示最近应用
defaults write com.apple.dock show-recents -bool false


###############################################################################
# 硬盘                                                                         #
###############################################################################

# 关闭空硬盘 Time Machine 提醒
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# 键盘                                                                         #
###############################################################################

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 2

# 重复前延迟
defaults write NSGlobalDomain InitialKeyRepeat -int 15


###############################################################################
# 其它                                                                         #
###############################################################################

# 阻止 Photo 自动打开
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# 杀掉影响进程的应用程序（先 cfprefsd 让 defaults 缓存失效，再重启 UI 进程）
for app in "cfprefsd" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer"; do
  killall "${app}" &> /dev/null || true
done

success "设置完成，其中一些更改需要注销/重新启动才能生效"
echo ""
