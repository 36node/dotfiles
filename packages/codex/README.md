## codex

[Codex](https://github.com/openai/codex) —— OpenAI 出的终端 AI 编码助手。
cask 分发，但安装后本质是 `codex` 这个 CLI。

## 安装

`install.sh` 通过 `brew_cask_install codex` 一键拉取最新版本。

## 首次使用

`install.sh` 在 `.env` 里有 `OPENAI_API_KEY` 时会自动跑 `codex login --with-api-key`
写入 `~/.codex/auth.json`，无需手动登录。之后直接：

```sh
codex                # 进入交互模式
codex --help         # 看完整 CLI 参考
codex doctor         # 检查本机安装 / 配置 / auth / 运行时健康
codex logout         # 退出登录（清理 auth.json）
```

想换 key 或重新登录：`codex logout && ./install.sh`。

## 配置文件

| 仓库内 | 软链到 |
|---|---|
| `packages/codex/config.toml` | `~/.codex/config.toml` |

`config.toml` 里**只放行为配置**：

- `model_provider` / `model` / `model_reasoning_effort` —— 选模型与推理强度
- `[model_providers.<name>]` —— 自定义 OpenAI-compatible endpoint
  （本仓库走 [linkapi](https://api.linkapi.ai)）
- `network_access`、`disable_response_storage` —— 运行/隐私开关

**敏感字段不在这里**：

| 变量 | 来源 |
|---|---|
| `OPENAI_API_KEY` | `.env`（vault 同步，跨机自动一致） |

`.env` 在 shell 启动时 export 进环境；`install.sh` 用 `printenv OPENAI_API_KEY \| codex login --with-api-key` 把它写入本机 `~/.codex/auth.json`。
`auth.json` 留在本机（不进 git、不进 vault），但凭据本体随 `.env` 跨机。

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

- `~/.codex/auth.json` —— `install.sh` 由 `.env` 生成的本机凭据（不进 git/vault）
- `~/.codex/sessions/` `~/.codex/history.jsonl` —— 会话历史
- `~/.codex/log/` `~/.codex/*.sqlite*` —— 运行日志 / 状态
- 项目级 `<repo>/AGENTS.md` —— codex 项目记忆（类似 Claude Code 的 `CLAUDE.md`）

## 同类工具

仓库里同主题还装了：

- [`claude-code`](https://www.anthropic.com/claude-code)（cask）—— Anthropic 的同类，本仓库主力
- [`gemini-cli`](https://github.com/google-gemini/gemini-cli)（brew）—— Google Gemini

不同 AI CLI 习惯差不多，可以并存，按任务选用。
