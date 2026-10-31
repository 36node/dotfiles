#!/bin/bash
#
# link dotfiles

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    ## 已经是指向 src 的正确软链：无论是否带 -o/-b/-s 都直接跳过
    ## （否则 -b 重跑会把正确的链接当成冲突备份，目录软链甚至会被 mv 进自身形成自环）
    local currentSrc="$(readlink "$dst")"

    if [ "$currentSrc" == "$src" ]
    then

      skip=true; overwrite=false; backup=false;

    elif [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      ask "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
      [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

      case "$action" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    if ln -s "$1" "$2"; then
      success "linked $1 to $2"
    else
      warn "未能链接 $1 到 $2"
      return 1
    fi
  fi
}

## 先拷贝后建立链接
sync_file () {
  local src=$1 dst=$2

  ## 如果 src 不存在，而 dst 存在的话，先备份
  if [ ! -e "$src" ] && [ -e "$dst" ]; then
    mv "$dst" "$src"
  fi

  link_file "$src" "$dst"
}