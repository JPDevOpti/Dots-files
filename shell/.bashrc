# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# ── ls / eza ─────────────────────────────────────────────────────────────────
alias ls='eza -lh --group-directories-first --icons=auto --no-permissions --no-filesize --no-user'
alias lsa='ls -a'

# ── Navegación ────────────────────────────────────────────────────────────────
alias repos='cd ~/repositories'
alias dots='cd ~/repositories/Dots-files'
alias cfg='cd ~/.config'

# ── Git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias gl='git log --oneline --graph --decorate -15'
alias gp='git push'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add .'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'
alias gstp='git stash pop'

# ── Sistema ───────────────────────────────────────────────────────────────────
alias update='omarchy-update'
alias pkgs='omarchy-pkg-add'
alias reload='source ~/.bashrc && echo "bashrc recargado"'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me && echo'

# ── Dev ───────────────────────────────────────────────────────────────────────
alias py='python'
alias py3='python3'
alias pv='python -m venv .venv && source .venv/bin/activate && echo "venv activo"'
alias va='source .venv/bin/activate'
alias ni='npm install'
alias nr='npm run'
alias nd='npm run dev'

# ── Utilidades ────────────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.7z)           7z x "$1" ;;
    *.rar)          unrar x "$1" ;;
    *)              echo "No sé cómo extraer '$1'" ;;
  esac
}
backup() { cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"; }
source ~/.local/share/blesh/ble.sh
