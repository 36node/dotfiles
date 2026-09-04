## zerotier

[ZeroTier](https://www.zerotier.com/) —— 虚拟局域网，免开 VPN 跨机直连。
cask 分发官方客户端，安装后带菜单栏 GUI 和 `zerotier-cli`。

## 安装

`install.sh` 通过 `brew_cask_install zerotier-one` 拉取客户端。

加入网络、授权节点仍走 ZeroTier Central 或本机 `zerotier-cli`。

## Shell 命令

`source.zsh` 注入 `zero`，用来启停本机 daemon（需要 sudo）：

```sh
zero start      # launchctl load
zero stop       # launchctl unload
zero restart    # unload，等 10 秒再 load
zero info       # 节点状态 + 已加入网络（zerotier-cli info / listnetworks）
```

加网仍用官方 CLI：

```sh
zerotier-cli join <network-id>
```
