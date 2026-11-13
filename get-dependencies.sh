#!/bin/sh

set -eu

ROOT_DIR=$(pwd)
ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# FUCK YOU STUPID AUR MORONS CAN YOU FIGURE OUT HOW TO FUCKING PACKAGE?
VERSION=$(curl -fsSL https://opencode.ai/update/api/latest/desktop/opencode | jq -r '.version')

case "$ARCH" in
  x86_64) DEB_ARCH=amd64 ;;
  aarch64) DEB_ARCH=arm64 ;;
  *) echo "Unsupported architecture $ARCH" >&2; exit 1 ;;
esac

DEB="opencode-desktop-linux-${DEB_ARCH}.deb"
URL="https://opencode.ai/files/bin/${VERSION}/opencode-desktop-linux-${DEB_ARCH}.deb"

curl -sSfL "$URL" -o "/tmp/${DEB}"

rm -rf /tmp/opencode-deb
mkdir -p /tmp/opencode-deb
cd /tmp/opencode-deb
tar xf "/tmp/${DEB}"
tar xf data.tar.xz -C /

mkdir -p "${ROOT_DIR}/AppDir/bin"
cp -rv /opt/OpenCode/* "${ROOT_DIR}/AppDir/bin/"
