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
USERNAME=${1:-"ubuntu"}

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
export HOME="/home/ubuntu"
export USER="ubuntu"
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

# **Step 3-2: Python (pyenv) 설치**
if ! command -v pyenv &> /dev/null; then
    echo "🔹 Installing pyenv"
    curl https://pyenv.run | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/.bashrc
    echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc
    echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
LATEST_PYTHON=$(pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
pyenv install -s "$LATEST_PYTHON"
pyenv global "$LATEST_PYTHON"
echo "✅ Python $(python --version) installed."

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


# PostgreSQL 설치 (이미 설치되어 있는지 확인 후 설치)
if ! command -v psql &> /dev/null; then
    echo "🔹 Installing PostgreSQL..."
    apt install -y postgresql-common
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

    apt install -y curl ca-certificates
    install -d /usr/share/postgresql-common/pgdg
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    
    apt update
    apt -y install postgresql
else
    echo "✅ PostgreSQL is already installed."
fi

# PostgreSQL 시작
echo "🔹 Starting PostgreSQL..."
service postgresql start

#!/bin/bash

# ==========================
# 🚀 PostgreSQL 초기 설정
# ==========================

# 환경 변수 설정 (없으면 기본값 사용)
DB_USER=${DB_USER:-"postgres_user"}
DB_PASSWORD=${DB_PASSWORD:-"securepassword"}
DB_NAME=${DB_NAME:-"postgres_db"}

# PostgreSQL 접속 정보 (없으면 기본값 사용)
PGHOST=${PGHOST:-"localhost"}
PGPORT=${PGPORT:-"5432"}
PGADMIN_USER=${PGADMIN_USER:-"postgres"}
PGADMIN_PASSWORD=${PGADMIN_PASSWORD:-"adminpassword"}

# PostgreSQL 접속 비밀번호 설정
export PGPASSWORD=$PGADMIN_PASSWORD

echo "🔹 Creating user and database in PostgreSQL..."

# 사용자 생성 및 비밀번호 설정 (존재하면 무시)
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -tc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER';" | grep -q 1 || \
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"

# 데이터베이스 생성 (존재하면 무시)
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -tc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';" | grep -q 1 || \
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"

# 권한 부여
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# ==========================
# 🔹 pg_hba.conf 설정 변경
# ==========================

PG_HBA_CONF=$(find /etc/postgresql -name pg_hba.conf)

if [ -f "$PG_HBA_CONF" ]; then
    echo "🔹 Updating pg_hba.conf..."
    echo "host    all             all             0.0.0.0/0               md5" >> "$PG_HBA_CONF"
    
    # PostgreSQL 재시작
    sudo service postgresql restart
    echo "✅ PostgreSQL configuration updated and restarted."
else
    echo "⚠️ pg_hba.conf not found. Skipping configuration update."
fi

echo "✅ PostgreSQL setup completed! User: $DB_USER, Database: $DB_NAME"


echo "🎉 All installations completed successfully!"
