#!/bin/sh
#
# DevOps 相关软件安装

###############################################################################
# 安装一些必备软件
###############################################################################

brew_install aliyun-cli       # 阿里云
brew_install ansible
brew_install helm
brew_install k3sup
brew_install kafkacat         # kafka 消费者
brew_install kubectx
brew_install kubernetes-cli
brew_install hidetatz/tap/kubecolor

brew_cask_install docker