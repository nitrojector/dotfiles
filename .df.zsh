function dlk() {
	local VERBOSE=0

	if [ -z "$1" ]; then
		echo "Links a file/dir to dotfiles repo"
		echo "Usage: dlk <path to file>"
		return 1
	fi

	if [ ! -d "$DOTFILES_DIR" ]; then
		echo "Error: \$DOTFILESDIR ($DOTFILES_DIR) undefined, doesn't exist, or not a directory"
		return 1
	fi

	for i in "$@"; do
		# Check if file exists
		if [ ! -e "$i" ]; then
			echo "Error: $i not found, ignored"
			continue
		fi

		# Get full path of source
		local fullPath

		if [[ "$i" == "/"* ]]; then
			fullPath="$i"
		else
			fullPath="$PWD/$i"
		fi

		# Check for valid path
		if [[ "$fullPath" != "$HOME/"* ]]; then
			echo "Error: $i is not a path in home dir, ignored"
			continue
		fi

		if [[ "$fullPath" == "$DOTFILES_DIR/"* ]]; then
			echo "Error: No way you are linking a file in dotfiles to dotfiles, ignored!"
			continue
		fi

		if [ -h "$fullPath" ]; then
			echo "$PWD/$i is already a symlink, ignored"
			continue
		fi

		local dotRelPath="$DOTFILES_DIR/${fullPath#$HOME/}"


		if [ -d "$dotRelPath" ]; then
			echo "Oh no! $dotRelPath already exists for $i, different machine?"
			continue
		fi

		echo "(Link) $dotRelPath <-> $fullPath"

		mkdir -p "$(dirname "$dotRelPath")"
		mv -n  "$fullPath" "$dotRelPath"
		ln -s "$dotRelPath" "$fullPath"
	done
}

