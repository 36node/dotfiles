## codex

[Codex](https://github.com/openai/codex) —— OpenAI 出的终端 AI 编码助手。
cask 分发，但安装后本质是 `codex` 这个 CLI。

## 安装

`install.sh` 通过 `brew_cask_install codex` 一键拉取最新版本。

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

| 仓库内 | 软链到 |
|---|---|
| `packages/codex/config.toml` | `~/.codex/config.toml` |

`config.toml` 里**只放行为配置**：

- `model` / `model_reasoning_effort` —— 选模型与推理强度（不设 `model_provider`，默认直连 OpenAI）
- `network_access`、`disable_response_storage` —— 运行/隐私开关

`source.zsh` 调用 `codex` 时会去掉 `OPENAI_BASE_URL`，防止环境里残留中转地址。

**敏感字段不在这里**：登录态在本机 `~/.codex/auth.json`（ChatGPT OAuth，不进 git/vault）。**不要**再 `codex login --with-api-key`。

## 已知副作用：config.toml 会被 codex 自动回写

下面两类内容由 codex 运行时自己写入 `~/.codex/config.toml`：

| 段 | 含义 | 为什么麻烦 |
|---|---|---|
| `[projects."<绝对路径>"]` | 项目信任级别 | 路径强机器相关，跨机不通用 |
| `[notice.model_migrations]` | 已展示过的迁移记录 | 看到一次新模型就会追加一条 |

因为本包选了「全量 symlink」策略，这两段会持续产生 `git diff`。处理方式：

- **同机使用**：定期把回写内容 commit 进仓库即可
- **跨机同步**：拉到另一台机时，`[projects.*]` 段需要手动改路径或保留两份

如果哪天觉得 diff 太烦，可以改成「只放共享字段、机器特定段走
`.gitignore` + `config.local.toml`」的方案（当前未启用）。

## 其他文件（不由本包管理）

- `~/.codex/auth.json` —— ChatGPT 登录凭据（不进 git/vault）
- `~/.codex/sessions/` `~/.codex/history.jsonl` —— 会话历史
- `~/.codex/log/` `~/.codex/*.sqlite*` —— 运行日志 / 状态
- 项目级 `<repo>/AGENTS.md` —— codex 项目记忆（类似 Claude Code 的 `CLAUDE.md`）

## 同类工具

仓库里同主题还装了：

- [`claude-code`](https://www.anthropic.com/claude-code)（cask）—— Anthropic 的同类，本仓库主力
- [`gemini-cli`](https://github.com/google-gemini/gemini-cli)（brew）—— Google Gemini

不同 AI CLI 习惯差不多，可以并存，按任务选用。
