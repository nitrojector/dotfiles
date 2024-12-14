export ZSH="/Users/martingwq/.oh-my-zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add extra binaries to PATH
[ -f ~/.path.zsh ] && . ~/.path.zsh
[ -f ~/.env.zsh ] && . ~/.env.zsh
[ -f ~/.alias.zsh ] && . ~/.alias.zsh
[ -f ~/.func.zsh ] && . ~/.func.zsh
[ -f ~/Git/_conf/dotfiles/df.zsh ] && . ~/Git/_conf/dotfiles/df.zsh
[ -f "/Users/martingwq/.ghcup/env" ] && . "/Users/martingwq/.ghcup/env" # ghcup-env

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243' # Make color more visible with gruvbox dark
bindkey '^N' autosuggest-accept # Use vim-like autocomplete


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME=robbyrussell

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

COMPLETION_WAITING_DOTS="false"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh --cmd cd)"
source <(fzf --zsh)


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/martingwq/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/martingwq/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/martingwq/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/martingwq/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


