## 注意事项

基于 [LazyVim](https://www.lazyvim.org/) 的 Neovim 配置。

### 首次使用

首次执行 `nvim`，LazyVim 会自动下载并安装插件，请耐心等待。

安装完成后建议执行健康检查，确认环境就绪：

```vim
:checkhealth
```

### 自定义

`~/.config/nvim` 下是 LazyVim starter，可自由修改 `lua/config/`、`lua/plugins/` 中的内容。

如果已经存在 `~/.config/nvim`，install.sh 不会覆盖，请自行管理。
