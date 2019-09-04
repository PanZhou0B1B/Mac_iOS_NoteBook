## 一、目标
* 在没有远程Git服务器的情况下，又需要多人协作开发项目。我们可以临时使用自己的Mac电脑搭建简易Git服务器。
* 使用本电脑新账户作为Git服务器，并不能保证数据安全问题，所以只是权宜之计。

## 二、创建Git服务器
### server端（即Mac）建立新账户，始终后台开启。

1. 新建Giter账户
2. $ sudo chmod u+w /etc/sudoers
3. $ sudo vi /etc/sudoers

	> 找到这一行 "root ALL=(ALL) ALL"，在下面添加 "AccountName ALL=(ALL) ALL" (这里是 git ALL=(ALL) ALL)并保存。
	

## 三、Git仓库建立及关联

### client端(设置访问Git服务器的权限用户，设置一次即可)
1. $ ssh git@yourComputerName.local mkdir .ssh　　# 登陆 server 并创建 .ssh 文件夹
2. $ scp ~/.ssh/id_rsa.pub giter@pan.local:.ssh/authorized_keys

	> cat ~/.ssh/id_rsa.pub

### 远程server：远程仓库建立

1. $ su Giter
2. cd desktop
3. mkdir git_repo.git
4. cd git_repo.git
4. git init --bare

### 本地仓库建立及关联远程仓库
 
 1. $ mkdir file
 2. $ git init
 3. $ git add .
 4. $ git commit -m "init"
 5. $ git remote add origin Giter@pan.local:/Users/giter/Desktop/git_repo.git 
 6. git push 

 
## 四、其它

1. 设置中远程登录设为enable


1. 去除.git链接仓库

	> find . -name ".git" | xargs rm -Rf

2. 获取本地RSA子串：

	> cat ~/.ssh/id_rsa.pub
	>
	> 生成：ssh-keygen -t rsa