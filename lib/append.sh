#!/bin/sh
#
# append lines to file

append() {
  local line=$1 file=$2
  grep -qxF "$1" "$2" || echo "$1" >> "$2"
}