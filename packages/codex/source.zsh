# 若环境里残留 OPENAI_BASE_URL（例如曾指向中转），启动时去掉，避免 CLI 被带走
codex() {
  env -u OPENAI_BASE_URL command codex "$@"
}

alias cx='codex --dangerously-bypass-approvals-and-sandbox'
