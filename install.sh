#!/usr/bin/env sh

# Install brew && brew bundles


# Warn user about possible overwrite
echo "WARNING: This will symlink dotfiles and may overwrite your existing files."
read -p "Do you want to continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
	echo "Aborted. No changes made."
	exit 1
fi

# Function to backup and link
backup_and_link() {
	src="$1"
	dest="$2"
	if [ -e "$dest" ] || [ -L "$dest" ]; then
		backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
		echo "Backing up $dest to $backup"
		mv "$dest" "$backup"
	fi
	ln -fs "$src" "$dest"
}

# Link dotfiles with backup
backup_and_link "$(pwd)/vimrc" "$HOME/.vimrc"
backup_and_link "$(pwd)/tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$(pwd)/zshrc" "$HOME/.zshrc"
backup_and_link "$(pwd)/zsh-path" "$HOME/.zsh-path"
backup_and_link "$(pwd)/vale.ini" "$HOME/.vale.ini"
backup_and_link "$(pwd)/styles" "$HOME/styles"
backup_and_link "$(pwd)/gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config"
backup_and_link "$(pwd)/config/nvim" "$HOME/.config/nvim"

echo "Done"
