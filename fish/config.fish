if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting ""
end

# Add ~/bin to PATH if it's not already included
if not contains "~/bin" $PATH
    set -x PATH ~/bin $PATH
end

alias l='exa -al --color=always --group-directories-first --icons' # preferred listing

export WVKBD_LANDSCAPE_HEIGHT=400
export SSH_ASKPASS=/usr/bin/qt4-ssh-askpass
export SSH_ASKPASS_REQUIRE=prefer
export OLLAMA_API_BASE_URL=172.17.0.1
# eval `keychain --eval --noask ~/.ssh/id_rsa`

alias upall='upall.sh'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/jdyer/.lmstudio/bin
