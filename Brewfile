# 基础软件：./install.sh 完整安装时总会装
#
# 各 package 自己的软件在 packages/<name>/Brewfile（随 install.conf 的 PACKAGES 选择）
# 选装的在 Brewfile.extra（由 INSTALL_EXTRA 控制）
# 本机和清单的差异用 ./bundle.sh check / ./bundle.sh unlisted 查看

## 基础 CLI
brew "git"
brew "git-lfs"            # Git 大文件
brew "gh"                 # GitHub CLI
brew "jq"                 # JSON 处理
brew "yq"                 # YAML/JSON/XML 处理（jq 的 YAML 版）
brew "mas"                # Mac App Store CLI（Brewfile 里的 mas 条目靠它安装）
brew "ruby"               # macOS 自带 ruby 太老
brew "wget"
brew "autossh"            # SSH 隧道断线自动重连，配合 ~/.ssh/config 的 LocalForward 用
brew "iperf3"             # 网络带宽测试
brew "telnet"
brew "actionlint"         # GitHub Actions workflow 静态检查
cask "antigravity-cli"    # Google Antigravity CLI（gemini-cli 的官方替代，gemini-cli 将于 2026-12-18 被 Homebrew 禁用）

## 构建工具（C/C++、嵌入式、WebAssembly）
brew "cmake"
brew "ninja"
brew "emscripten"         # C/C++ → WebAssembly
brew "dfu-util"           # USB DFU 烧录

## 媒体 / 压缩（yazi 的预览功能也依赖这几个）
brew "ffmpeg"
brew "imagemagick"
brew "librsvg"            # rsvg-convert：SVG 转 PNG/PDF
brew "poppler"            # 提供 pdftotext / pdftoppm，PDF 处理 + yazi PDF 预览
brew "sevenzip"           # 7z 压缩工具

## 编辑器 / 设计
## 注：claude-code / codex 在 packages/<name>/Brewfile
cask "visual-studio-code"
cask "zed"
cask "figma"

## 浏览器 / Git / API
cask "github"             # GitHub Desktop
cask "google-chrome"
cask "postman"

## AI 桌面应用
cask "chatgpt"            # ChatGPT，同时也是 Codex 桌面版
cask "claude"             # Claude 桌面版
cask "doubao"             # 豆包
cask "open-design"

## 网络 / 系统工具
cask "clash-verge-rev"    # 代理客户端
cask "balenaetcher"       # 烧录系统镜像到 U 盘 / SD 卡

## macOS 体验增强
cask "keyclu"             # 长按 Cmd 显示快捷键
cask "monitorcontrol"     # 用键盘控制外接显示器亮度/音量（macOS 自身不支持非 Apple 屏）
cask "mos"                # 鼠标平滑滚动 + 反向

## 通讯 / 办公
cask "feishu"             # 飞书
cask "wechat"             # 微信
cask "dingtalk"           # 钉钉
cask "qq"
cask "tencent-meeting"    # 腾讯会议
## 网易邮箱大师：下载地址 mail5.dmg 不带版本号，官方换包后 cask 的 sha256 跟不上，
## 2026-10-31 装不上（reports different checksum），等上游 cask 更新后再放开；需要的话先去官网手动装
# cask "mailmaster"
