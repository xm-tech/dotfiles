#!/bin/bash

echo "Removing Neovim Python support..."

# Check if there's a Neovim config file that needs to be modified
NVIM_CONFIG_FILE="$HOME/.config/nvim/init.lua"
if [ -f "$NVIM_CONFIG_FILE" ]; then
  echo "Updating Neovim configuration to disable Python support..."
  
  # Create a backup of the original file
  cp "$NVIM_CONFIG_FILE" "$NVIM_CONFIG_FILE.bak"
  
  # Add Python provider disable setting if not already present
  if ! grep -q "g.loaded_python3_provider = 0" "$NVIM_CONFIG_FILE"; then
    echo "-- Disable Python3 provider" >> "$NVIM_CONFIG_FILE"
    echo "vim.g.loaded_python3_provider = 0" >> "$NVIM_CONFIG_FILE"
    echo "Configuration updated to disable Python3 provider."
  else
    echo "Python3 provider already disabled in configuration."
  fi
else
  echo "Neovim config file not found at $NVIM_CONFIG_FILE"
fi

echo "Neovim Python support removal complete!"
