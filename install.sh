#!/usr/bin/env sh

# Install brew && brew bundles

# Link dotfiles
ln -fs "$(pwd)/vimrc" ~/.vimrc
ln -fs "$(pwd)/tmux.conf" ~/.tmux.conf
ln -fs "$(pwd)/zshrc" ~/.zshrc
ln -fs "$(pwd)/zsh-path" ~/.zsh-path
mkdir -p ~/.config
ln -fs "$(pwd)/config/nvim" ~/.config/nvim

echo "Chose your toolchain in asdf.sh and install it."
