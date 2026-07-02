if status is-interactive
# Commands to run in interactive sessions can go here
set -g fish_greeting ""
end

# Add ~/bin and the bootstrap repo to PATH if not already included
if not contains "~/bin" $PATH
set -x PATH ~/bin $PATH
end
if not contains "~/bin/bootstrap" $PATH
set -x PATH ~/bin/bootstrap $PATH
end

alias l='exa -al --color=always --group-directories-first --icons' # preferred listing

export WVKBD_LANDSCAPE_HEIGHT=400
export OLLAMA_API_BASE_URL=172.17.0.1
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"

# export CLOUDFLARE_API_TOKEN="zLyUWJ21jPl0UJJo5THbwd7hIErJY4HuO6IS_Sne"
# export CLOUDFLARE_API_TOKEN="d596c25533e9063de8ef5b28fc43a1057caab"
export CLOUDFLARE_ZONE_DYERDWELLING="00f6d54ab0071f31cdbdff38375f1f1a"
export CLOUDFLARE_ZONE_ART="your-art-zone-id"

# curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
# -H "Authorization: Bearer zLyUWJ21jPl0UJJo5THbwd7hIErJY4HuO6IS_Sne"

alias upall='upall.sh'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/jdyer/.lmstudio/bin
export PATH="$HOME/.local/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/home/jdyer/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
fish_add_path ~/.npm-global/bin
fish_add_path ~/.bun/bin

set -gx EDITOR /usr/bin/emacs