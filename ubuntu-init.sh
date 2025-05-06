#!/bin/bash

# =========================
# 🚀 Step 1: 초기 설정 (Root에서 실행)
# =========================

# 실행 시 첫 번째 인자를 유저명으로 사용
USERNAME=${1:-"ubuntu"}

echo "🔹 Updating system and installing essential packages..."

# 기본 패키지 및 sudo 설치
apt update -y
apt install -y sudo

# 필수 패키지 설치
apt install -y git curl wget vim build-essential software-properties-common \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
tk-dev liblzma-dev htop tree jq screen zip unzip locales openssh-server nginx

# Locale 설정
locale-gen en_US.UTF-8 ko_KR.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=ko_KR.UTF-8

echo "✅ Step 1: 필수 패키지 설치 완료"

# =========================
# 👤 Step 2: 유저 생성 및 권한 부여
# =========================

# 유저 존재 여부 확인 후 생성
if id "$USERNAME" &>/dev/null; then
    echo "🔹 User $USERNAME already exists."
else
    echo "🔹 Creating user: $USERNAME"
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
fi

echo "✅ Step 2: User $USERNAME setup completed."

# =========================
# 🚀 Step 3: 개발 환경 설치 (ubuntu 유저로 실행)
# =========================

echo "🔹 Switching to user $USERNAME for development environment setup..."

# 실행할 명령어를 임시 스크립트로 생성
DEV_SETUP_SCRIPT="/home/$USERNAME/install_dev_env.sh"

cat << 'EOF' > "$DEV_SETUP_SCRIPT"
#!/bin/bash

echo "🚀 Starting development environment setup..."

# 환경 변수 설정
export HOME="/home/$USER"
export NVM_DIR="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# **Step 3-1: Node.js (NVM) 설치**
if [ ! -d "$NVM_DIR" ]; then
    echo "🔹 Installing NVM"
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
fi
nvm install --lts
nvm use --lts
echo "✅ Node.js $(node -v) installed."

# **Step 3-2: Python (uv) 설치**
echo "🔹 Installing Python with uv"

# Try installing uv using curl first.
if curl -LsSf https://astral.sh/uv/install.sh | sh; then
  echo "uv installed successfully using curl."
else
  # If curl fails, try wget.
  if wget -qO- https://astral.sh/uv/install.sh | sh; then
    echo "uv installed successfully using wget."
  else
    # If both curl and wget fail, print an error message.
    echo "Error: Failed to install uv. Both curl and wget failed or the installation script had an error." >&2
    exit 1
  fi
fi

# Add uv to PATH for this session
export PATH="$HOME/.cargo/bin:$PATH"

# Install latest python
echo "🔹 Installing latest Python version"
uv python install

# Install specific versions if needed
# uv python install 3.11 3.12

# Find the latest Python installed by uv
python_path=$(uv python find 2>/dev/null)

# Check if uv found a Python installation
if [ -z "$python_path" ]; then
  echo "Error: No Python installation found by 'uv python find'." >&2
  exit 1
fi

# Check if the path is actually a file
if [ ! -f "$python_path" ]; then
    echo "Error: Path found by 'uv python find' is not a file: $python_path" >&2
    exit 1
fi

# Get the user's shell
shell=$(echo "$SHELL")

# Determine the correct configuration file based on the shell
if [[ "$shell" == *bash ]]; then
  config_file="$HOME/.bashrc"
elif [[ "$shell" == *zsh ]]; then
  config_file="$HOME/.zshrc"
else
  echo "Warning: Unsupported shell: $shell. Using .bashrc as default." >&2
  config_file="$HOME/.bashrc"
fi

# Add uv to PATH permanently
if ! grep -q "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" "$config_file"; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$config_file"
    echo "Added uv to PATH in $config_file"
fi

# Setup Python project management instructions
echo "# uv Python 관리 도구" >> "$config_file"
echo '# 가상환경 생성: uv venv [경로] (기본값: .venv)' >> "$config_file"
echo '# 가상환경 활성화: source .venv/bin/activate 또는 .venv\Scripts\activate' >> "$config_file"
echo '# 패키지 설치: uv pip install [패키지명]' >> "$config_file" 
echo '# requirements.txt 설치: uv pip sync requirements.txt' >> "$config_file"

echo "✅ Python 설정 완료. 변경사항을 적용하려면 '$config_file'를 불러오거나 새 터미널을 여세요."

# **Step 3-3: Rust 설치**
if [ ! -d "$HOME/.cargo" ]; then
    echo "🔹 Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
echo "✅ Rust $(rustc --version) installed."

# **Step 3-4: TypeScript 패키지 설치**
echo "🔹 Installing latest create-tsready package"
npm install -g create-tsready
echo "✅ TypeScript package create-tsready installed."

echo "🎉 Development environment setup completed!"
EOF

# 파일 권한 설정 후 유저로 실행
chown "$USERNAME":"$USERNAME" "$DEV_SETUP_SCRIPT"
chmod +x "$DEV_SETUP_SCRIPT"
sudo -u "$USERNAME" bash "$DEV_SETUP_SCRIPT"

# VS Code extensions 설치
echo "🔹 Installing VS Code extensions..."
wget -qO- https://raw.githubusercontent.com/StatPan/vscode-extension-install/refs/heads/master/all.sh | bash
echo "✅ VS Code extensions 설치 완료!"

echo "🎉 All installations completed successfully!"
