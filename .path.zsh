path_prepend() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

path_prepend "/Users/martingwq/bin"
path_prepend "/Users/martingwq/bin/waifu2x-ncnn-vulkan"
path_prepend "/Users/martingwq/Library/Android/sdk/platform-tools"
path_prepend "/opt/homebrew/Cellar/libusb/1.0.26/lib"
path_prepend "/Users/martingwq/ch-darwin-arm64"
path_prepend "/opt/homebrew/bin"
path_prepend "/usr/local/go/bin"
path_prepend "/usr/bin"
path_prepend "/Users/martingwq/Luxonis/depthai/entrypoint"
path_prepend "~/.console-ninja/.bin"
path_prepend "/Library/PostgreSQL/17/bin"
