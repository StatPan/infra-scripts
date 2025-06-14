#!/bin/bash
set -e

# -----------------------------
# Go 설치 스크립트 (공식 방식 준수)
# 사용법: ./install.sh [go버전] (예: go1.22.4, 없으면 latest)
# -----------------------------


GO_VERSION=${1:-"latest"}

# 플랫폼 감지
UNAME_OS=$(uname -s)
UNAME_ARCH=$(uname -m)

case "$UNAME_OS" in
  Linux*)   GO_OS="linux" ;;
  Darwin*)  GO_OS="darwin" ;;
  MINGW*|MSYS*|CYGWIN*) GO_OS="windows" ;;
  *)        echo "❌ 지원되지 않는 OS: $UNAME_OS"; exit 1 ;;
esac

case "$UNAME_ARCH" in
  x86_64|amd64)   GO_ARCH="amd64" ;;
  arm64|aarch64)  GO_ARCH="arm64" ;;
  *)              echo "❌ 지원되지 않는 아키텍처: $UNAME_ARCH"; exit 1 ;;
esac

# 기존 Go 설치 여부 확인
if command -v go &> /dev/null; then
  INSTALLED_VERSION=$(go version | awk '{print $3}')
  echo "⚠️  이미 설치된 Go 버전: $INSTALLED_VERSION"
  read -p "↪️  다시 설치하시겠습니까? (y/N): " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "⏹️  설치 취소됨."
    exit 0
  fi
fi


## 버전 결정 및 검증
if [[ "$GO_VERSION" == "latest" ]]; then
  # 최신 버전 추출 (정확히 버전 문자열만)
  GO_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o '"version": *"go[0-9.]*"' | head -n1 | sed 's/.*"go/go/' | sed 's/"//g')
else
  # go1.x.x 형식인지 검증
  if [[ ! "$GO_VERSION" =~ ^go[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    echo "❌ 올바르지 않은 Go 버전 형식입니다: $GO_VERSION"
    exit 1
  fi
fi

# 버전 존재 여부 확인 (정확한 버전만 추출)
if ! curl -s https://go.dev/dl/?mode=json | grep -q "\"$GO_VERSION\""; then
  echo "❌ 존재하지 않는 Go 버전입니다: $GO_VERSION"
  exit 1
fi

EXT="tar.gz"
[[ "$GO_OS" == "windows" ]] && EXT="msi"
TARBALL="${GO_VERSION}.${GO_OS}-${GO_ARCH}.${EXT}"
URL="https://dl.google.com/go/${TARBALL}"

echo "📦 Go 설치 시작: $GO_VERSION ($GO_OS/$GO_ARCH)"

# 다운로드 전 유효성 검사
if ! curl -fsI "$URL" > /dev/null; then
  echo "❌ 다운로드 URL이 유효하지 않거나 파일이 존재하지 않습니다: $URL"
  exit 1
fi

curl -f -o "$TARBALL" "$URL"


if [[ "$GO_OS" == "windows" ]]; then
  echo "⚙️  Windows 환경에서 자동 설치 시도 중..."

  if command -v winget &> /dev/null; then
    echo "📦 winget을 이용해 Go 설치"
    winget install -e --id GoLang.Go --silent || {
      echo "❌ winget 설치 실패"
      exit 1
    }
    echo "✅ winget을 통한 설치 완료"
  else
    echo "📦 winget이 없으므로 .msi 직접 다운로드 및 설치 시도"
    curl -f -o "$TARBALL" "$URL"

    powershell.exe Start-Process msiexec.exe -ArgumentList \"/i\", \"$TARBALL\", \"/qn\", \"/norestart\" -Wait -Verb RunAs || {
      echo "❌ .msi 설치 실패"
      exit 1
    }
    echo "✅ .msi를 통한 설치 완료"
  fi

  echo "⚠️  Windows에서는 셸을 새로 열어야 PATH 반영됨."
  exit 0
fi

# 설치 디렉토리
INSTALL_DIR="/usr/local/go"

# 기존 Go 제거 (정확히 INSTALL_DIR만 제거)
if [ -d "$INSTALL_DIR" ]; then
  echo "🧹 기존 Go 삭제: $INSTALL_DIR"
  sudo rm -rf "$INSTALL_DIR"
fi

# 설치
# tarball 내부에 go 디렉토리가 있으므로 /usr/local에 풀면 /usr/local/go가 됨
sudo tar -C /usr/local -xzf "$TARBALL"
rm "$TARBALL"

# 환경변수 설정
PROFILE="$HOME/.bashrc"
[[ -n "$ZSH_VERSION" || "$SHELL" =~ zsh ]] && PROFILE="$HOME/.zshrc"

if ! grep -q '^export PATH=/usr/local/go/bin:\$PATH' "$PROFILE"; then
  echo 'export PATH=/usr/local/go/bin:$PATH' >> "$PROFILE"
  echo "🛠️  PATH 설정이 $PROFILE에 추가되었습니다."
fi

export PATH=/usr/local/go/bin:$PATH
hash -r 2>/dev/null || true
rehash 2>/dev/null || true

echo "✅ 설치 완료: $GO_VERSION"