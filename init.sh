#!/bin/bash

#create symlinks for configuration

ln -s ~/dotfiles/bashrc ~/.bashrc
ln -s ~/dotfiles/doom.d ~/.doom.d
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/zellij ~/.config/zellij

#install the nvim config
git clone --depth 1 https://github.com/brightblade42/kickstart.nvim ~/.config/nvim

#install the dooms
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install


eval "$(zoxide init bash)"
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc


