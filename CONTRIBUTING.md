# 贡献指南

感谢你愿意为 `36node/dotfiles` 出力。这份文档说明本仓库的协作约定，帮助你的修改尽快被合并。

阅读本文前，请先阅读 [行为准则](CODE_OF_CONDUCT.md)。

## 目录

- [快速上手](#快速上手)
- [仓库设计原则](#仓库设计原则)
- [代码风格](#代码风格)
- [新增 package](#新增-package)
- [提交 commit 与 PR](#提交-commit-与-pr)
- [报告 issue](#报告-issue)

## 快速上手

```bash
# 1. fork 仓库到自己账号下
# 2. clone 你的 fork
git clone git@github.com:<你的用户名>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. 在新分支上做修改
git checkout -b feat/<你的特性>

# 4. 反复执行 ./install.sh 验证幂等性
./install.sh
./install.sh   # 第二次必须无副作用

# 5. 提交并推到你的 fork，再发 PR
git push origin feat/<你的特性>
```

## 仓库设计原则

提交 PR 前，请确认你的改动符合以下原则。这些原则是本仓库 6 年迭代后沉淀下来的：

1. **模块化** —— 一个 package 解决一个主题（如 `terminal`、`node`、`python`），不交叉依赖
2. **幂等** —— 所有写文件操作必须可重复执行：
   - 写 `~/.zshrc` 用 `lib/append.sh` 的 `append`
   - 建软链用 `lib/link.sh` 的 `link_file` / `sync_file`
   - 安装 brew 包用 `lib/brew.sh` 的 `brew_install` / `brew_cask_install`
3. **可读** —— 每个 `install.sh` 控制在 ~50 行，复杂的拆函数 / 拆文件
4. **现代化** —— 引入新工具时，优先选择**仍在快速迭代**的项目；过时工具应该被替换、不是堆积
5. **诚实的注释** —— 每段配置上方用中文说清「为什么这么做」，不只说「做了什么」

## 代码风格

### Shell

- shebang 统一用 `#!/bin/bash`
- 文件用 LF 换行，UTF-8 编码
- 缩进 2 空格
- 用双引号包裹变量：`"${COMPUTER_NAME}"`，避免空格问题
- 在写敏感数据相关代码时，写明白潜在风险（参考 `lib/icloud.sh` 的注释）

### Markdown

- 标题层级最多到 H3
- 代码块标语言（` ```bash ` / ` ```sh ` / ` ```toml `）
- 中英混排时，中英文之间不强制空格，但应保持单文件内一致

### 文件命名

- 各 package 主入口：`packages/<name>/install.sh`
- 各 package shell 集成：`packages/<name>/source.zsh`（被根 `source.zsh` 自动加载）
- 各 package 文档：`packages/<name>/README.md`（可选，复杂 package 推荐有）

## 新增 package

新加一个 package 的最小骨架：

```
packages/<name>/
├── install.sh          # 必需，主脚本会自动执行
├── source.zsh          # 可选，shell 启动时自动加载
└── README.md           # 可选但推荐
```

**`install.sh` 模板**：

```bash
#!/bin/bash
#
# <name> 相关安装

## 工具一
brew_install <tool>

## 工具二（可执行的初始化）
brew_install <tool>
<tool> init  # 注意幂等
```

**关键约束**：

- 不要假设当前工作目录 —— 主脚本通过 `. "$package/install.sh"` 加载，`$PWD` 仍是仓库根
- 引用本 package 内文件时用 `$PWD/packages/<name>/...`
- 写 `.zshrc` 用 `append`，不要直接 `echo >> ~/.zshrc`
- 写软链用 `link_file`，不要直接 `ln -s`

## 提交 commit 与 PR

### Commit message

遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/)：

```
<type>(<scope>): <subject>

[optional body]
```

常用 type：

- `feat` —— 新功能（新 package、新工具）
- `fix` —— bug 修复
- `chore` —— 维护性改动（升级版本号、清理死代码）
- `docs` —— 仅文档变更
- `refactor` —— 不改变行为的代码重构

scope 通常是 package 名，如 `feat(terminal): switch to ghostty`、`fix(node): correct fnm init order`。

### PR 要求

1. **一个 PR 一件事** —— 不要把"加 package + 重构 lib + 修文档"塞一起
2. **PR 描述** —— 说明动机（为什么要这个改动）、做了什么、是否破坏兼容性
3. **自测** —— 在干净的 macOS（或者反复跑 `./install.sh`）上验证过
4. **README 同步** —— 改动会影响安装结果时，更新 `README.md` 和（如果有）package 自己的 `README.md`
5. **保持向后兼容** —— 已发布配置（`.env.example`、`zsh_plugins.txt` 等）的字段命名只增不删；如果必须破坏兼容，在 PR 里说明迁移步骤

## 报告 issue

发现 bug 或想提需求，欢迎开 issue。请尽量包含：

- macOS 版本（`sw_vers -productVersion`）
- 芯片（`uname -m`）
- 复现步骤
- 实际表现 vs 期望表现
- 错误日志（如有）

---

不确定改动是否合适？**先开 issue 讨论再写代码** 是最稳的做法。
