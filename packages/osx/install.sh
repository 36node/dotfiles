#!/bin/sh
#
# osx 相关


info "更新 系统软件 ..."
sudo softwareupdate -i -a
success "更新成功 系统软件"

info "设置 macos"

###############################################################################
# 常规                                                                        #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName ${COMPUTER_NAME}
sudo scutil --set HostName ${COMPUTER_NAME}
sudo scutil --set LocalHostName ${COMPUTER_NAME}
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string ${COMPUTER_NAME}

# 打开关闭窗口时禁用动画
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# 打开 Quick Look 窗口时禁用动画
defaults write -g QLPanelAnimationDuration -float 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# 屏幕                                                                        #
###############################################################################

# 屏幕截屏保存到桌面
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# 保存格式为 JPG
defaults write com.apple.screencapture type -string "jpg"

# 截图禁用阴影
defaults write com.apple.screencapture disable-shadow -bool true

# 在非Apple LCD上启用亚像素字体渲染
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0


###############################################################################
# Finder                                                                      #
###############################################################################

# 禁用窗口动画和获取信息动画
defaults write com.apple.finder DisableAllAnimations -bool true

# 不显示文件的扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

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

# 不显示隐藏文件
defaults write com.apple.finder AppleShowAllFiles -bool false;



###############################################################################
# Dock                                                                        #
###############################################################################

# Dock 项目图标大小设置
defaults write com.apple.dock tilesize -int 48

# 最小化/最大化窗口效果
defaults write com.apple.dock mineffect -string "scale"

# Dock 打开应用时禁用动画
defaults write com.apple.dock launchanim -bool false

# 不显示最近应用
defaults write com.apple.dock show-recents -bool false

# 重新整理 Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/企业微信.app"
dockutil --no-restart --add "/Applications/WeChat.app"

killall Dock


###############################################################################
# Terminal                                                                    #
###############################################################################

# 使用 UTF-8 编码
defaults write com.apple.terminal StringEncodings -array 4

# 退出时不显示提示
defaults write com.apple.terminal PromptOnQuit -bool false


###############################################################################
# 硬盘                                                                         #
###############################################################################

# 关闭空硬盘Time Machine提醒
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# 键盘                                                                         #
###############################################################################

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 1



###############################################################################
# 其它                                                                         #
###############################################################################

# 阻止 Photo 自动打开
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# 杀掉影响进程的应用程序
for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
  killall "${app}" &> /dev/null
done

sudo spctl --master-disable

success "设置完成，其中一些更改需要注销/重新启动才能生效"