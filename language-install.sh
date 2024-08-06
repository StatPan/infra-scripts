
# 최신 lts node 설치 
nvm install --lts

# 파이썬 설치
pyenv install 3.10.14

#tsready package 설치
npm install -g create-tsready

# golang 설치
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
sudo -E tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc


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

echo "***** node, conda, rust install completed *****"
