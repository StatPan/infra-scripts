#!/bin/bash

# 업데이트 및 기본 도구 설치
apt update -y
apt upgrade -y
apt install -y git curl wget vim build-essential software-properties-common

# OpenSSH 설치
apt install -y openssh-server

# 최신 Node.js LTS 설치
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# Rust 설치
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Zsh 및 Oh My Zsh 설치
apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# screen 설치
apt install -y screen

# zip 및 unzip 설치
apt install -y zip unzip

# 기타 유용한 도구 설치
apt install -y htop tree jq

apt install -y sudo

# locale 설정
apt install -y locales
locale-gen en_US.UTF-8 ko_KR.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=ko_KR.UTF-8

# Miniconda 설치
cd /tmp
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

# Conda 초기화 및 PATH에 추가
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.zshrc

# PostgreSQL 설치
apt install -y postgresql postgresql-contrib

# Redis 설치
apt install -y redis-server

# 설정 완료 메시지
echo "********** install completed **********"
