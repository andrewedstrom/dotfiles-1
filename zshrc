#!/usr/bin/env zsh

test -f "${HOME}/.profile" && emulate sh -c '. "${HOME}/.profile"'

# Homebrew zsh completions
fpath=(/usr/local/share/zsh-completions $fpath)

bindkey -e # emacs bindings ctl-{a|e|k|...}

## History
export SAVEHIST=1000000
export HISTSIZE=1000000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

## Better up and down arrow behavior
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

## Prompt
setopt prompt_subst

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ":vcs_info:*" formats "%m %b"
zstyle ":vcs_info:*" actionformats "%m %b|%{$fg[red]%}%a%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-st

function +vi-git-st() {
  case "$(git status --porcelain 2> /dev/null | wc -l | tr -d ' ')" in
    "0")
      hook_com[branch]="%{$fg[green]%}✓%{$reset_color%} %{$fg[green]%}${hook_com[branch]}%{$reset_color%}"
    ;;
    *)
      hook_com[branch]="%{$fg[red]%}✗%{$reset_color%} %{$fg[green]%}${hook_com[branch]}%{$reset_color%}"
    ;;
  esac
}

precmd() {
  vcs_info
}

## NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

## Aliases
alias gst="git status"

PROMPT='%{$fg[cyan]%}%*%{$reset_color%} %{$fg[magenta]%}%m%{$reset_color%}:%{$fg[green]%}%~%{$reset_color%}
${vcs_info_msg_0_} %{$fg[green]%}% $ %{$reset_color%}'

## Programs that watch history
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

function fossa_up() {
  pushd ~/workspace/FOSSA
    docker-compose up -d s3
    docker-compose up -d db
    docker-compose up -d smtp
    yarn boot:dev
  popd
}
