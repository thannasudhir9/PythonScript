#!/bin/bash

set -e

echo "Installing latest Python version..."

PYTHON_VERSION=$(curl -s https://www.python.org/ | grep -oP 'Latest Python 3 Release - Python \K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
INSTALL_PREFIX="/usr/local"

echo "Latest Python version is: $PYTHON_VERSION"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev          libnss3-dev libssl-dev libreadline-dev libffi-dev curl libsqlite3-dev
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install openssl readline sqlite3 xz zlib
else
    echo "Unsupported OS"
    exit 1
fi

cd /tmp
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar -xf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}

./configure --enable-optimizations --prefix=${INSTALL_PREFIX}
make -j$(nproc)
sudo make altinstall

echo "Python ${PYTHON_VERSION} installed at ${INSTALL_PREFIX}/bin/python${PYTHON_VERSION%%.*}.${PYTHON_VERSION#*.}"
