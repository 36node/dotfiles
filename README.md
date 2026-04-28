# dotfiles

一键初始化系统，快速同步团队开发环境。

注意：*目前仅支持 macOS*，已在 macOS 26 (Tahoe) 上验证，兼容 Apple Silicon 与 Intel。

![image](https://user-images.githubusercontent.com/1524745/74650708-3ea6a980-51bd-11ea-985e-60476e5dc18f.png)

## 使用方法

建议：*fork 一份代码到自己的仓库*

1. 修改 extra.sh，放入自己特殊的安装脚本
2. packages 增加自己特有的需求
3. 如果这个修改你觉得可以贡献到 36node 库，cherry pick 出来后，发 pr 到 36node 库。

## 安装

1. 从你 fork 的工程里，克隆代码
2. `cp .env.example .env`

可以覆盖系统的环境变量，加一些 private 的环境变量

```sh
export ZSHRC=$HOME/.zshrc
export WORKSPACE=$HOME/Workspace
export COMPUTER_NAME=$USER
```

一键安装

```sh
cd dotfiles
./install.sh
```

可以反复安装

## 收尾

- 启动各种软件，其中 mos 最好自动启动
- go2shell [设置方法](https://rebooters.github.io/2019/06/21/%E5%AE%89%E8%A3%85-go2shell-%E5%88%B0-Finder-%E5%B7%A5%E5%85%B7%E6%A0%8F%E7%9A%84%E6%96%B9%E6%B3%95/)
- ghostty 已默认使用 JetBrains Mono Nerd Font，配置已 symlink 到 `~/.config/ghostty/config`，无需手动设置
- 运行 `p10k configure` 配置你的终端
- 首次启动 `nvim`，LazyVim 会自动安装插件，完成后可运行 `:checkhealth` 检查环境

## 软件列表

### 重要软件包

- node: fnm + nodejs / corepack(yarn, pnpm)
- nvim: neovim + LazyVim + ripgrep + fd
- terminal: ghostty + JetBrains Mono Nerd Font + zsh 美化（oh-my-zsh / powerlevel10k）
- osx: 操作系统相关

### 命令行程序

- autojump
- git
- mas
- tree
- kubernetes-cli
- wget

### GUI 程序

- [cheatsheet](https://free.com.tw/cheatsheet/)
- docker
- dropbox
- github
- [ghostty](https://ghostty.org/)
- [go2shell](https://www.jianshu.com/p/bae3a64ea762)
- google-chrome
- mos
- [secure-pipes](https://www.opoet.com/pyro/index.php)
- visual-studio-code
- 微信
- 飞书

### 推荐的选装

- another-redis-desktop-manager   # redis gui
- baidunetdisk                    # 百度网盘
- battle-net                      # 暴雪战网，最适合程序员的游戏
- dropbox                         # dropbox
- iina                            # 苹果风电影播放器
- keka                            # 压缩工具
- paper                           # 自动换壁纸
- qqmusic                         # qq 音乐
- snipaste                        # 截屏工具

### App Store

- Xcode
- Magnet  # 分屏管理
