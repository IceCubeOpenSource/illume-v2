#!/bin/bash

set -ex

# Install latest Singularity (3.7.0) along with prereqs
# Source:
# https://sylabs.io/guides/3.7/admin-guide/installation.html#installation-on-linux

# Install dependencies
sudo apt-get update && sudo apt-get install -y build-essential uuid-dev \
    libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup-bin

# Golang already installed in user-tools.sh

# Download Singularity 3.7.0
export VERSION=3.7.0
wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
tar -xzf singularity-${VERSION}.tar.gz
rm -f singularity-${VERSION}.tar.gz
cd singularity

# Install
./mconfig
make -C ./builddir
sudo make -C ./builddir install

# Cleanup
cd /home/ubuntu
sudo rm -rf /home/ubuntu/singularity /home/ubuntu/go

# Add shell autocompletion
source /usr/local/etc/bash_completion.d/singularity
echo "source /usr/local/etc/bash_completion.d/singularity" | sudo tee -a /etc/profile.d/custom.sh > /dev/null

# Test
singularity --version
