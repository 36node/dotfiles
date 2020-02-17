# dotfiles

团队的基础系统配置，目前只是用于 mac 系统。终端效果

![image](https://user-images.githubusercontent.com/1524745/74650708-3ea6a980-51bd-11ea-985e-60476e5dc18f.png)

建议 fork 一份代码到自己的仓库，然后

1. 修改 extra.sh，放入自己特殊的安装脚本
2. packages 增加自己特有的需求
3. 如果这个修改你觉得可以贡献到 36node 库，cherry pick 出来后，发 pr 到 36node 库。

## 准备工作

1. 在开始安装之前，需要关闭系统的 SIP 服务，[参考](https://sspai.com/post/55066)
2. 在你的 icloud 根目录中，建立 .dotfiles 目录，用于存放私有敏感数据

## 安装

1. 从你 fork 的工程里，克隆代码
2. 在 `$iCloud/.dotfiles` 下放置 .env 文件，定义私有的环境变量，如果没有 .env 文件会采用默认值

.env 默认值，ps:**如果和默认值一样无需提供**

```sh
export ZSHRC=$HOME/.zshrc
export WORKSPACE=$HOME/Workspace
export COMPUTER_NAME=$USER
```

```sh
cd dotfiles
./install.sh
```

可以反复安装

## 收尾

- 装完后记得重启 mac, 顺便重新开启 SIP 服务
- 启动各种软件，其中 shadowsocks-ng/mos/spectacle 最好自动启动
- go2shell [设置方法](https://rebooters.github.io/2019/06/21/%E5%AE%89%E8%A3%85-go2shell-%E5%88%B0-Finder-%E5%B7%A5%E5%85%B7%E6%A0%8F%E7%9A%84%E6%96%B9%E6%B3%95/)
- terminal 设置 -> 建议 SolarizedDark 设置为默认，字体选择 Fira Code Nerd Font 选择细体 12 号
![image](https://user-images.githubusercontent.com/1524745/74656648-88958c80-51c9-11ea-89e9-6d9464992839.png)

## 重要的命令

命令行下开启翻墙

```sh
proxy
```

命令行下关闭翻墙

```sh
proxy off
```

单独对 git 之类的命令行进行翻墙

```sh
pc4 git clone xxxxx
```

## 软件列表

重要软件包

- gfw: 翻墙相关, 包括 shadowsocks-ng, proxychains4-ng
- node: nodejs / yarn
- terminal: terminal 相关以及美化
- vim: vim 相关优化
- osx: 操作系统相关

命令行程序

- tree
- autojump
- kubernetes-cli

GUI 程序

- [cheatsheet](https://free.com.tw/cheatsheet/)
- docker
- dropbox
- github
- [go2shell](https://www.jianshu.com/p/bae3a64ea762)
- google-chrome
- [iina](https://iina.io/)
- mos
- [secure-pipes](https://www.opoet.com/pyro/index.php)
- [spectacle](https://www.spectacleapp.com/)
- visual-studio-code
- [wechatwebdevtools](https://developers.weixin.qq.com/miniprogram/dev/devtools/devtools.html)
