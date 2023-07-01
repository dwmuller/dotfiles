# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and update the values
# of LINES and COLUMNS if necessary.
shopt -s checkwinsize

# Make sure LANG is set to something supporting UTF-8, otherwise Unicode in
# prompts wreaks havoc with command line editing behavior. Oddly, LANG is left
# empty by default in Git Bash on Windows. See this article:
# - https://stackoverflow.com/questions/10651975/unicode-utf-8-with-git-bash
>&2 [ ! -v LANG ] && echo "LANG is not set. Use a UTF-8 supporting language."

