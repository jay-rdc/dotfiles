### =======HISTORY======= ###

HISTSIZE=10000
SAVEHIST=10000
[ ! -d "$XDG_CACHE_HOME/zsh" ] && mkdir -p "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_CACHE_HOME/zsh/history.zsh"

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS

### =======PROMPT======= ###

+vi-git-status() {
  local ahead=""
  local behind=""
  local git_counts
  git_counts=$(git rev-list --left-right --count HEAD...@{upstream} 2> /dev/null)

  if [[ $? -eq 0 ]]; then
    local -a counts
    counts=(${=git_counts})

    (( counts[1] > 0 )) && ahead="%F{14}↑%f"
    (( counts[2] > 0 )) && behind="%F{9}↓%f"
  fi

  local untracked=""
  if [[ -n $(git --no-optional-locks ls-files --others --exclude-standard 2> /dev/null | head -n 1) ]]; then
    untracked="%F{12}?%f"
  fi

  local unstaged=""
  if [[ -n $(git --no-optional-locks diff --name-only --no-ext-diff 2> /dev/null | head -n 1) ]]; then
    unstaged="%F{11}!%f"
  fi

  local staged=""
  if [[ -n $(git --no-optional-locks diff --name-only --cached --no-ext-diff 2> /dev/null | head -n 1) ]]; then
    staged="%F{10}+%f"
  fi

  local all_changes="${behind}${ahead}${untracked}${unstaged}${staged}"
  if [[ -n "$all_changes" ]]; then
    hook_com[misc]=" %F{cyan}[%f${all_changes}%F{cyan}]%f"
  else
    hook_com[misc]=""
  fi
}

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-status

local vcs_formats=" on %F{cyan} %b%f%m"
zstyle ":vcs_info:git:*" formats "${vcs_formats}"
zstyle ":vcs_info:git:*" actionformats "${vcs_formats} %F{cyan}(%f%F{red}%a%f%F{cyan})%f"

precmd() { vcs_info }

setopt PROMPT_SUBST
PROMPT='%B%F{yellow} %1~%f${vcs_info_msg_0_} %F{10}%f%b '
RPROMPT='%B%F{blue} %n%f @ %F{magenta} %M%f%b'

### =======COMPLETION======= ###

eval $(dircolors -b)

autoload -Uz compinit
compinit -C

zstyle ":completion:*" menu select
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}

zmodload -i zsh/complist

### =======ALIASES======= ###

alias nv="nvim"
alias ff="fastfetch"
alias ls="ls --color=auto"
alias ll="ls -lh"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -v"
alias mkdir="mkdir -pv"
alias rmdir="rmdir -v"

### =======FUNCTIONS======= ###

mdcd() { mkdir $1 && cd $1 }

fp() {
  local project_dir=$(fd . $HOME/projects -td | fzf)
  [ -n "$project_dir" ] && cd $project_dir
}

tmux_connect() {
  if [ -z "$TMUX" ]; then
    tmux has 2> /dev/null
    [ $? -eq 1 ] && tmux new || tmux attach 2> /dev/null
  fi
}

### =======KEYBINDINGS======= ###

bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char

bindkey "^j" autosuggest-accept

bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

### =======MISC======= ###

[ -d "$HOME/.local/bin" ] && path=("$HOME/.local/bin" $path)

# Fast Node Manager (fnm)
if [ -d "$FNM_PATH" ]; then
  path=("$FNM_PATH" $path)

  # INFO: `(( $+commands[<cmd>] ))` returns true if the command exists
  (( $+commands[fnm] )) && eval "$(fnm env --shell zsh)"
fi

# Rust (cargo binaries)
[ -d "$HOME/.cargo/bin" ] && path=("$HOME/.cargo/bin" $path)

# fzf zsh integration
(( $+commands[fzf] )) && eval "$(fzf --zsh)"

# de-duplicate PATH
typeset -U path

### =======PLUGINS======= ###

__zsh_plugin() {
  local plugin_dir="$ZDOTDIR/plugins/$(basename $1)"
  local plugin_script="$plugin_dir/$(basename $1).zsh"

  [ ! -d $plugin_dir ] && git clone https://github.com/$1.git $plugin_dir
  [ -s $plugin_script ] && source $plugin_script
}

__zsh_plugin zsh-users/zsh-autosuggestions

# must be at last line
__zsh_plugin zsh-users/zsh-syntax-highlighting
