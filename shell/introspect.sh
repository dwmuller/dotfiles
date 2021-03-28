# Examine and remember some things about our environment.
IS_WSL2=$(uname -r | grep "WSL2")
IS_MSYS=$(uname -s | grep "MINGW")
IS_CYGWIN=$(uname -s | grep "CYGWIN")
