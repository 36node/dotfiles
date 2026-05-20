# 快捷键速查：ghostty / yazi / zoxide / claude

仓库内终端栈核心工具的常用快捷键 / 命令。
ghostty 默认值来自 `ghostty +list-keybinds --default`，yazi 来自官方 quick-start，
zoxide 取自其 README，Claude Code 来自官方 Interactive mode 文档。

> macOS 下 `super` = `⌘ Cmd`，`alt` = `⌥ Option`，`ctrl` = `⌃ Control`，`shift` = `⇧ Shift`。

---

## Ghostty（终端模拟器）

### 窗口 / Tab / 分屏

| 快捷键 | 动作 |
|---|---|
| `⌘ N` | 新窗口 |
| `⌘ T` | 新 tab |
| `⌘ W` | 关闭当前 surface（split 优先，否则 tab） |
| `⌘ ⌥ W` | 关闭当前 tab |
| `⌘ ⇧ W` | 关闭整个窗口 |
| `⌘ ⌥ ⇧ W` | 关闭所有窗口 |
| `⌘ Q` | 退出 Ghostty |
| `⌘ D` | 向右切分（vertical split） |
| `⌘ ⇧ D` | 向下切分（horizontal split） |
| `⌘ Enter` | 切换全屏 |
| `⌘ ⇧ Enter` | split 当前面板 zoom 切换 |
| `⌘ ⌃ F` | 切换全屏（备用） |

### Tab 切换

| 快捷键 | 动作 |
|---|---|
| `⌘ ⇧ [` / `⌃ ⇧ Tab` | 上一个 tab |
| `⌘ ⇧ ]` / `⌃ Tab` | 下一个 tab |
| `⌘ 1` … `⌘ 8` | 跳到第 N 个 tab |
| `⌘ 9` | 跳到最后一个 tab |

### Split 面板间导航 / 调整

| 快捷键 | 动作 |
|---|---|
| `⌘ [` / `⌘ ]` | 上一个 / 下一个 split |
| `⌘ ⌥ ↑ ↓ ← →` | 按方向跳到相邻 split |
| `⌘ ⌃ ↑ ↓ ← →` | 按方向缩放 split（10 单位） |
| `⌘ ⌃ =` | 平均化所有 split |

### 复制 / 粘贴 / 选择

| 快捷键 | 动作 |
|---|---|
| `⌘ C` | 复制到剪贴板 |
| `⌘ V` | 从剪贴板粘贴 |
| `⌘ ⇧ V` | 从主选区（selection）粘贴 |
| `⌘ A` | 全选当前屏幕 |
| `⇧ ← → ↑ ↓` | 调整选区范围 |
| `⇧ Home` / `⇧ End` | 选区到行首 / 行尾 |
| `⇧ PgUp` / `⇧ PgDn` | 翻页扩展选区 |

### 字体大小

| 快捷键 | 动作 |
|---|---|
| `⌘ +` / `⌘ =` | 字号 +1 |
| `⌘ -` | 字号 -1 |
| `⌘ 0` | 重置字号 |

### 滚动 / 跳转

| 快捷键 | 动作 |
|---|---|
| `⌘ Home` | 滚到顶 |
| `⌘ End` | 滚到底 |
| `⌘ PgUp` / `⌘ PgDn` | 翻页滚动 |
| `⌘ J` | 滚到当前选区 |
| `⌘ ↑` / `⌘ ↓` | 上 / 下一个 prompt（shell-integration） |
| `⌘ ⇧ ↑` / `⌘ ⇧ ↓` | 同上（备用） |
| `⌥ ←` / `⌥ →` | 按词左移 / 右移光标（发 `ESC b` / `ESC f`） |
| `⌘ ←` | 跳到行首（发 `^A`） |
| `⌘ →` | 跳到行尾（发 `^E`） |
| `⌘ Backspace` | 清除整行（发 `^U`） |

### 搜索

| 快捷键 | 动作 |
|---|---|
| `⌘ F` | 开始搜索 |
| `⌘ E` | 用当前选区做搜索 |
| `⌘ G` / `⌘ ⇧ G` | 下一个 / 上一个匹配 |
| `⌘ ⇧ F` / `Esc` | 结束搜索 |

### 杂项

| 快捷键 | 动作 |
|---|---|
| `⌘ ,` | 打开配置文件 |
| `⌘ ⇧ ,` | 重载配置 |
| `⌘ ⇧ P` | 命令面板 |
| `⌘ K` | 清屏 |
| `⌘ Z` / `⌘ ⇧ T` | 撤销关闭 surface |
| `⌘ ⇧ Z` | 重做 |
| `⌘ ⌥ I` | 切换 inspector（调试） |

### 本仓库自定义（`packages/terminal/ghostty/config`）

| 快捷键 | 动作 |
|---|---|
| `⌘ \`` （全局） | 切换 Quick Terminal（顶部下拉，40% 高，自动隐藏） |

---

## Yazi（文件管理器 TUI）

启动：`yazi`（仓库内别名 / 命令行直接调用）。`F1` 或 `~` 在 yazi 内随时打开帮助。

### 移动光标 / 进出目录

| 按键 | 动作 |
|---|---|
| `k` / `↑` | 上移 |
| `j` / `↓` | 下移 |
| `K` / `J` | 预览面板上 / 下滚 5 行 |
| `h` / `←` | 返回上级目录 |
| `l` / `→` | 进入目录 / 打开文件 |
| `g g` | 跳到顶部 |
| `G` | 跳到底部 |
| `z` | fzf 切换目录 / 文件 |
| `Z` | zoxide 切换目录 |
| `g <Space>` | 交互式目录 / 文件提示 |

### 选择

| 按键 | 动作 |
|---|---|
| `Space` | 切换选中当前文件 |
| `v` | 进入可视模式（选中） |
| `V` | 进入可视模式（取消选中） |
| `⌃ A` | 全选 |
| `⌃ R` | 反选 |
| `Esc` | 取消选中 |

### 文件操作

| 按键 | 动作 |
|---|---|
| `o` / `Enter` | 打开 |
| `O` / `⇧ Enter` | 交互式选 opener 打开 |
| `Tab` | 显示文件信息 |
| `y` | 复制（yank） |
| `x` | 剪切 |
| `p` | 粘贴 |
| `P` | 粘贴并覆盖 |
| `Y` / `X` | 取消 yank |
| `d` | 移到废纸篓 |
| `D` | 永久删除 |
| `a` | 新建文件 / 目录（结尾加 `/` 表目录） |
| `r` | 重命名 |
| `-` | 创建绝对路径软链 |
| `_` | 创建相对路径软链 |
| `⌃ -` | 创建硬链接 |

### 复制路径到剪贴板

| 按键 | 动作 |
|---|---|
| `c c` | 复制完整路径 |
| `c d` | 复制所在目录 |
| `c f` | 复制文件名 |
| `c n` | 复制不带扩展名的文件名 |

### 查找 / 搜索 / 过滤

| 按键 | 动作 |
|---|---|
| `/` | 当前目录向下查找 |
| `?` | 当前目录向上查找 |
| `n` / `N` | 下 / 上一个匹配 |
| `f` | 过滤文件名 |
| `s` | 全局搜索文件名（fd） |
| `S` | 全局搜索内容（ripgrep） |
| `⌃ S` | 取消搜索 |

### 排序（`,` 开头的 chord）

| 按键 | 动作 |
|---|---|
| `, m` / `, M` | 按修改时间 / 反序 |
| `, b` / `, B` | 按创建时间 / 反序 |
| `, e` / `, E` | 按扩展名 / 反序 |
| `, a` / `, A` | 字母序 / 反序 |
| `, n` / `, N` | 自然序 / 反序 |
| `, s` / `, S` | 按大小 / 反序 |
| `, r` | 随机 |

### Tabs

| 按键 | 动作 |
|---|---|
| `t t` | 新 tab |
| `1` … `9` | 切到第 N 个 tab |
| `[` / `]` | 上 / 下一个 tab |
| `{` / `}` | 与上 / 下一个 tab 互换位置 |
| `⌃ C` | 关闭当前 tab |

### 杂项

| 按键 | 动作 |
|---|---|
| `.` | 显示 / 隐藏点文件 |
| `;` | 异步执行 shell 命令 |
| `:` | 阻塞执行 shell 命令 |
| `F1` / `~` | 打开帮助 |
| `q` | 退出 |
| `Q` | 退出，但不切换到当前目录 |

> 想让 yazi 退出后 shell 留在浏览到的最后一个目录？官方推荐的 `y` shell 函数：见
> <https://yazi-rs.github.io/docs/quick-start#shell-wrapper>。

---

## Zoxide（智能目录跳转）

Zoxide 不是 TUI 工具，没有键盘快捷键，**它是一组 shell 命令**。
本仓库已通过 `eval "$(zoxide init zsh)"` 注入 `~/.zshrc`，开新终端即生效。

| 命令 | 动作 |
|---|---|
| `z foo` | 跳到访问历史中匹配 `foo` 的目录（频次×新近度排序） |
| `z foo bar` | 跳到同时匹配 `foo` 和 `bar` 的目录（如 `/code/foo/bar/...`） |
| `z ..` | 等效 `cd ..` |
| `z -` | 回上一个目录（等效 `cd -`） |
| `z ~` | 回 home |
| `zi` | fzf 交互式选目录（输入关键词后回车） |
| `zi foo` | 在匹配 `foo` 的候选里走 fzf 交互选 |
| `zoxide query foo` | 仅查询匹配的目录，不跳转 |
| `zoxide query -l` | 列出所有记录及分数 |
| `zoxide add <path>` | 手动加目录到数据库 |
| `zoxide remove <path>` | 从数据库删除目录 |
| `zoxide edit` | 用 `$EDITOR` 编辑数据库 |

### 配合 yazi

按 `Z`（大写）即可在 yazi 里调起 zoxide，从访问历史跳转，无需打字搜目录。

### 数据存储

默认 `~/.local/share/zoxide/db.zo`，纯本地，不进 git。
要从 `autojump` / `z.sh` / `fasd` 迁移：`zoxide import --from <tool> <path>`。

---

## Claude Code（终端 AI 编码助手）

启动：`claude`（包名 `claude-code`，cask 装，CLI 用）。
按 `/` 看所有斜杠命令，按 `?` 在 transcript 查看器内调出完整快捷键面板。

### 通用控制

| 快捷键 | 动作 |
|---|---|
| `⌃ C` | 取消当前输入 / 生成 |
| `⌃ D` | 退出会话（EOF） |
| `⌃ L` | 重绘屏幕（保留对话） |
| `⌃ O` | 切换 transcript 查看器（展开工具调用 / MCP） |
| `⌃ R` | 反向搜索历史命令（`⌃ S` 切换作用域） |
| `⌃ T` | 切换 task list 显示 |
| `⌃ B` | 把当前 bash / agent 转后台（tmux 用户按两次） |
| `⌃ X ⌃ K` | 杀掉所有后台 subagent（3 秒内按两次确认） |
| `⌃ G` / `⌃ X ⌃ E` | 在 `$EDITOR` 里编辑当前 prompt |
| `Esc` | 打断 Claude（保留已完成的工作） |
| `Esc Esc` | 回滚 / 总结到先前某条消息 |
| `⇧ Tab` | 循环权限模式（default → acceptEdits → plan → …） |
| `⌥ P` | 切换模型（不清空当前 prompt） |
| `⌥ T` | 切换 extended thinking |
| `⌥ O` | 切换 fast mode |
| `↑` / `↓` 或 `⌃ P` / `⌃ N` | 光标 / 历史导航 |
| `← →` | 在权限对话框 / 菜单的 tab 间切换 |
| `⌃ V` / `⌘ V`（iTerm2） | 粘贴剪贴板图片为 `[Image #N]` |

> macOS 上 `⌥ B/F/Y/M/P` 等 Option 键需要先把 Option 设为 Meta：Ghostty / iTerm2 默认已开，
> Apple Terminal 在 设置 → 描述文件 → 键盘 勾「将 Option 键用作 Meta 键」。
> 部分新版（v2.1.132+）`⌥ T` 在 macOS 已无需配置 Meta。

### 文本编辑

| 快捷键 | 动作 |
|---|---|
| `⌃ A` / `⌃ E` | 行首 / 行尾 |
| `⌃ K` | 删除到行尾（可粘贴回来） |
| `⌃ U` | 删除到行首（macOS 的 `⌘ Backspace` 也映到这） |
| `⌃ W` | 删除上一个词 |
| `⌃ Y` | 粘贴 `⌃ K/U/W` 删掉的内容 |
| `⌥ Y`（紧接 `⌃ Y`） | 循环粘贴历史 |
| `⌥ B` / `⌥ F` | 按词左 / 右移光标 |

### 多行输入

| 方式 | 按键 |
|---|---|
| 通用 | `\` + `Enter` |
| 通用 | `⌃ J` |
| Ghostty / iTerm2 / WezTerm / Kitty / Warp 等 | `⇧ Enter` |
| macOS（开 Meta 后） | `⌥ Enter` |
| VS Code / Cursor / Zed | 运行 `/terminal-setup` 装绑定 |

### 前缀字符

| 起始字符 | 含义 |
|---|---|
| `/` | 触发斜杠命令 / skill / plugin / MCP |
| `!` | Shell 模式：直接执行命令，把输出加进对话上下文 |
| `@` | 文件路径自动补全（@-mention 文件） |

### 常用斜杠命令

按 `/` 即可补全，下面是高频项：

| 命令 | 作用 |
|---|---|
| `/help` | 帮助 |
| `/config` | 设置面板（主题、editor mode、prompt 建议等） |
| `/model` | 切换模型 |
| `/clear` | 清空当前会话（历史可 `/resume` 找回） |
| `/resume` | 恢复之前的会话 |
| `/compact` | 主动压缩上下文 |
| `/recap` | 生成会话总结 |
| `/btw <问题>` | 旁路提问，不进对话历史，不占工具 |
| `/agents` | 管理 subagent |
| `/init` | 初始化项目的 `CLAUDE.md` |
| `/review` | review 当前 PR |
| `/permissions` | 查看 / 调权限 |
| `/hooks` | 配置 hook（事件驱动自动行为） |
| `/mcp` | 管理 MCP server |
| `/memory` | 编辑长期记忆 |
| `/status` | 查看 token / 成本 / 模型状态 |
| `/cost` | 查看本次 / 历史消耗 |
| `/add-dir <path>` | 把目录加入工作区 |
| `/terminal-setup` | 给当前终端装 `⇧ Enter` 多行绑定 |
| `/vim` | 切换 vim 编辑模式（也可在 `/config` 里改） |
| `/export` | 导出本次会话 |
| `/bug` | 报告 bug |

### Transcript 查看器（`⌃ O` 进入）

| 按键 | 动作 |
|---|---|
| `?` | 显示完整快捷键面板（需 fullscreen 模式） |
| `{` / `}` | 跳到上 / 下一条用户 prompt（vim 段落动作） |
| `⌃ E` | 切换显示所有内容 |
| `[` | 把全对话写入终端原生 scrollback（`⌘ F` / tmux copy 可搜） |
| `v` | 写入临时文件用 `$VISUAL` / `$EDITOR` 打开 |
| `q` / `⌃ C` / `Esc` | 退出 transcript |

### Vim 编辑模式（`/config` → Editor mode 启用）

NORMAL 模式核心动作：`h j k l` 移动 / `w e b` 词跳转 / `0 ^ $` 行首尾 /
`gg G` 文首尾 / `f F t T` 字符跳转 / `; ,` 重复 / `i I a A o O` 进入 INSERT /
`v V` 进入 VISUAL / `dd D dw cc C cw yy yw p P` 编辑 / `u .` 撤销与重复 /
`>> <<` 缩进 / 文本对象 `iw aw i" a" i( a( i[ a[ i{ a{` 与算子组合。
块选 `⌃ V` **不支持**。

> 完整快捷键：<https://docs.claude.com/en/docs/claude-code/interactive-mode>
