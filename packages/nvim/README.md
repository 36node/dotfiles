## 注意事项

基于 [LazyVim](https://www.lazyvim.org/) 的 Neovim 配置。

`install.sh` 把 `packages/nvim/config/` 软链到 `~/.config/nvim`，所有自定义都跟仓库一起进版本控制。

### 首次使用

首次执行 `nvim`，LazyVim 会根据 `lazy-lock.json` 锁定的版本下载插件，请耐心等待。

安装完成后建议执行健康检查，确认环境就绪：

```vim
:checkhealth
```

### 自定义

直接编辑 `packages/nvim/config/` 下的文件：

- `lua/config/`：核心配置（options / keymaps / autocmds）
- `lua/plugins/`：插件覆盖与新增

改完 commit 即可。`lazy-lock.json` 同样纳入版本控制，保证多机插件版本一致；想升级时执行 `:Lazy sync` 后把新的 lock 提交回来。
