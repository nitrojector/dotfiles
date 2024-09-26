chelp () {
  echo "Custom Script Help (edit June 30, 2022)"
  printf '%*s' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo
  echo "bahaha\tRepeats \$1"
  echo "skim\tOpens \$1 with Skim"
  echo "spek\tOpens \$1 with Spek"
  echo "dual\tTries to open another instances of \$1 [predefined seq]"
  echo "\t\twechat - opens wechat"
  echo "ptex\tCompiles \$1 with PDFLaTeX"
  echo "dols\tLists files in DO Spaces with aws-cli; must add / if specific path"
  echo "\t\tUsage: dols /prefix/of/file/"
  echo "doup\tUploads \$1 as public to DO Spaces under temp folder"
  echo "doupr\tUploads \$1 as public to DO Spaces under root or specified folder in \$2"
  echo "doupp\tUploads \$1 as temporarily public to DO Spaces under temp folder with expire=\$2"
  echo "douppr\tUploads \$1 as temporarily public to DO Spaces under root if unspecified\t\tor specified folder in \$3 with expire=\$2"
  echo "ytdl\tAlias for youtube-dl"
  echo "py\tAlias for python"
  echo "cact\tAlias for conda activate"
  echo "csql\tLogin mySQL through root with password"
  echo "cst\tCustom specified speed test by Ookla"
  echo "cvst\tCustom specified verbose speed test by Ookla"
}

# Custom Commands
bahaha () {
  echo "bahaha $1!"
}

st () {
  open -a "Sublime Text" $1
}

hex () {
  open -a "Hex Fiend" $1
}

skim () {
  open -a "skim" $1
}

spek () {
  open -a "spek" $1
}

dual () {
  local app_path=""

  # Set path for app based on input
  if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = 'wechat' ]; then
    app_path='/Applications/WeChat.app/Contents/MacOS/WeChat'
  fi

  # Determine validity
  if ! [ -z "$app_path" ]; then
    open -n $app_path
  else
    echo "Invalid option $app_path"
  fi
}

ptex () {
  pdflatex -synctex=1 -interaction=nonstopmode $1
}

uriencode_stdin() {
    node -p 'encodeURIComponent(require("fs").readFileSync(0))'
}

dols () {
  aws s3 ls s3://jectorassets$1 --endpoint=https://nyc3.digitaloceanspaces.com/
}

doupr () {
  aws s3 cp $1 s3://jectorassets$2 --endpoint=https://nyc3.digitaloceanspaces.com/ --acl public-read
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo -n "Origin: \t"https://jectorassets.nyc3.digitaloceanspaces.com$2
  [ -z "$2" ] && echo -n "/"
  printf %s $1|jq -sRr @uri
  echo -n "Edge: \t\t"https://jectorassets.nyc3.cdn.digitaloceanspaces.com$2
  [ -z "$2" ] && echo -n "/"
  printf %s $1|jq -sRr @uri
  echo -n "Domain: \t"https://s3.jector.io$2
  [ -z "$2" ] && echo -n "/"
  printf %s $1|jq -sRr @uri
}

douppr () {
  EXPIREIN=$2
  ROOT=/
  aws s3 cp $1 s3://jectorassets$3 --endpoint=https://nyc3.digitaloceanspaces.com/ --acl private
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  if [ -z "$2" ]; then
    echo "No expire time provided, uploaded as private file"
  else
    if [ -z "$3" ]; then
      aws s3 presign s3://jectorassets/$1 --endpoint=https://nyc3.digitaloceanspaces.com/ --expires-in $EXPIREIN
    else
      aws s3 presign s3://jectorassets$3$1 --endpoint=https://nyc3.digitaloceanspaces.com/ --expires-in $EXPIREIN
    fi
  fi
}

doup () {
  DATE=`date +"%b-%Y"`
  FOLD=`echo "$DATE" | awk '{ print tolower($1) }'`
  aws s3 cp $1 s3://jectorassets/tmp/${FOLD}/$1 --endpoint=https://nyc3.digitaloceanspaces.com/ --acl public-read
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo -n "Origin: \t"https://jectorassets.nyc3.digitaloceanspaces.com/tmp/$FOLD/
  printf %s $1|jq -sRr @uri
  echo -n "Edge: \t\t"https://jectorassets.nyc3.cdn.digitaloceanspaces.com/tmp/$FOLD/
  printf %s $1|jq -sRr @uri
  echo -n "Domain: \t"https://s3.jector.io/tmp/$FOLD/
  printf %s $1|jq -sRr @uri
}

doupp () {
  DATE=`date +"%b-%Y"`
  FOLD=`echo "$DATE" | awk '{ print tolower($1) }'`
  EXPIREIN=$2
  aws s3 cp $1 s3://jectorassets/tmp/${FOLD}/$1 --endpoint=https://nyc3.digitaloceanspaces.com/ --acl private
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  if [ -z "$2" ];
  then
    echo "No expire time provided, uploaded as private file"
  else
   aws s3 presign s3://jectorassets/tmp/$FOLD/$1 --endpoint=https://nyc3.digitaloceanspaces.com/ --expires-in $EXPIREIN
  fi
}

unsetproxy () {
  unset http_proxy
  unset https_proxy
  unset telnet_proxy
  unset ftp_proxy

  echo 'unset all proxies'
}

setproxy () {
  local pport=7890

  if [ ! -z "$1" ]
  then
    pport=$1
  fi

  export "http_proxy=http://127.0.0.1:$pport/"
  export "https_proxy=http://127.0.0.1:$pport/"
  export "telnet_proxy=http://127.0.0.1:$pport/"
  export "ftp_proxy=http://127.0.0.1:$pport/"
  echo "set proxies to local port $pport"
}

entry () {
  ENTRYLOC="/Users/martingwq/Git/_personal/365/$(date +'%Y/%m/%d').md"
  REPOLOC="/Users/martingwq/Git/_personal/365/"
  PREVLOC="$PWD"

  while getopts ":p" opt; do
    case $opt in
      p)
        echo "Attempting push..."
        cd $REPOLOC
        git push
        cd $PREVLOC
        return 0
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
  done

  echo "EntryPath: $ENTRYLOC\n"

  cd $REPOLOC

  echo "Pulling remote..."
  git -C $REPOLOC pull

  GITLASTCOMMITCODE=$(git -C $REPOLOC show -s --format=%s)

  if test -f "$ENTRYLOC"; then
    echo "Entry alread exists, adding to existing entry...\n"
  else
    echo "Creating new entry...\n"
    mkdir -p $(dirname $ENTRYLOC)
    touch $ENTRYLOC
    echo "# $(date +'%B %d, %Y')" >> $ENTRYLOC
  fi

  echo "\n## $(date +'%H:%M:%S')\n\n" >> $ENTRYLOC

  vi "+normal G$" $ENTRYLOC
  # vi "+normal G$" +startinsert $ENTRYLOC

  GITCURRENTCOMMITCODE="$(date +'%Y%m%d')-0"

  if [[ "$(date +'%Y%m%d')" = "${GITLASTCOMMITCODE:0:8}" ]]; then
    GITCURRENTCOMMITCODE="$(date +'%Y%m%d')-$((${GITLASTCOMMITCODE:9} + 1))"
  fi

  git -C $REPOLOC add *
  git -C $REPOLOC commit -m "$GITCURRENTCOMMITCODE"

  echo "Entry committed\n"

  {
    git -C $REPOLOC push

    echo "Attempt push success.\n"

  } || {
    echo "Failed to push to remote. Retry with -p"
  }

  git -C $REPOLOC log -n 1

  cd $PREVLOC
}

opttest () {
  while getopts ":a:" opt; do
    case $opt in
      a)
        echo "-a was triggered, Parameter: $OPTARG" >&2
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
  done
}

entryg () {
  ENTRYLOC="/Users/martingwq/Git/_personal/365g/$(date +'%Y/%m/%d').md"
  REPOLOC="/Users/martingwq/Git/_personal/365g/"
  ALIAS="wyvern"

  echo "EntryPath: $ENTRYLOC\n"

  cd $REPOLOC

  echo "git pull:"
  git -C $REPOLOC pull

  GITLASTCOMMITCODE=$(git -C $REPOLOC show -s --format=%s)

  if test -f "$ENTRYLOC"; then
    echo "Entry alread exists, skipping creation...\n"
  else
    echo "No entry found, creating...\n"
    mkdir -p $(dirname $ENTRYLOC)
    touch $ENTRYLOC
    echo "# $(date +'%B %d, %Y')" >> $ENTRYLOC
  fi

  echo "\n## $(date +'%H:%M:%S') ($ALIAS)\n\n" >> $ENTRYLOC

  vi "+normal G$" $ENTRYLOC
  # vi "+normal G$" +startinsert $ENTRYLOC

  GITCURRENTCOMMITCODE="$(date +'%Y%m%d')-0"

  if [[ "$(date +'%Y%m%d')" = "${GITLASTCOMMITCODE:0:8}" ]]; then
    GITCURRENTCOMMITCODE="$(date +'%Y%m%d')-$((${GITLASTCOMMITCODE:9} + 1))"
  fi

  git -C $REPOLOC add *
  git -C $REPOLOC commit -m "$GITCURRENTCOMMITCODE"

  echo "Entry committed\n"

  {
    git -C $REPOLOC push

    echo "Entry pushed to remote:main\n"

  } || {
    echo "Push to remote failed"
  }

  git -C $REPOLOC log -n 1
}

oln () {
  ping -oc 100000 $1 > /dev/null && osascript -e "display notification \"Ping succeeded with $1\" with title \"Back Online\"" || echo ""
  say "Service Online"
}

oln1 () {
  ping -oc 100000 1.1.1.1 > /dev/null && osascript -e "display notification \"Ping succeeded with 1.1.1.1\" with title \"Back Online\"" || echo ""
  say "Network Online"
}

# Add extra binaries to PATH
export PATH=$PATH:/Users/martingwq/bin/
export PATH=$PATH:/Users/martingwq/bin/waifu2x-ncnn-vulkan/
export PATH=$PATH:/Users/martingwq/Library/Android/sdk/platform-tools/
export PATH=$PATH:/Users/martingwq/bin/nvim-macos/bin/
export PATH=$PATH:/opt/homebrew/Cellar/libusb/1.0.26/lib/
export PATH=$PATH:/usr/local/go/bin/

export DOTFILES_DIR=/Users/martingwq/Git/_conf/dotfiles

[ -f ~/Git/_conf/dotfiles/df.zsh ] && . ~/Git/_conf/dotfiles/df.zsh

# Aliases
alias waifu2x=waifu2x-ncnn-vulkan
alias ytdl=yt-dlp
alias py=python
alias ws=wolframscript
alias vi=nvim
alias v=nvim
alias "cact=conda activate"
alias "csql=mysql -u root -p"
alias "cst=speedtest -P 8 --selection-details --progress-update-interval=100 -u auto-decimal-bits"
alias "cvst=speedtest -vvv -P 8 --selection-details --progress-update-interval=100 -u auto-decimal-bits"
alias "vimrc=vi ~/.vimrc"
alias "zshrc=vi ~/.zshrc"
alias "tsr=npx ts-node"
alias "hpy=/opt/homebrew/bin/python"
alias "adbftc=adb connect 192.168.43.1:5555"
alias "mcrconct=mcrcon 31.214.128.151 -p 50605 --password chisato_takina"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/martingwq/.oh-my-zsh"
source ~/.bash_profile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME=robbyrussell

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unsetopt autocd

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


[ -f "/Users/martingwq/.ghcup/env" ] && source "/Users/martingwq/.ghcup/env" # ghcup-env
# Entry point for Depthai demo app, enables to run <depthai_launcher> in terminal
export PATH=$PATH:/Users/martingwq/Luxonis/depthai/entrypoint

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh --cmd cd)"

PATH=~/.console-ninja/.bin:$PATH

export PATH="$PATH:/Users/martingwq/ch-darwin-arm64"
