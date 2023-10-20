#
# ~/.profile
#

export PATH=$PATH:/home/jdyer/bin:/home/jdyer/opt/GNAT/2021/bin:/home/jdyer/.cargo/bin:/opt/GNAT/2021/bin:/home/jdyer/.vscode-oss/extensions/adacore.ada-debug-23.0.11-universal/linux
export YDOTOOL_SOCKET=/run/user/1000/.ydotool_socket
export MOZ_USE_XINPUT2=1

export QT_SCALE_FACTOR=1.1
# export QT_QPA_PLATFORMTHEME=qt5ct

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
   export XDG_CURRENT_DESKTOP=x11
else
   export XDG_CURRENT_DESKTOP=wlr
fi

PS1='[\u:\w]\$ '

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias l='exa -lah --color=always --group-directories-first --icons' # tree listing

alias upall='topgrade'

xset b off
