#!/bin/bash

# Create a virtual environment for Neovim
python3 -m venv ~/.neovim-venv

# Activate the virtual environment
source ~/.neovim-venv/bin/activate

# Install pynvim package
pip install pynvim

# Deactivate the virtual environment
deactivate

echo "Neovim Python virtual environment setup complete!"
echo "Python provider path: ~/.neovim-venv/bin/python3"
