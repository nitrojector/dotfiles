#!/bin/zsh

SCRIPT_PATH=$(readlink -e -- "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
cd "$SCRIPT_DIR"

T_HOME=$HOME

EXLUDE_PAT='(^dfinstall\.zsh$)|(^df\.zsh$)|(^README\.md$)'
force_=0

if [ "$1" = "-f" ]; then
	force_=1
	echo "Running with -f, files will be overwritten."
fi

# confirm home dir
echo -n "Install dotfiles to \"$T_HOME\". OK? (y/N) "
read -r yn

if [[ ! $yn =~ ^[Yy]$ ]]; then
	echo "Abort."
	exit 1
fi


# link files
ls -Ap | grep -v / | while read -r line; do
	if [[ $line =~ $EXLUDE_PAT ]]; then
		continue
	fi

	if [ -e "$T_HOME/$line" ]; then
		if [ $force_ -eq 1 ]; then
			echo "force: File $T_HOME/$line already exists. Remove and link."
			rm "$T_HOME/$line"
		else
			echo "File $T_HOME/$line already exists. Skip."
			continue
		fi
	fi

	ln -s "$SCRIPT_DIR/$line" "$T_HOME/$line" && echo "(Link) $SCRIPT_DIR/$line <-> $T_HOME/$line"
done

# link dirs
while read -r p; do
	if [ -e "$T_HOME/$p" ]; then
		if [ $force_ -eq 1 ]; then
			echo "force: Dir $T_HOME/$p already exists. Remove and link."
			rm -r "$T_HOME/$p"
		else
			echo "Dir $T_HOME/$p already exists. Skip."
			continue
		fi
	fi

	mkdir -p $(dirname "$T_HOME/$p")
	ln -s "$SCRIPT_DIR/$p" "$T_HOME/$p" && echo "(Link) $SCRIPT_DIR/$line <-> $T_HOME/$line"
done < .linked_dirs

echo "Done."

