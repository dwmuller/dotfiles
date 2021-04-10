
# Source bash completions if we can find them.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Set up terraform completions if we have terraform installed.
command -v terraform &>/dev/null && complete -C terraform terraform

# Set up AWS CLI completions
command -v aws_completer &>/dev/null && complete -C aws_completer aws
