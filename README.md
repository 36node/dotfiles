# dotfiles

一键初始化系统，快速同步团队开发环境。

注意：*目前仅支持 MacOs* 支持最新版 Monterey, 完全适配 M1 和 非M1 mac。

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

- 启动各种软件，其中 shadowsocks-ng/mos/spectacle 最好自动启动
- go2shell [设置方法](https://rebooters.github.io/2019/06/21/%E5%AE%89%E8%A3%85-go2shell-%E5%88%B0-Finder-%E5%B7%A5%E5%85%B7%E6%A0%8F%E7%9A%84%E6%96%B9%E6%B3%95/)
- terminal 设置 -> 建议 SolarizedDark 设置为默认，字体选择 Fira Code Nerd Font 选择细体 12 号
  ![image](https://user-images.githubusercontent.com/1524745/74656648-88958c80-51c9-11ea-89e9-6d9464992839.png)
- 运行 `p10k configure` 配置你的终端

## 重要的命令

命令行下开启翻墙

```sh
proxy on
```

命令行下关闭翻墙

```sh
proxy off
```

单独对 git 之类的命令行进行翻墙

```sh
pc4 git clone xxxxx
```

如果想在命令行有代理的提示，请修改 ~/.p10k.zsh 文件

在 POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS 中打开 proxy 选项

## 软件列表

### 重要软件包

- gfw: 翻墙相关, 包括 shadowsocks-ng, proxychains4-ng
- node: nodejs / yarn
- terminal: terminal 相关以及美化
- vim: vim 相关优化
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
- [go2shell](https://www.jianshu.com/p/bae3a64ea762)
- google-chrome
- mos
- [secure-pipes](https://www.opoet.com/pyro/index.php)
- [spectacle](https://www.spectacleapp.com/)
- visual-studio-code
- 微信
- 飞书

### 推荐的选装

- another-redis-desktop-manager   # redis gui
- spectacle                       # 分屏软件
- baidunetdisk                    # 百度网盘
- battle-net                      # 暴雪战网，最适合程序员的游戏
- dropbox                         # dropbox
- iina                            # 苹果风电影播放器
- keka                            # 压缩工具
- paper                           # 自动换壁纸
- qqmusic                         # qq 音乐
- snipaste                        # 截屏工具

### App Store
