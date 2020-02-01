# ## nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

## 删除 nvm 往 zshrc 添加的代码
sed -i '' '/export[[:blank:]]NVM_DIR/,$d' $PWD/.zshrc
sed -i '' '$d' $PWD/.zshrc