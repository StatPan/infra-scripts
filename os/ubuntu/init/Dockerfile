# 베이스 이미지로 Ubuntu를 사용
FROM ubuntu:20.04

# 환경 변수 설정
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /usr/local/bin:$PATH

# 필요한 패키지를 업데이트하고 설치
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    git curl wget vim build-essential software-properties-common locales \
    openssh-server \
    zsh \
    screen \
    zip unzip \
    htop tree jq \
    postgresql postgresql-contrib \
    redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Node.js LTS 설치
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Rust 설치
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Miniconda 설치
RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    eval "$($HOME/miniconda/bin/conda shell.bash hook)" && \
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.zshrc

# Oh My Zsh 설치
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 로케일 설정
RUN locale-gen en_US.UTF-8 ko_KR.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_CTYPE=ko_KR.UTF-8

# PostgreSQL 및 Redis 설정
RUN service postgresql start && \
    service redis-server start

# 기본 셸을 zsh로 설정
CMD ["zsh"]

# 기본 작업 디렉토리 설정
WORKDIR /root

# README 파일 복사
COPY README.md /root/README.md
COPY README_ko.md /root/README_ko.md

# 포트 설정
EXPOSE 5432 6379 22
