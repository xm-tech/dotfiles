My personal dotfiles

On the old machine
---

```
# generate Brewfile
brew bundle dump --force
```

On a new machine
---

```
# install all brew dependencies
brew bundle

# copy dotfiles to the appropriate places
make
```
