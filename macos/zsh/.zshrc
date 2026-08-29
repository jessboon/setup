# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------

if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================================
# Node / fnm
# ============================================================

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

# ============================================================
# Modern CLI tools
# ============================================================

# bat → cat
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

# eza → ls
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -lah --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --level=2 --icons'

  # Directory tree
  # lst       → 2 levels
  # lst 3     → 3 levels
  lst() {
    local depth="${1:-2}"
    eza --tree --level="$depth" --icons
  }
fi

# ============================================================
# Kubernetes
# ============================================================

if command -v kubectl >/dev/null 2>&1; then

  alias k='kubectl'

  # Get
  alias kg='kubectl get'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgn='kubectl get nodes'
  alias kga='kubectl get all'
  alias kgi='kubectl get ingress'

  # Describe
  alias kd='kubectl describe'
  alias kdp='kubectl describe pod'

  # Logs
  alias kl='kubectl logs'
  alias klf='kubectl logs -f'

  # Exec
  alias ke='kubectl exec -it'

  # Apply / delete
  alias ka='kubectl apply -f'
  alias kdelf='kubectl delete -f'

  # Context
  alias kctx='kubectl config current-context'
  alias kcontexts='kubectl config get-contexts'
  alias kuse='kubectl config use-context'

  # Restart deployment
  kroll() {
    kubectl rollout restart deployment "$1"
  }

  # Watch pods
  kwatch() {
    kubectl get pods --watch "$@"
  }

fi

# ============================================================
# Docker
# ============================================================

if command -v docker >/dev/null 2>&1; then

  alias d='docker'
  alias dc='docker compose'

  alias dps='docker ps'
  alias dpa='docker ps -a'
  alias di='docker images'

  alias drm='docker rm'
  alias drmi='docker rmi'

  alias dcu='docker compose up'
  alias dcud='docker compose up -d'
  alias dcd='docker compose down'
  alias dcl='docker compose logs -f'

fi

# ============================================================
# Git
# ============================================================

if command -v git >/dev/null 2>&1; then

  alias g='git'

  alias gs='git status'
  alias ga='git add'
  alias gaa='git add --all'

  alias gc='git commit'
  alias gca='git commit --amend'

  alias gp='git push'
  alias gpl='git pull'

  alias gd='git diff'
  alias gds='git diff --staged'

  alias gl='git log --oneline --decorate --graph'

  alias gco='git checkout'
  alias gsw='git switch'

  alias gb='git branch'
  alias gba='git branch -a'

fi

# ============================================================
# Neovim / NvChad
# ============================================================

if command -v nvim >/dev/null 2>&1; then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
fi

# ============================================================
# OpenCode
# ============================================================

if command -v opencode >/dev/null 2>&1; then
  alias oc='opencode'
fi

# ============================================================
# Navigation
# ============================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ============================================================
# General
# ============================================================

alias c='clear'
alias reload='source ~/.zshrc'

# Create directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ============================================================
# Archive extraction
# ============================================================

extract() {
  if [[ ! -f "$1" ]]; then
    echo "File not found: $1"
    return 1
  fi

  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "Don't know how to extract '$1'" ;;
  esac
}

# ============================================================
# pnpm
# ============================================================

export PNPM_HOME="$HOME/Library/pnpm"

if [[ -d "$PNPM_HOME" ]]; then
  export PATH="$PNPM_HOME:$PATH"
fi

# ============================================================
# uv
# ============================================================

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# ============================================================
