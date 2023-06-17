# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# We don't want to check mail on our Linux systems
unset MAILCHECK

# SSH environments
if [ ! -v SSH_AUTH_SOCK ]
then
    case $SYS_TYPE in
        WSL2)
            # If SSH_AUTH_SOCK is not set up yet, assume we're to use wsl-ssh-agent.
            export SSH_AUTH_SOCK=~/.ssh/ssh-agent
            wsl-ssh-agent
            ;;
        WINDOWS)
            # Assume we're using KeeAgent on Windows, unless SSH_AUTH_SOCK is already set.
            export SSH_AUTH_SOCK=~/.ssh/keeagent
        ;;
    esac
fi

# Symlinks in Windows environments.
if [ $IS_MSYS ]
then
    # Augment MSYS env variable to use native symlinks.
    export MSYS="$MSYS winsymlinks:nativestrict"
elif [ $IS_CYGWIN ]
then
    # We really don't use Cygwin anymore ...
	# Augment CYGWIN env variable to use native symlinks and fail
	# if they're not available.
	export CYGWIN="$CYGWIN winsymlinks:nativestrict"
fi

# X Window
if [ $IS_WSL2 ]
then
    export DISPLAY="$WSL_HOST_IP:0"
fi

