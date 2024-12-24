#!/bin/sh
#
# 安卓 相关设置

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# java 版本
# export PATH="${HOMEBREW_PREFIX}/opt/openjdk/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home)"

## android
export ANDROID_NDK_HOME="/opt/homebrew/share/android-ndk"
## /Users/zzs/Library/Android/sdk