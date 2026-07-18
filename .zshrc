export PATH="/usr/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions fzf-tab zsh-history-substring-search zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v pay-respects >/dev/null 2>&1 && eval "$(pay-respects zsh --alias fuck)"

zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border
zstyle ':fzf-tab:*' switch-group ',' '.'
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export PAGER='bat --paging=always'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT='-c'
export LESS='-R'

alias ls='eza --icons --group-directories-first -1'
alias ll='eza --icons --group-directories-first -la'
alias la='eza --icons --group-directories-first -a'
alias cat='bat --paging=never'
alias top='btop'
alias findf='fd'
alias grepf='rg'
alias fastfecht='fastfetch'
alias fk='fuck'

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export PATH="$HOME/.npm-global/bin:$PATH"

# opencode
export PATH=/home/jp/.opencode/bin:$PATH

# --- Android SDK (Hoggu) ---
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
