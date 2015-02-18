#!/bin/bash

set -eu

apt-get install -y sudo
useradd -D -g 33
useradd -D -s /usr/bin/zsh

useradd -N -m -g 33 -G sudo achilles
passwd achilles
