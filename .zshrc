# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =====================================================
# Path & Environment Setup
# =====================================================
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

# Editor preferences
export EDITOR='micro'
export VISUAL='micro'
export PAGER='less'
export LESS='-R -i -w -M -z-4'

# Colored output
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# =====================================================
# Oh My Zsh Configuration
# =====================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# Auto-install GitHub CLI if missing
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI (gh) not found. Installing..."
  if command -v sudo &> /dev/null; then
    sudo apt-get update && sudo apt-get install gh -y
  elif command -v apt-get &> /dev/null; then
    apt-get update && apt-get install gh -y
  fi
fi

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
    gh
    docker
    kubectl
    python
    pip
    node
    npm
    history-substring-search
    colored-man-pages
    command-not-found
    copypath
    copyfile
    jsontools
    extract
    sudo
    fzf-tab
)

alias pytest='noglob pytest'

source $ZSH/oh-my-zsh.sh

# =====================================================
# History Configuration
# =====================================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS          # NEW: Don't show duplicates in search
setopt HIST_EXPIRE_DUPS_FIRST     # NEW: Expire duplicates first

# =====================================================
# Shell Options
# =====================================================
setopt AUTO_CD
setopt CORRECT_ALL
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
setopt PROMPT_SUBST
setopt INTERACTIVE_COMMENTS

bindkey -e  # emacs-style keybindings

# =====================================================
# Keyboard Shortcuts (Mac + Linux Compatible)
# =====================================================

# Word Navigation - Works on both Mac and Linux
bindkey '^[[1;3D' backward-word      # Option/Alt+Left (Mac/Linux)
bindkey '^[[1;3C' forward-word       # Option/Alt+Right (Mac/Linux)
bindkey '^[b' backward-word          # Alt+b (universal)
bindkey '^[f' forward-word           # Alt+f (universal)

# Word Deletion - Works on both Mac and Linux
bindkey '^H' backward-kill-word      # Ctrl+Backspace (delete one word)
bindkey '^W' backward-kill-word      # Ctrl+W (standard, delete one word)
bindkey '^[[3;3~' kill-word          # Option/Alt+Delete (delete word forward)

# Line Deletion
bindkey '^[^?' backward-kill-line    # Alt+Backspace (delete to beginning of line)
bindkey '^U' backward-kill-line      # Ctrl+U (standard Unix, delete to beginning)
bindkey '^K' kill-line               # Ctrl+K (delete to end of line)

# History Search (with arrow keys)
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey '^P' history-substring-search-up        # Ctrl+P
bindkey '^N' history-substring-search-down      # Ctrl+N

# Incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Clear screen
bindkey '^L' clear-screen

# =====================================================
# Aliases
# =====================================================

# Directory navigation
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Enhanced commands
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias tree='tree -C'
alias cls='clear'

# History
alias h='history'
alias hg='history | grep'
alias hs='history | grep'

# Git (complementing the git plugin)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate --all'
alias gf='git fetch'
alias grb='git rebase'
alias gst='git stash'

# Python
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'
alias venv='python3 -m venv'
alias activate='source ./venv/bin/activate'

# Docker shortcuts
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Quick edits
alias zshconfig='$EDITOR ~/.zshrc'
alias zshreload='source ~/.zshrc'

# =====================================================
# Useful Functions
# =====================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files by name (renamed to avoid conflict with fd tool)
findfile() {
    find . -type f -iname "*$1*" 2>/dev/null
}

# Find directories by name
finddir() {
    find . -type d -iname "*$1*" 2>/dev/null
}

# Quick backup
backup() {
    local file="$1"
    local backup_file="${file}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup_file" && echo "Backed up to: $backup_file"
}

# Show disk usage of current directory
usage() {
    du -h --max-depth=1 2>/dev/null | sort -hr
}

# Weather
weather() {
    local location="${1:-Belgrade}"
    curl -s "wttr.in/${location}"
}

# Quick notes
note() {
    local notes_file="$HOME/notes.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >> "$notes_file"
    echo "Note added to $notes_file"
}

notes() {
    local notes_file="$HOME/notes.txt"
    [[ -f "$notes_file" ]] && cat "$notes_file" || echo "No notes found"
}

# Search notes
notesearch() {
    local notes_file="$HOME/notes.txt"
    [[ -f "$notes_file" ]] && grep -i "$1" "$notes_file" || echo "No notes found"
}

# Git functions
# Quick commit
qcommit() {
    git add -A && git commit -m "$*"
}

# Quick push
qpush() {
    git add -A && git commit -m "$*" && git push
}

# Show git branch in tree
gitbranches() {
    git log --graph --oneline --all --decorate
}

# Port killer
killport() {
    if [[ -z "$1" ]]; then
        echo "Usage: killport <port_number>"
        return 1
    fi
    local pid=$(lsof -ti:$1)
    if [[ -n "$pid" ]]; then
        kill -9 $pid && echo "Killed process on port $1"
    else
        echo "No process found on port $1"
    fi
}

# Process search
psgrep() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# =====================================================
# Tool Integrations
# =====================================================

# FZF - Fuzzy finder
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)" 2>/dev/null || true
    
    # FZF configuration
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    
    # FZF functions
    # Fuzzy file opener
    fo() {
        local file
        file=$(fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}') && $EDITOR "$file"
    }
    
    # Fuzzy cd
    fcd() {
        local dir
        dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
    }
    
    # Fuzzy kill process
    fkill() {
        local pid
        pid=$(ps aux | sed 1d | fzf -m | awk '{print $2}')
        [[ -n "$pid" ]] && echo "$pid" | xargs kill -${1:-9}
    }
fi

# Zoxide - Smart directory jumping
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

# =====================================================
# Powerlevel10k Configuration
# =====================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
