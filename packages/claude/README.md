## claude

[Claude Code](https://www.anthropic.com/claude-code) —— Anthropic 出的终端 AI 编码助手。
cask 分发，但安装后本质是 `claude` 这个 CLI。

## 安装

`install.sh` 通过 `brew_cask_install claude-code` 一键拉取最新版本。

## 首次使用

```sh
claude           # 进入交互模式
claude --help    # 看完整 CLI 参考
```

首次启动会让你登录 Anthropic 账号，也可以用 `ANTHROPIC_API_KEY` 走 API Key 路径
（适合需要细粒度计费 / 不想登录 Claude.ai 账号的场景）。

## 快捷键 / 斜杠命令

仓库根目录 [`SHORTCUTS.md`](../../SHORTCUTS.md) 里有 Claude Code 的常用快捷键、
prefix 命令（`/`、`!`、`@`）与 vim mode 切换备忘。完整列表见
[官方 Interactive mode 文档](https://docs.claude.com/en/docs/claude-code/interactive-mode)。

## 配置文件

| 仓库内 | 软链到 |
|---|---|
| `packages/claude/settings.json` | `~/.claude/settings.json` |

`settings.json` 里**只放行为配置**：默认权限模式、模型、deny 列表（屏蔽 `.env` /
`.secrets` 的读写，见下方「deny 规则的边界」），可以安全进 git。

**敏感字段不在这里**：

| 变量 | 来源 |
|---|---|
| `ANTHROPIC_AUTH_TOKEN` | `.env`（vault 同步，跨机自动一致） |
| `ANTHROPIC_BASE_URL` | `.env` |
| `API_TIMEOUT_MS` | `.env` |

仓库根 `source.zsh` 在新 shell 启动时把 `.env` 里的变量 `export` 到环境，Claude Code
启动时会读取这些 env，不再走 `settings.json` 的 `env` 字段。

其他相关文件（**不由本包管理**）：

- 项目级 `<repo>/.claude/settings.json` 或 `settings.local.json`（机器/项目特定）
- 长期记忆 `~/.claude/CLAUDE.md`、项目根 `CLAUDE.md`

## deny 规则的边界

deny 规则在任何权限模式下都生效，包括 `defaultMode: bypassPermissions`。覆盖范围分两层：

- **`Read(...)` / `Edit(...)` / `Write(...)`**：封住内置文件工具；按官方文档，也覆盖 Bash 里
  Claude Code 认得的文件命令（`cat` / `head` / `tail` / `sed` / `tee`）和 `< file` / `> file` 重定向
- **`Bash(...)`**：补上 `Read` 规则管不到的读取命令 —— `bat` / `less` / `more` / `grep` / `rg` /
  `awk` / `source` / `.`。每个命令覆盖 `cmd .env`、`cmd * .env`、`cmd */.env` 三种位置，以及对应的
  `.env.*`（`.secrets` 同理）。和 `Read` 规则一样只认 `.env` / `.env.*`，不会挡 `.envrc`

Bash 规则只按命令文本匹配，所以有两类副作用要心里有数：

- **误伤**：命令文本里任何位置出现「空格或 `/` 紧跟 `.env`」都会命中，包括搜索词本身。
  `rg process.env` 不受影响，但 `grep -rn 'source .env' .`、`rg 'cp .env.example .env'` 会被拒，
  需要时换个写法（例如 `rg 'source \.env'`）或自己在终端里跑
- **漏网**：这仍然**不是安全边界**。带引号的路径（`grep TOKEN ".env"`、`source '.env'`）、
  `/bin/cat .env`、`bash -c '...'`、`python -c 'open(".env")'`、`grep -r TOKEN .` 都能绕过

继续加固的方向（按需自取）：

- 开启 Claude Code sandbox（`sandbox.enabled`），让 `Read` deny 在 OS 层对子进程生效

- 加 `PreToolUse` hook 在 Bash 调用前用脚本拦截命令串
- 把 token 从 `.env` 移到 macOS Keychain，shell 启动时再 `export`

## 同类工具

仓库里同主题还装了：

- [`codex`](https://github.com/openai/codex)（cask）—— OpenAI 的同类
- [`gemini-cli`](https://github.com/google-gemini/gemini-cli)（brew）—— Google Gemini

不同 AI CLI 习惯差不多，可以并存，按任务选用。
