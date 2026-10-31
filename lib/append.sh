#!/bin/bash
#
# append lines to file

append() {
  local line=$1 file=$2

  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

sudo_append() {
  local line=$1 file=$2
  grep -qxF "$line" "$file" || sudo sh -c "echo '$line' >> '$file'"

}

# 追加一组带注释的行：只有当其中有行缺失时才写入，注释随之写一次
# 已有的行不会重复，注释也不会在命令都存在时孤零零地被加上
append_block() {
  local file=$1 comment=$2 line missing=()
  shift 2

  for line in "$@"; do
    grep -qxF "$line" "$file" 2>/dev/null || missing+=("$line")
  done
  [ ${#missing[@]} -eq 0 ] && return 0

  {
    echo ""
    echo "$comment"
    printf '%s\n' "${missing[@]}"
  } >> "$file"
}
