rmv() {
  local backup_dir="$HOME/.rmv"
  local rmv_count=0
  local err_count=0

  # Ensure at least one argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: rmv <file_pattern>"
    return 1
  fi

  # Create the backup directory if it doesn't exist
  mkdir -p "$backup_dir"

  # Loop over all arguments (which can be expanded wildcard patterns)
  for file in "$@"; do
    # Check if the file exists and is a regular file (not a directory)
    if [[ ! -f "$file" ]]; then
      echo "Error: '$file' is not a file or does not exist."
      continue
    fi

    # Get the base name of the file (i.e., the file name without the path)
    local filename=$(basename "$file")
    local backup_file="$backup_dir/$filename"

    # Check if the file already exists in the backup directory
    if [[ -e "$backup_file" ]]; then
      # Prompt the user for confirmation
      read "response?A backup already exists for '$filename'. Overwrite? (y/n): "
      case "$response" in
        [yY][eE][sS]|[yY])
          ;;
        *)
          echo "Skipping '$file'."
          continue
          ;;
      esac
    fi

    # Copy the file to the backup directory
    cp "$file" "$backup_file"

    # Verify the copy was successful
    if [[ $? -ne 0 ]]; then
      echo "Error#($err_count): Failed to create backup of '$file'."
      ((err_count++))
      continue
    fi

    rm "$file"

    # Check if the secure remove was successful
    if [[ $? -eq 0 ]]; then
      ((rmv_count++))
    else
      echo "Error($err_count): Failed to securely remove '$file'."
      ((err_count++))
    fi
  done

  echo "Successfully removed $rmv_count files"
  echo "There were $err_count errors"
}

function cliprun() {
	eval "$(pbpaste)"
}

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
