My personal dotfiles
====================

Overview
--------

![overview](img/overview.png "overview")

Install & Usage
---------------

Precondition

```txt
better on mac os, or else install the external softwares & plugins manually
```

On the old machine(optional)

Generate Brewfile

```shell
make bundle
```

On a new machine

```shell
# install all brew dependencies (optional)
make bundle_install

# copy dotfiles to the appropriate places
make install
```

Neovim Configuration
-------------------

This repository now includes a Neovim configuration that mirrors the Vim setup. The Neovim configuration is written in Lua and provides the same functionality as the Vim configuration.

To install the Neovim configuration:

```shell
make install_nvim
```

After installation, run `nvim +PackerSync` to install all plugins.
