# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# We don't want to check mail on our Linux systems
unset MAILCHECK

# SSH agent
# if [ ! -v SSH_AUTH_SOCK ]
# then
#     # We used to set up ssh-agent for WSL2 environments, but no longer.
#     case $SYS_TYPE in
#         WINDOWS)
#             # Assume we're using KeeAgent on Windows, unless SSH_AUTH_SOCK is already set.
#             export SSH_AUTH_SOCK=~/.ssh/keeagent
#         ;;
#     esac
# fi

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

