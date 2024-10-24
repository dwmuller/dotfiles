# Examine and remember some things about our environment.
IS_WSL2=$(uname -r | grep "WSL2")
IS_MSYS=$(uname -s | grep "MINGW")
IS_CYGWIN=$(uname -s | grep "CYGWIN")

if [ $IS_WSL2 ]
then
    # Get the Windows host's IP address from ip.
    export WSL_HOST_IP=$(ip route | awk '/^default/ {print $3}')
    SYS_TYPE="WSL2"
elif [ $IS_MSYS ]
then
    SYS_TYPE="WINDOWS"
elif [ $IS_CYGWIN ]
then
    SYS_TYPE="WINDOWS"
else
    SYS_TYPE="UNKNOWN"
    echo "System type is unrecognized by dotfiles." >&2
fi
