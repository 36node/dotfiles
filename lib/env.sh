#!/bin/bash
#
# 加载 .env 风格的文件（bash / zsh 通用，install.sh 与 source.zsh 共用）
#
# 规则：
#   - 空行、# 开头的注释行跳过
#   - 允许可选的 `export ` 前缀
#   - KEY=VALUE 按第一个 = 切分，KEY 必须是合法变量名，否则跳过该行
#   - VALUE 以 " 或 ' 开头时取到对应的闭合引号为止，内容原样保留（可含空格、#），
#     闭合引号之后的内容（行尾注释等）忽略；没有闭合引号则按未加引号处理
#   - 未加引号的 VALUE：空白后跟 # 视为行尾注释（FOO=bar # note → bar），
#     紧贴的 # 保留（URL=http://x/#a、PASS=a#b 不受影响），两端空白去掉
#   - 不做变量展开、不执行命令
#
# 局部变量统一加 __le_ 前缀，避免 .env 里的 key / value 之类变量名被函数局部变量吞掉

load_env() {
  local __le_file=$1 __le_line __le_key __le_value __le_rest
  [ -f "$__le_file" ] || return 0

  while IFS= read -r __le_line || [ -n "$__le_line" ]; do
    __le_line=${__le_line%$'\r'}
    __le_line=${__le_line#"${__le_line%%[![:space:]]*}"}
    case "$__le_line" in
      ''|'#'*) continue ;;
    esac
    __le_line=${__le_line#export }
    case "$__le_line" in
      *=*) ;;
      *) continue ;;
    esac

    __le_key=${__le_line%%=*}
    __le_value=${__le_line#*=}
    case "$__le_key" in
      ''|[0-9]*|*[!A-Za-z0-9_]*) continue ;;
    esac

    __le_value=${__le_value#"${__le_value%%[![:space:]]*}"}
    case "$__le_value" in
      \"*\"*)
        __le_rest=${__le_value#\"}
        __le_value=${__le_rest%%\"*}
        ;;
      \'*\'*)
        __le_rest=${__le_value#\'}
        __le_value=${__le_rest%%\'*}
        ;;
      *)
        __le_value=${__le_value%%[[:space:]]\#*}
        __le_value=${__le_value%"${__le_value##*[![:space:]]}"}
        ;;
    esac

    export "$__le_key=$__le_value"
  done < "$__le_file"
}
