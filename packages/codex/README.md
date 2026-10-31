## codex

[Codex](https://github.com/openai/codex) —— OpenAI 出的终端 AI 编码助手。
cask 分发，但安装后本质是 `codex` 这个 CLI。

## 安装

同目录 `Brewfile` 通过 `cask "codex"` 一键拉取最新版本。

## 首次使用

CLI 与桌面版共用 `~/.codex`，走 **ChatGPT 官网账号**。不要用 `OPENAI_API_KEY` / `OPENAI_BASE_URL` 登录 Codex。

```sh
codex login          # 浏览器登录 ChatGPT
codex                # 进入交互模式
codex --help         # 看完整 CLI 参考
codex doctor         # 检查本机安装 / 配置 / auth / 运行时健康
codex logout         # 退出登录（清理 auth.json）
```

桌面版（ChatGPT.app / Codex）在应用内 Sign in 即可，凭据同样写到 `~/.codex/auth.json`。

## Shell 别名

`source.zsh` 注入：

```sh
alias cx='codex --dangerously-bypass-approvals-and-sandbox'
```

`cx` 直接进入「跳过审批 + 跳过 sandbox」的全自动模式，codex 会无提示地
读写文件、执行命令、联网。**仅在自己信任、可丢弃的环境（个人项目、临时
worktree、容器）里用**；接触他人代码、生产配置或敏感数据时请用原始 `codex`。

## 配置文件

| 位置 | 说明 |
|---|---|
| `$DOTFILES_VAULT/.codex/config.toml` | 真身，跨机同步（默认 iCloud Drive），**不进 git** |
| `~/.codex/config.toml` | 软链到上面的真身 |
| `packages/codex/config.example.toml` | 进 git 的模板，只在本机和 vault 都没有配置时拷贝一次 |

为什么不进 git：codex（尤其桌面版）会持续往 `config.toml` 回写本机信息，仓库是公开的，
这些内容进 git 就会泄露本机路径和在做的项目：

| 段 | 含义 |
|---|---|
| `[projects."<绝对路径>"]` | 项目信任级别 |
| `[desktop.open-in-target-preferences.perPath]`、`git-worktree-root` | 按路径记住的打开方式、worktree 目录 |
| `[notice.*]`、`[tui.*]` | 已展示过的迁移/提示记录 |
| `[marketplaces.*]`、`[plugins.*]`、`[mcp_servers.node_repl]`、`notify` | 桌面版写入的插件与内置 MCP，带本机路径和应用版本号 |

想改模型 / 推理强度 / 桌面偏好时直接改 `~/.codex/config.toml`，会自动同步到其他机器。
希望新机器默认值也跟着变，再顺手同步到 `config.example.toml`（只放上面这些本机段以外的字段）。

迁移说明：以前 `~/.codex/config.toml` 直接软链到仓库内 `packages/codex/config.toml`。
`./install.sh codex` 会把旧软链转成实体文件并挪进 vault（vault 里还没有时），或直接链到 vault 里已有的那份。

其他还在旧方案上的机器：

1. 那台机器上 codex 一直往 `packages/codex/config.toml` 回写，`git pull` 可能因为本地修改拒绝删除它。
   想保留那台的本机改动就先 `cp packages/codex/config.toml /tmp/codex-config.toml` 备份，
   然后 `git checkout -- packages/codex/config.toml` 再 `git pull`
2. 跑 `./install.sh codex`：vault 里已有的那份（第一台机器迁移过去的）会生效，
   那台机器独有的 `[projects.*]` 信任记录需要的话从备份里手动合并
3. `packages/codex/config.toml` 已加入 `.gitignore`，旧软链在迁移前被 codex 写回也不会再进 git

`source.zsh` 调用 `codex` 时会去掉 `OPENAI_BASE_URL`，防止环境里残留中转地址。

**敏感字段不在这里**：登录态在本机 `~/.codex/auth.json`（ChatGPT OAuth，不进 git/vault）。**不要**再 `codex login --with-api-key`。

## 其他文件（不由本包管理）

- `~/.codex/auth.json` —— ChatGPT 登录凭据（不进 git/vault）
- `~/.codex/sessions/` `~/.codex/history.jsonl` —— 会话历史
- `~/.codex/log/` `~/.codex/*.sqlite*` —— 运行日志 / 状态
- 项目级 `<repo>/AGENTS.md` —— codex 项目记忆（类似 Claude Code 的 `CLAUDE.md`）

## 同类工具

仓库里同主题还装了：

- [`claude-code`](https://www.anthropic.com/claude-code)（cask）—— Anthropic 的同类，本仓库主力
- [`antigravity-cli`](https://antigravity.google/product/antigravity-cli)（cask）—— Google Antigravity，gemini-cli 的官方替代

不同 AI CLI 习惯差不多，可以并存，按任务选用。
