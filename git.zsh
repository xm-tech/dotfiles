## use vimdiff as default merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
git config --global merge.conflictstyle diff3
git config --global icdiff.options '--highlight --line-numbers'
