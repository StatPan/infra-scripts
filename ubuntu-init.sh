#!/bin/bash

# =========================
# 🚀 Step 1: 초기 설정 (Root에서 실행)
# =========================

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

# 유저명을 환경변수로 설정 (없으면 기본값: ubuntu)
USERNAME=${USERNAME:-"ubuntu"}

# 또는 실행 시 인자로 받을 경우:
read -p "Enter username (default: ubuntu): " USER_INPUT
USERNAME=${USER_INPUT:-"ubuntu"}

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
export HOME="/home/$USERNAME"
export USER="$USERNAME"
export NVM_DIR="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# **Step 3-1: Node.js (NVM) 설치**
if [ ! -d "$NVM_DIR" ]; then
    echo "🔹 Installing NVM"
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
fi
nvm install --lts
nvm use --lts
echo "✅ Node.js $(node -v) installed."

# **Step 3-2: Python (uv) 설치**

# Try installing uv using curl first.
if curl -LsSf https://astral.sh/uv/install.sh | sh; then
  echo "uv installed successfully using curl."
  exit 0  # Exit successfully if curl worked.
fi

# If curl fails (command not found or other error), try wget.
if wget -qO- https://astral.sh/uv/install.sh | sh; then
  echo "uv installed successfully using wget."
  exit 0  # Exit successfully if wget worked.
fi

# If both curl and wget fail, print an error message.
echo "Error: Failed to install uv.  Both curl and wget failed or the installation script had an error." >&2  # Redirect to stderr
exit 1  # Exit with an error code.

# install lastest python
uv
uv python install

# Find the latest Python installed by uv
python_path=$(uv python find 2>/dev/null)

# Check if uv found a Python installation
if [ -z "$python_path" ]; then
  echo "Error: No Python installation found by 'uv python find'." >&2
  exit 1
fi

# Check if the path is actually a file.  This avoids a subtle error.
if [ ! -f "$python_path" ]; then
    echo "Error: Path found by 'uv python find' is not a file: $python_path" >&2
    exit 1
fi

# Get the user's shell.
shell=$(echo "$SHELL")

# Determine the correct configuration file based on the shell.
if [[ "$shell" == *bash ]]; then
  config_file="$HOME/.bashrc"
elif [[ "$shell" == *zsh ]]; then
  config_file="$HOME/.zshrc"
else
  echo "Error: Unsupported shell: $shell.  This script supports bash and zsh." >&2
  exit 1
fi

# Create the alias strings.
alias_python="alias python='$python_path'"
alias_python3="alias python3='$python_path'"

# Check if the aliases already exist.  Avoid adding duplicates.
if grep -q "$alias_python" "$config_file"; then
    echo "Alias for 'python' already exists in $config_file."
else
    # Add the aliases to the configuration file.
    echo "$alias_python" >> "$config_file"
    echo "Added alias for 'python' to $config_file"
fi

if grep -q "$alias_python3" "$config_file"; then
     echo "Alias for 'python3' already exists in $config_file"
else
    echo "$alias_python3" >> "$config_file"
    echo "Added alias for 'python3' to $config_file"
fi


# Inform the user to source the configuration file or open a new terminal.
echo "Please source your configuration file (e.g., 'source $config_file') or open a new terminal to apply the changes."

exit 0


# **Step 3-3: Rust 설치**
if [ ! -d "$HOME/.cargo" ]; then
    echo "🔹 Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
echo "✅ Rust $(rustc --version) installed."

# **Step 3-4: Golang 설치**
echo "🔹 Installing latest Go"
GO_LATEST=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
wget "https://go.dev/dl/${GO_LATEST}.linux-amd64.tar.gz"
sudo -E tar -C /usr/local -xzf "${GO_LATEST}.linux-amd64.tar.gz"
rm "${GO_LATEST}.linux-amd64.tar.gz"
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
source $HOME/.bashrc
echo "✅ Go $(go version) installed."

# **Step 3-5: TypeScript 패키지 설치**
echo "🔹 Installing latest create-tsready package"
npm install -g create-tsready
echo "✅ TypeScript package create-tsready installed."

echo "🎉 Development environment setup completed!"
EOF

# 파일 권한 설정 후 `ubuntu` 유저로 실행
chown "$USERNAME":"$USERNAME" "$DEV_SETUP_SCRIPT"
chmod +x "$DEV_SETUP_SCRIPT"
sudo -u "$USERNAME" bash "$DEV_SETUP_SCRIPT"

# VS Code extensions 설치
echo "🔹 Installing VS Code extensions..."
wget -qO- https://raw.githubusercontent.com/StatPan/vscode-extension-install/refs/heads/master/all.sh | bash
echo "✅ VS Code extensions 설치 완료!"

echo "🎉 All installations completed successfully!"
