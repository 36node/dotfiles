#!/bin/sh
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