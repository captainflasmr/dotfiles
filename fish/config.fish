if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting ""
end

alias l='exa -al --color=always --group-directories-first --icons' # preferred listing

export WVKBD_LANDSCAPE_HEIGHT=400

alias upall='upall.sh'
