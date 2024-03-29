
# Cribbed from Anish Athalye
ATTRIBUTE_BOLD='\[\e[1m\]'
ATTRIBUTE_RESET='\[\e[0m\]'
COLOR_DEFAULT='\[\e[39m\]'
COLOR_RED='\[\e[31m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'
COLOR_GRAY='\e[38;5;246m'

machine_name() {
    if [[ -f $HOME/.name ]]; then
        cat $HOME/.name
    elif [[ $IS_WSL2 ]]; then
        echo "$(hostname):${WSL_DISTRO_NAME:-wsl}"
    else
        hostname
    fi
}

if [[ $IS_WSL2 ]] && command -v oh-my-posh-wsl &>/dev/null; then
    eval "$(oh-my-posh-wsl --init --shell bash --config ~/.config.omp.json)"
elif command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh --init --shell bash --config ~/.config.omp.json)"
else
    PROMPT_DIRTRIM=3
    PS1="\n${COLOR_BLUE}#${COLOR_DEFAULT} ${COLOR_CYAN}\\u${COLOR_DEFAULT} ${COLOR_GREEN}at${COLOR_DEFAULT} ${COLOR_MAGENTA}$(machine_name)${COLOR_DEFAULT} ${COLOR_GREEN}in${COLOR_DEFAULT} ${COLOR_YELLOW}\w${COLOR_DEFAULT}\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)${COLOR_BLUE}>${COLOR_DEFAULT} "
    PS2="${COLOR_BLUE}>${COLOR_DEFAULT} "
fi

demoprompt() {
    PROMPT_DIRTRIM=1
    PS1="${COLOR_GRAY}\w ${COLOR_BLUE}\$ "
    trap '[[ -t 1 ]] && tput sgr0' DEBUG
}

# We used to work with some pretty long paths, and, esp. in TFS work areas, they
# often have camel-case components. This made our Bash prompt informative but
# tolerable:
#PROMPT_COMMAND='pwd2=$(perl -p -e "s:^$HOME:~:; 1 while s:([A-Za-z])[a-z]+(.*/):\\1\\2:g;" <<<$PWD)'
#PS1='\u@\h:$pwd2\$ '
