#!/bin/bash

curl -L http://install.ohmyz.sh | sh

curl -L https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi.zsh -o ~/.oh-my-zsh/custom/hacfi.zsh
curl -L https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi.zsh-theme -o ~/.oh-my-zsh/custom/hacfi.zsh-theme

unamestr=$(uname -s)

if [ X"$unamestr" = X'Darwin' ]; then
  curl -L https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi-osx.zsh -o ~/.oh-my-zsh/custom/hacfi-osx.zsh
elif [ X"$unamestr" = X'Linux' ]; then
  curl -L https://github.com/hacfi/dotfiles/raw/master/zsh/hacfi-linux.zsh -o ~/.oh-my-zsh/custom/hacfi-linux.zsh
fi

sed -i 's/^ZSH_THEME=\"robbyrussell\"$/ZSH_THEME=\"hacfi\"/' ~/.zshrc
sed -i 's/^plugins=(git)$/plugins=(debian docker git history rsync)/' ~/.zshrc

if [ $USER != 'root' ];
  then echo "sudo -i" > ~/.zlogin
fi

rm -rf /etc/skel/.bash* /etc/skel/.profile

cp -r ~/.oh-my-zsh ~/.zshrc /etc/skel/
