#!/bin/bash

apt install -y sudo

# 업데이트 및 기본 도구 설치
apt update -y
apt upgrade -y
apt install -y git curl wget vim build-essential software-properties-common \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
tk-dev liblzma-dev

# OpenSSH 설치
apt install -y openssh-server

# Zsh 및 Oh My Zsh 설치
# apt install -y zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# screen 설치
apt install -y screen

# zip 및 unzip 설치
apt install -y zip unzip

# 기타 유용한 도구 설치
apt install -y htop tree jq


# locale 설정
apt install -y locales
locale-gen en_US.UTF-8 ko_KR.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=ko_KR.UTF-8

# nvm 최신 버전 설치
export NVM_DIR="$HOME/.nvm"
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
mkdir -p $NVM_DIR
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


# pyenv 최신 버전 설치
curl https://pyenv.run | bash
echo 'export PATH=$PATH:$HOME/.pyenv/bin' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

# 설정 완료 메시지
echo "********** install completed **********"

echo "If you need to create user"
echo "adduser {username}"
echo "usermod -aG sudo {username}"
