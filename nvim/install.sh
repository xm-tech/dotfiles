#!/bin/bash

# Create Neovim config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Create symbolic links for Neovim configuration
ln -sf $(pwd)/init.lua ~/.config/nvim/init.lua
ln -sf $(pwd)/coc-settings.json ~/.config/nvim/coc-settings.json

# Create lua directory and config subdirectory
mkdir -p ~/.config/nvim/lua/config

# Link all Lua config files
for file in $(pwd)/lua/config/*.lua; do
  filename=$(basename "$file")
  ln -sf "$file" ~/.config/nvim/lua/config/"$filename"
done

# Install packer.nvim if not already installed
PACKER_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_PATH" ]; then
  echo "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
fi

# Run PackerSync to install plugins
echo "Installing plugins with PackerSync..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || {
  echo "Note: Headless PackerSync may have failed. Please run 'nvim +PackerSync' manually."
}

# Verify installation
echo "Neovim configuration has been installed!"
echo "Configuration files linked to ~/.config/nvim/"
echo "Plugins should be installed automatically."
echo "If you encounter any issues, run 'nvim +PackerSync' manually."
