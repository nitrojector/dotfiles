# Path to Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"

CASE_SENSITIVE="false"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

COMPLETION_WAITING_DOTS="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# ZSH_CUSTOM=/path/to/custom-folder

# Plugins
# Standard plugins $ZSH/plugins/
# Custom plugins $ZSH_CUSTOM/plugins/
plugins=(
  git
  aliases
  zsh-autosuggestions
  nvm
)

source $ZSH/oh-my-zsh.sh

# env, path, alias
[[ -f ~/.env.zsh ]] && . ~/.env.zsh
[[ -f ~/.path.zsh ]] && . ~/.path.zsh
[[ -f ~/.alias.zsh ]] && . ~/.alias.zsh
[[ -f ~/.func.zsh ]] && . ~/.func.zsh
[[ -f "${DOTFILES_DIR}/df.zsh" ]] && . "${DOTFILES_DIR}/df.zsh"

# Plugin Configs
## zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243' # Make color more visible with gruvbox dark
bindkey '^N' autosuggest-accept # Use vim-like autocomplete


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# configs
[[ -f ~/.p10k.zsh ]] && . ~/.p10k.zsh
[[ -f ~/.fzf.zsh ]] && . ~/.fzf.zsh
[[ -f ~/gitstatus/gitstatus.prompt.zsh ]] && . ~/gitstatus/gitstatus.prompt.zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# command inits
eval "$(zoxide init zsh --cmd cd)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(fzf --zsh)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/takina/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/takina/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/takina/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/takina/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/takina/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/takina/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<



PATH=~/.console-ninja/.bin:$PATH
