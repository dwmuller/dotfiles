# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# We don't want to check mail on our Linux systems
unset MAILCHECK

# SSH environments
#
# In a native Windows Linux-like shell, we assume programs can use the
# standard (for Windows) OpenSSH named pipe, or else SSH_AUTH_SOCK is
# set up already.
#
# TODO: Add SSH forwarding support for other remote Linux environments.
#
if [[ -z "$SSH_AUTH_SOCK" ]]
then
    if [[ "$(uname -r)" =~ "WSL2" ]]
    then
        # We appear to be running a Linux shell under WSL2. Set up the
        # forwarding agent.
        export SSH_AUTH_SOCK=~/.ssh/ssh-agent
        wsl-ssh-agent
    fi
fi

if [[ "$(uname -s)" =~ "MINGW.*" ]]
then
	# Augment MSYS env variable to use native symlinks and fail
	# if they're not available.
	export MSYS="$MSYS winsymlinks:nativerestrict"
fi

# We really don't use Cygwin anymore ...
if [[ "$(uname -s)" =~ "CYGWIN.*" ]]
then
	# Augment CYGWIN env variable to use native symlinks and fail
	# if they're not available.
	export CYGWIN="$CYGWIN winsymlinks:nativerestrict"
fi
