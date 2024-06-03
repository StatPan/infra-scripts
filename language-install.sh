# Node.js 설치
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# 최신 lts node 설치 
nvm install --lts

# Rust 설치
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Miniconda 설치
cd /tmp
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

# Conda 초기화 및 PATH에 추가
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.zshrc