#!/bin/bash

echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# check locale!!: en_US.utf-8

# DOCKER:
# http://jaredmarkell.com/docker-and-locales/
# FROM ubuntu:...
#
# # Set the locale
# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# https://registry.hub.docker.com/u/wernerb/docker-xbmc-server/dockerfile/raw
# # Set locale to UTF8
# RUN locale-gen --no-purge en_US.UTF-8
# RUN update-locale LANG=en_US.UTF-8
# RUN dpkg-reconfigure locales
# ENV LANGUAGE en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# http://serverfault.com/a/274194

# http://www.thomas-krenn.com/de/wiki/Locales_unter_Ubuntu_konfigurieren
# sudo locale-gen de_DE.UTF-8
# update-locale LANG=de_DE.UTF-8


# https://github.com/docker/docker/issues/3359#issuecomment-52896048
# RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata



# build-essential
apt-get install curl fail2ban git-core htop mtr-tiny sudo vim zsh lsof mosh

curl -L http://install.ohmyz.sh | sh

cd ~/.oh-my-zsh/custom
wget https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi.zsh
wget https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi-linux.zsh
wget https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi.zsh-theme


rm -rf /etc/skel/.bash* /etc/skel/.profile

cp -r ~/.oh-my-zsh ~/.zshrc /etc/skel/

useradd -D -g 33
useradd -D -s /usr/bin/zsh

useradd -N -m -g 33 -G sudo achilles
passwd achilles

vim /etc/ssh/sshd_config
service ssh restart