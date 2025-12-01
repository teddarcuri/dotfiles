#!/bin/bash
# Shared aliases for all platforms

# Navigation aliases
alias ..='cd ..'
alias cl="clear"
alias ll="ls -lahG"
alias sand="cd ~/Sandbox"
alias dot="cd ~/.dotfiles"
alias config="cd ~/.config"
alias notes="cd ~/Notes"
alias code="cd ~/Code"

# Git aliases
alias ga="git add ."
alias glg="git log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'"
alias gs="git status"
alias grec="git branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'"

# Shell config aliases
alias zconfig="nvim ~/.zshrc"
alias zprofile="nvim ~/.zprofile"
alias omz="nvim ~/.oh-my-zsh"
alias zsource="source ~/.zshrc"

# Editor aliases
alias vi="nvim"
alias vim="nvim"
alias nvimconfig="cd ~/.dotfiles/shared/nvim/ && nvim ."

# Utility
alias pd="pretty-diff"

# TMUX
alias tas="tmux attach-session"
alias tls="tmux ls"
