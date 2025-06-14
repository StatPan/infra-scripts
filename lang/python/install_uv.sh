#!/usr/bin/env bash
set -e

echo "🔍 uv 설치 확인 중..."
if ! command -v uv &> /dev/null; then
  echo "📦 uv 설치 중..."
  curl -Ls https://astral.sh/uv/install.sh | bash
  export PATH="$HOME/.cargo/bin:$PATH"
else
  echo "✅ uv already installed"
fi

echo ""
echo "✅ uv 설치가 완료되었습니다."
echo "👉 이제 uv를 사용하여 Python 및 가상환경을 설치할 수 있습니다."
