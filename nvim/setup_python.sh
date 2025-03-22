#!/bin/bash

# Install pynvim package
pip install pynvim

# Deactivate the virtual environment
deactivate

echo "Neovim Python virtual environment setup complete!"
echo "Python provider path: ~/.neovim-venv/bin/python3"
