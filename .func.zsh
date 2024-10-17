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

function fontinstall() {
  # Check if the font directory exists
  if [[ ! -d "$HOME/.fonts" ]]; then
	mkdir "$HOME/.fonts"
  fi

  # Copy the font files to the font directory
  cp "$@" "$HOME/.fonts"

  # Update the font cache
  fc-cache -f -v
}

function fontinstallzip() {
  # Check if the font directory exists
  if [[ ! -d "$HOME/.fonts" ]]; then
	mkdir "$HOME/.fonts"
  fi

  # Extract the font files from the ZIP archive
  unzip -j "$1" -d "$HOME/.fonts"

  # Update the font cache
  fc-cache -f -v
}

function readme() {
	if [ -f "README.md" ]; then
		nvim README.md
	elif [ -f "readme.md" ]; then
		nvim readme.md
	elif [ -f "README" ]; then
		nvim README
	elif [ -f "readme" ]; then
		nvim readme
	else
		nvim README.md
	fi
}

function tmuxr() {
	/usr/bin/tmux new -As $1
}

function rebootwin() {
	sudo grub-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"
	sudo reboot
}

function update() {
	sudo apt update
	sudo apt upgrade
	sudo apt full-upgrade

	brew update
	brew cask upgrade

	sudo snap refresh
}

function dpi() {
  sudo dpkg -i $1

  if [ $? -eq 0 ]
  then
    echo Finished
  else
    echo "Dependency error? Trying that..."
    sudo apt-get -f install
  fi

  if [ $? -eq 0 ]
  then
    echo Finished
    mkdir -p ~/Downloads/installed
    mv $1 ~/Downloads/installed
  else
    echo "Failed to install $1"
  fi
}

function ins() {
    # Get the command type from the first argument
    cmd_type="$1"
    shift  # Remove the command type from the arguments
    # Now, $@ contains the package names

    # Handle the "all" case
    if [[ "$cmd_type" == "all" ]]; then
        echo "all"
        return
    fi

    # Define command prefixes and region markers based on cmd_type
    case "$cmd_type" in
        apt | apt-get)
            CMD_PREFIX=(sudo apt install)
            REGION_START="@apt"
            REGION_END="!apt"
            ;;
        brew)
            CMD_PREFIX=(brew install)
            REGION_START="@brew"
            REGION_END="!brew"
            ;;
        snap)
            CMD_PREFIX=(snap install)
            REGION_START="@snap"
            REGION_END="!snap"
            ;;
        flatpak)
            CMD_PREFIX=(flatpak install)
            REGION_START="@flatpak"
            REGION_END="!flatpak"
            ;;
		aptrepo)
			CMD_PREFIX=(sudo add-apt-repository)
            REGION_START="@add-apt-repository"
            REGION_END="!add-apt-repository"
            ;;
        *)
            echo "Unknown command type: $cmd_type"
            return 1
            ;;
    esac

    # Execute the installation command
    "${CMD_PREFIX[@]}" "$@"
    exit_status=$?

    PKG_FILE="$HOME/.pkg.list"

    if [[ $exit_status -eq 0 ]]; then
        # Command succeeded, proceed to update the package list file
        if [[ -f "$PKG_FILE" ]]; then
            # Read the file into an array
            file_lines=("${(f)$(< "$PKG_FILE")}")
            in_region=0
            region_start_line=-1
            region_end_line=-1
            region_lines=()

            # Find the region enclosed by REGION_START and REGION_END
            for i in {1..${#file_lines[@]}}; do
                line="${file_lines[$i]}"
                if [[ "$line" == "$REGION_START" ]]; then
                    in_region=1
                    region_start_line=$i
                    continue
                fi
                if [[ "$line" == "$REGION_END" ]]; then
                    in_region=0
                    region_end_line=$i
                    break
                fi
                if [[ $in_region -eq 1 ]]; then
                    region_lines+=("$line")
                fi
            done

            if [[ $region_start_line -eq -1 ]]; then
                # Region not found, append new region at the end
                echo "$REGION_START" >> "$PKG_FILE"
                for pkg in "$@"; do
                    echo "$pkg" >> "$PKG_FILE"
                done
                echo "$REGION_END" >> "$PKG_FILE"
                echo "Updated $PKG_FILE with new region $REGION_START...$REGION_END"
            else
                # Region found, update it without duplicates
                if [[ $region_end_line -eq -1 ]]; then
                    region_end_line=${#file_lines[@]}
                fi
                for pkg in "$@"; do
                    if ! printf '%s\n' "${region_lines[@]}" | grep -qxF $'\t'"$pkg"; then
                        region_lines+=($'\t'"$pkg")
                    fi
                done
                # Reconstruct the file with updated region
                new_file_lines=()
                for ((i=1; i<region_start_line; i++)); do
                    new_file_lines+=("${file_lines[$i]}")
                done
                new_file_lines+=("$REGION_START")
                new_file_lines+=("${region_lines[@]}")
                new_file_lines+=("$REGION_END")
                for ((i=region_end_line+1; i<=${#file_lines[@]}; i++)); do
                    new_file_lines+=("${file_lines[$i]}")
                done
                printf '%s\n' "${new_file_lines[@]}" > "$PKG_FILE"
                echo "Updated $PKG_FILE in region $REGION_START...$REGION_END"
            fi
        else
            # File doesn't exist, create it with the new region
            echo "$PKG_FILE not found, creating it."
            {
                echo "$REGION_START"
                for pkg in "$@"; do
                    echo "$pkg"
                done
                echo "$REGION_END"
            } > "$PKG_FILE"
            echo "Created $PKG_FILE with region $REGION_START...$REGION_END"
        fi
    else
        echo "Command failed with exit status $exit_status -> $PKG_FILE not updated."
    fi
}

