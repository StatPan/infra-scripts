# 개발 환경 설정

[en](README.md) | [ko](README_ko.md)

이 스크립트는 Ubuntu 시스템에서 개발 환경을 설정합니다. 필수 프로그래밍 언어, 도구 및 데이터베이스를 설치하여 종합적인 개발 환경을 제공합니다.

## 기능

- 시스템 업데이트 및 업그레이드
- 필수 도구 설치: git, curl, wget, vim, build-essential, software-properties-common
- OpenSSH 서버 설정
- 최신 Node.js LTS 설치
- Rust 프로그래밍 언어 설치
- Zsh 및 Oh My Zsh 설치
- 터미널 멀티플렉서를 위한 screen 설치
- zip 및 unzip 유틸리티 설치
- 유용한 도구 설치: htop, tree, jq
- 터미널에서 영어(UTF-8) 및 한국어(UTF-8)를 지원하도록 locale 설정
- Python 환경 관리를 위한 Miniconda 설치
- PostgreSQL 데이터베이스 설치
- Redis 데이터베이스 설치

## 사용법

1. 스크립트를 `setup_dev_env.sh`로 저장합니다.
2. 스크립트가 있는 디렉토리로 이동합니다.
3. 스크립트에 실행 권한을 부여합니다:
    ```sh
    chmod +x setup_dev_env.sh
    ```
4. 스크립트를 실행합니다:
    ```sh
    ./setup_dev_env.sh
    ```

## 언어 설치

노드 lts 설치
```bash
nvm install --lts
```

파이썬 특정 버전 설치
```bash
pyenv install {version_number}
# ex: pyenv install 3.10.14
```

러스트 stable version 설치
```bash
rustup install stable
```    

## Locale 설정

이 스크립트는 터미널에서 영어와 한국어를 모두 지원하도록 locale을 설정합니다. `LANG`은 `en_US.UTF-8`로, `LC_CTYPE`은 `ko_KR.UTF-8`로 설정됩니다.

## Miniconda

Miniconda는 Python 환경 관리를 위해 설치됩니다. 스크립트는 Conda가 초기화되고 bash 및 zsh 셸 모두에서 `PATH`에 추가되도록 설정합니다.

## PostgreSQL

강력하고 오픈 소스인 객체 관계형 데이터베이스 시스템인 PostgreSQL이 설치되어 사용할 준비가 됩니다.

## Redis

고성능 작업을 위해 인메모리 데이터 구조 저장소인 Redis가 설치됩니다.

---

이 README의 한국어 버전을 보려면 [여기](README_ko.md)를 클릭하세요.

## Install script
```bash
sudo -E ./{install_file_name}.sh
```