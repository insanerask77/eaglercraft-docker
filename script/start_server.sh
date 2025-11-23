#!/bin/bash

# eula设置
echo -e "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).\n#`date`\neula=true" > /eaglerX-1.8-server/server/eula.txt

# 启动 tmux 会话
tmux new-session -d -s mcserver
# 创建左右分屏
tmux split-window -h
# 在第一个窗格中运行 ls 命令
tmux send-keys -t mcserver:0.0 'cd /eaglerX-1.8-server/bungee/;./run.sh' C-m
# 在第二个窗格中运行 pwd 命令
tmux send-keys -t mcserver:0.1 'cd /eaglerX-1.8-server/server/;./run.sh' C-m

# 运行http_server服务器,避免原生的用不了
cd /eaglerX-1.8-server/web;python3 /eaglerX-1.8-server/script/http_server.py

# 保持脚本运行，不退出
tail -f /dev/null
