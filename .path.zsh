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
PATH="$(prependpath "$PATH" "/usr/sbin")"
PATH="$(prependpath "$PATH" "/usr/local/cuda-12/bin")"
PATH="$(prependpath "$PATH" "${HOME}/Android/Sdk/platform-tools")"
PATH="$(prependpath "$PATH" "/opt/go/bin")"
PATH="$(prependpath "$PATH" "${HOME}/.deno/bin")"
PATH="$(prependpath "$PATH" "~/.console-ninja/.bin:$PATH")"
PATH="$(prependpath "$PATH" "$VCPKG_ROOT")"

# Special paths
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
