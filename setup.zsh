#!/bin/zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
rm -f ~/.zshrc
ln -s ~/.vim/zshrc ~/.zshrc
rm -f ~/.zpreztorc
ln -s ~/.vim/zpreztorc ~/.zpreztorc
