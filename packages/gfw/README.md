# GFW

网络通畅相关，google 等必须

```sh
./install.sh
```

github git 协议可以配置 ~/.ssh/config，需要手动配置

```sh
## Github
Host github.com
	HostName github.com
	User git
		ProxyCommand nc -v -x 127.0.0.1:1086 %h %p"
```