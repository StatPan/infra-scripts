#!/bin/bash
set -e

# -----------------------------
# Go installation script (follows official distribution method)
# Usage: ./install.sh [go-version] (e.g. go1.22.4, default is latest)
# -----------------------------


GO_VERSION=${1:-"latest"}

## Platform detection
UNAME_OS=$(uname -s)
UNAME_ARCH=$(uname -m)

case "$UNAME_OS" in
  Linux*)   GO_OS="linux" ;;
  Darwin*)  GO_OS="darwin" ;;
  MINGW*|MSYS*|CYGWIN*) GO_OS="windows" ;;
  *)        echo "❌ Unsupported OS: $UNAME_OS"; exit 1 ;;
esac

case "$UNAME_ARCH" in
  x86_64|amd64)   GO_ARCH="amd64" ;;
  arm64|aarch64)  GO_ARCH="arm64" ;;
  *)              echo "❌ Unsupported architecture: $UNAME_ARCH"; exit 1 ;;
esac

## Check if Go is already installed
if command -v go &> /dev/null; then
  INSTALLED_VERSION=$(go version | awk '{print $3}')
  echo "⚠️  Go is already installed: $INSTALLED_VERSION"
  read -p "↪️  Do you want to reinstall? (y/N): " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "⏹️  Installation cancelled."
    exit 0
  fi
fi


## Version selection and validation
if [[ "$GO_VERSION" == "latest" ]]; then
  # Extract latest version string
  GO_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o '"version": *"go[0-9.]*"' | head -n1 | sed 's/.*"go/go/' | sed 's/"//g')
else
  # Validate go1.x.x format
  if [[ ! "$GO_VERSION" =~ ^go[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    echo "❌ Invalid Go version format: $GO_VERSION"
    exit 1
  fi
fi

# Check if the version exists (only extract exact version)
if ! curl -s https://go.dev/dl/?mode=json | grep -q "\"$GO_VERSION\""; then
  echo "❌ Go version does not exist: $GO_VERSION"
  exit 1
fi

EXT="tar.gz"
[[ "$GO_OS" == "windows" ]] && EXT="msi"
TARBALL="${GO_VERSION}.${GO_OS}-${GO_ARCH}.${EXT}"
URL="https://dl.google.com/go/${TARBALL}"

echo "📦 Starting Go installation: $GO_VERSION ($GO_OS/$GO_ARCH)"

# Validate download URL before downloading
if ! curl -fsI "$URL" > /dev/null; then
  echo "❌ Download URL is invalid or file does not exist: $URL"
  exit 1
fi

curl -f -o "$TARBALL" "$URL"


if [[ "$GO_OS" == "windows" ]]; then
  echo "⚙️  Attempting automatic installation on Windows..."

  if command -v winget &> /dev/null; then
    echo "📦 Installing Go using winget"
    winget install -e --id GoLang.Go --silent || {
      echo "❌ winget installation failed"
      exit 1
    }
    echo "✅ Installation completed via winget"
  else
    echo "📦 winget not found, attempting direct .msi download and install"
    curl -f -o "$TARBALL" "$URL"

    powershell.exe Start-Process msiexec.exe -ArgumentList \"/i\", \"$TARBALL\", \"/qn\", \"/norestart\" -Wait -Verb RunAs || {
      echo "❌ .msi installation failed"
      exit 1
    }
    echo "✅ Installation completed via .msi"
  fi

  echo "⚠️  Please open a new shell on Windows for PATH changes to take effect."
  exit 0
fi

# Installation directory
INSTALL_DIR="/usr/local/go"

# Remove existing Go installation (only remove INSTALL_DIR)
if [ -d "$INSTALL_DIR" ]; then
  echo "🧹 Removing existing Go installation: $INSTALL_DIR"
  sudo rm -rf "$INSTALL_DIR"
fi

# Install
# The tarball contains a 'go' directory, so extracting to /usr/local results in /usr/local/go
sudo tar -C /usr/local -xzf "$TARBALL"
rm "$TARBALL"

# Set environment variables
PROFILE="$HOME/.bashrc"
[[ -n "$ZSH_VERSION" || "$SHELL" =~ zsh ]] && PROFILE="$HOME/.zshrc"

if ! grep -q '^export PATH=/usr/local/go/bin:\$PATH' "$PROFILE"; then
  echo 'export PATH=/usr/local/go/bin:$PATH' >> "$PROFILE"
  echo "🛠️  PATH configuration added to $PROFILE."
fi

export PATH=/usr/local/go/bin:$PATH
hash -r 2>/dev/null || true
rehash 2>/dev/null || true

echo "✅ Installation complete: $GO_VERSION"