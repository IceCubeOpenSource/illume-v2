#!/bin/bash

set -ex

sudo apt-get update

# Build tools and utilities
sudo apt-get install -y build-essential \
    vim emacs \
    zsh tcsh \
    postgresql mariadb-server sqlite3 \
    jq valgrind subversion htop \
    default-jre default-jdk

# Install golang, used to compile Singularity among other things
wget https://golang.org/dl/go1.15.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.7.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile.d/custom.sh > /dev/null
source /etc/profile.d/custom.sh
# Verify it works
go version
rm -f go1.15.7.linux-amd64.tar.gz

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust-setup.sh
chmod +x rust-setup.sh
./rust-setup.sh -y
rm -f rust-setup.sh

# Anaconda - includes all scientific tools that users may wish to use,
# and can create both python2 and 3 environments
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O ~/anaconda.sh
sudo bash ~/anaconda.sh -b -p /opt/anaconda3
sudo chmod 755 -R /opt/anaconda3/
echo 'export PATH=$PATH:/opt/anaconda3/bin' | sudo tee -a /etc/profile.d/custom.sh > /dev/null
rm -f ~/anaconda.sh

# Python 3
sudo apt-get install -y python3-dev python3-pip

# Python 2, libs, tools
sudo apt-get install -y python2 python2-dev
# Need to get pip manually
curl https://bootstrap.pypa.io/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
rm -f get-pip.py

sudo reboot
