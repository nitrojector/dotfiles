function dlk() {
	if [ -z "$1" ]; then
		echo "dlk"
		echo "Links files/dirs to a dotfiles repo under DOTFILES_DIR"
		echo "Usage: dlk <path>"
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

		local dotRelativePath="${fullPath#$HOME/}"
		local dotPath="$DOTFILES_DIR/$dotRelativePath"

		if [ -e "$dotPath" ]; then
			echo "Oh no! $dotPath already exists for $i, different client?"
			continue
		fi

		# save path if dir
		if [ -d "$fullPath" ]; then
			touch "$DOTFILES_DIR/.linked_dirs"
			echo "$dotRelativePath" >> "$DOTFILES_DIR/.linked_dirs"
		fi

		# Link items
		mkdir -p "$(dirname "$dotPath")"
		mv -n  "$fullPath" "$dotPath"
		ln -s "$dotPath" "$fullPath" && echo "(Link) $dotPath <-> $fullPath"
	done
}
