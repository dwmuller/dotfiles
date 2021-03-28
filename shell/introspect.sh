# Examine and remember some things about our environment.
IS_WSL2=$(uname -r | grep "WSL2")
IS_MSYS=$(uname -s | grep "MINGW")
IS_CYGWIN=$(uname -s | grep "CYGWIN")

if [ $IS_WSL2 ]
then
    # Get the Windows host's IP address from ip.
    export WSL_HOST_IP=$(ip route | awk '/^default/ {print $3}')
fi
