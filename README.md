# EaglercraftX Server
- fork from https://github.com/burgerhugger/ALL-server
## Credits
eaglercraft and eaglercraftx: lax1dude (calder young)
<br>
eaglercraft server: ayunami2000
<br>
## Setup Guide
Welcome to the EaglercraftX server project! Here is how you can setup your very own eaglercraft server:
<br>
<br>
First, go to the top of the repo and click on code > codespaces > create codespace
<br>
now you have your own free server instance to host eaglercraft. Next you need to run the setup commands:
<br>
<br>
create 2 terminal tabs and paste in the following snipits:
<br>
<br>
first tab: `cd server && sudo java -jar server.jar`
<br>
<br>
second tab: `cd bungee && sudo java -jar bungee.jar`
<br>
<br>
Now go to the ports area and forward (and make public) ports `25565` and `8081`
<br>
Your eaglercraft server is setup!
---
# 教程参考 https://www.cnblogs.com/chenxuan520/p/18212461 重要
# 视频教程 [最简单的MC我的世界网页版联机服务器搭建\_我的世界](https://www.bilibili.com/video/BV1ey411q7mf/)
# 注意点
1. server文件夹的plugins目录可以直接删除,避免登录需要密码的问题
2. 1.5 的文件直接迁移个人的数据会消失,其他地图数据不会改变 
3. 最好用tmux进行分屏处理,server段应该用的是paper,部署流程参考上面的步骤,**访问端口是8081而不是1.5的25565**,部署的时候先启动 bungee 再启动 server,顺序不能错
---
# 我修改的特性
1. 默认5200端口(改端口查`bungee/plugins/EaglercraftXBungee/listeners.yml`的配置文件)
2. 下载好需要下载的东西无需下载
3. 封装成为docker直接使用方便 `docker pull registry.cn-hangzhou.aliyuncs.com/chenxuan/eaglerx1.8server:1.8.1`,然后run,把5200端口暴露就可以了,直接访问5200端口如果不能加载静态文件的话(取决于加载速度是否够快),暴露5201端口出来然后访问5201端口也可以
