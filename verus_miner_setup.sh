#!/bin/bash

set -e

# Configuration
WALLET_ADDRESS="<YOUR_VERUS_ADDRESS>"  # <- Replace this with your Verus wallet address
POOL="na.luckpool.net:3956"
THREADS=$(nproc)
USE_GPU=true  # Set to false if you only want CPU mining

echo "Starting Verus Coin Miner Setup..."

# Dependencies
echo "Installing dependencies..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y git build-essential cmake automake autoconf libtool pkg-config libcurl4-openssl-dev libssl-dev
    sudo apt install -y ocl-icd-opencl-dev opencl-headers
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (requires Xcode + Homebrew)
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install cmake automake autoconf libtool pkg-config curl openssl
    echo "OpenCL is included with macOS. Proceeding..."
else
    echo "Unsupported OS."
    exit 1
fi

# Clone the miner
echo "Cloning Verus miner..."
cd ~
git clone https://github.com/VerusCoin/nheqminer.git
cd nheqminer

# Build the miner
echo "Building the miner..."
mkdir -p build
cd build
cmake ..
make -j$THREADS

echo "Miner built successfully."

# Start mining
echo "Starting mining..."
if [ "$USE_GPU" = true ]; then
    ./nheqminer -v -l $POOL -u $WALLET_ADDRESS.worker1 -t $THREADS
else
    ./nheqminer -l $POOL -u $WALLET_ADDRESS.worker1 -t $THREADS
fi
