# # zsh mods
# # export PROMPT='%F{51}steven%f:~$ '
# parse_git_branch() {
#   git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
# }
# COLOR_DEF="%f"
# COLOR_NAME="%F{#bfe6b1}"
# COLOR_GIT="%F{#89b4fa}"
# COLOR_FOLDER="%F{#f38ba8}"
# setopt PROMPT_SUBST
# export PROMPT='${COLOR_NAME}steven%f ${COLOR_FOLDER}%1d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}% :~$ '

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home

# go
export PATH="$PATH:$HOME/go/bin"

# poetry
export PATH="$HOME/.local/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# standard text editor
export EDITOR="nv"

# fzf commands for shell (ctrl-r to fuzzy find history)
source <(fzf --zsh)

# start tmux session called hack if none is active
if command -v tmux > /dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  # Try to attach to an existing 'hack' session; if it doesn't exist, create it.
  tmux attach-session -t hack || tmux new-session -s default
fi

# create tmux session after fuzzy finding directory
tmux_session() {
  # TODO: make directroy list nice
  local dir_name
  dir_name=$(find ~/Desktop/repos ~/Desktop/oss ~/Desktop/study -type d ! -name '.*' -maxdepth 1 | fzf)
  # exit if no directory selected
  [[ -z "$dir_name" ]] && echo "No directory selected. Exiting..." && return 0

  local session_name
  session_name=$(basename "$dir_name")
  # strip special characters (keep only alphanumeric, dashes, and underscores)
  session_name=$(echo "$session_name" | tr -cd '[:alnum:]_-')

  # check if the tmux session exists and attach to it if it does
  # TODO: name first two windows "nvim" and "scratch"
  if tmux has-session -t "$session_name" 2> /dev/null; then
    if [ "$TERM_PROGRAM" = tmux ]; then
      tmux switch -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
  else
    # cd "$dir_name" || exit
    TMUX=$(tmux new-session -d -s "$session_name" -n "editor")

    tmux send-keys -t "$session_name":editor "cd $dir_name" C-m "clear" C-m
    # tmux send-keys -t "$session_name":editor "nvim" C-m
    # TODO: source .venv if it exists
    # [[ -d "$dirname/.venv" ]] && source "$dirname/.venv/bin/activate" C-m

    tmux new-window -t "$session_name" -n "scratch"
    tmux send-keys -t "$session_name":scratch "cd $dir_name" C-m "clear" C-m

    # TODO: currently only works when already in a tmux session
    tmux switch-client -t "$session_name"

    tmux select-window -t "$session_name":editor
  fi
}
alias ts=tmux_session

# aliases
alias home="cd ~"
alias work="cd ~/Desktop/repos"
alias study="cd ~/Desktop/study"
alias oss="cd ~/Desktop/oss"
alias notes="cd ~/Desktop/notes"
alias config="cd ~/.config"

alias cat="bat"

alias ls="eza"
alias ll="eza -alh"

alias lg="lazygit"

alias gs="git status"
alias gb="git branch"
alias gc="git branch | grep -v '^\*' | fzf --height=20% --info=inline | xargs git checkout"
alias gcb="git checkout -b"
alias gl="git log --oneline --graph --color --all --decorate"
alias gr="git fetch && git rebase origin/master"

function gsq() {
  # git squash
  git reset --soft HEAD~"${1}" && git commit
}

# activate/deactivate .venv
# only works for python virtual environments called .venv
alias cv="python -m venv .venv"
alias av="source .venv/bin/activate"
alias dv="deactivate"

# set up pyrightconfig.json
function create_pyright_conf() {
  local venv_name=$1

  # Check if a file name is provided
  if [ -z "$venv_name" ]; then
    venv_name=".venv"
  fi

  # Create the file with the desired content
  cat << EOF > "pyrightconfig.json"
{
  "venvPath": ".",
  "venv": "${venv_name}"
}
EOF

  echo "pyrightconfig.json created for ${venv_name}"
}

function export_mlp_vars() {
  export MLP_METADATA_PATH=$HOME/Desktop/repos/ml-platform-metadata
  export MLP_TERRAFORM_PATH=$HOME/Desktop/repos/ml-platform/terraform/modules
  export MLP_VERSION_FILE=$HOME/Desktop/repos/ml-platform-metadata/.mlp-version
}

# update OneMLP cli
alias update_mlp="gsutil cp gs://jet-ml-infra-platform-artifacts/ml-platform/cli/latest/mlp-macos-py310.pex /usr/local/bin/mlp && chmod +x /usr/local/bin/mlp"

# mlp cli dev
alias mlp_dev="$HOME/Desktop/repos/ml-platform/dist/python.cli/mlp-macos.pex"

# pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# kubernetes
alias k="kubectl"

# neovim
alias nv="nvim"
alias nvc="nvim $HOME/.config/nvim"

# duckdb
alias ddb="duckdb"

# open work repo in zed
alias zedo="dir=\$(find ~/Desktop/repos -type d ! -name '.*' -maxdepth 1 | fzf); if [[ -n \$dir ]]; then zed \"\$dir\"; fi"

# function to clean __pycache__ and .pyc and .pyo
pyclean() {
  find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}

# gcp kubernetes auth, prevents error in astro-ml-local
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# pipx
export PIPX_DEFAULT_PYTHON="$HOME/.pyenv/versions/3.9.16/bin/python"

export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH="/usr/local/opt/mysql-client@8.0/bin:$PATH"
export PATH="/usr/local/opt/mysql@8.0/bin:$PATH"

. "$HOME/.cargo/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# set python interpreter for gcloud cli
export CLOUDSDK_PYTHON="$HOME/.pyenv/versions/3.11.8/bin/python"

# uv shell autocomplete
eval "$(uv generate-shell-completion zsh)"

# starship command line prompt
eval "$(starship init zsh)"

# load syntx highlighting (should be last)
source "$HOME"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
