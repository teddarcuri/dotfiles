emulate sh
source ~/.profile
emulate zsh

#Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Bash Aliases
alias ..='cd ..'
alias cl="clear"
alias ll="ls -lahG"
alias www="cd ~/Sites"
alias sand="cd ~/Sandbox"
alias wg="cd ~/Sites/wannago"
alias dot="cd ~/.dotfiles"
alias config="cd ~/.config"
alias tedd="cd ~/Sites/tedd.online"

# Git Commands
alias ga="git add ."
alias glg="git log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'"
alias gs="git status"

# ZSH Aliases
alias zconfig="nvim ~/.zshrc"
alias zprofile="nvim ~/.zprofile"
alias omz="nvim ~/.oh-my-zsh"
alias zsource="source ~/.zprofile"

# VSCODE
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}


# Setting PATH for Python 3.11
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH
