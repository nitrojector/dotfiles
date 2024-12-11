prependpath() {
  paths="$1"
  toadd="$2"
  case ":$paths:" in
    *:"$toadd":*)
      echo "$paths"
      ;;
    *)
      echo "$toadd${paths:+:$paths}"
      ;;
  esac
}

# Paths
# PATH="$(prependpath "$PATH" /)"
# PATH="$(prependpath "$PATH" "/usr/local/cuda-12/bin")"
# PATH="$(prependpath "$PATH" "/home/takina/Android/Sdk/platform-tools")"
PATH="$(prependpath "$PATH" "/opt/go/bin")"
# PATH="$(prependpath "$PATH" "/home/takina/.deno/bin")"
PATH="$(prependpath "$PATH" "~/.console-ninja/.bin:$PATH")"
PATH="$(prependpath "$PATH" "/mnt/c/Windows")"
PATH="$(prependpath "$PATH" "/mnt/c/Windows/System32")"

# Special paths
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
