#!/bin/zsh

SCRIPT_DIR=
SCRIPT_PATH=$(readlink -e -- "$0")
if [ $? -ne 0 ]; then
  echo "readlink didn't work, we assume dotfiles dir to be pwd (make sure that's right!)"
  echo "pwd: $PWD"
  SCRIPT_DIR=$PWD
else
  SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
fi

cd "$SCRIPT_DIR"

T_HOME=$HOME

EXCLUDE_PAT='(^dfinstall\.zsh$)|(^df\.zsh$)|(^README\.md$)|(^\.linked_dirs$)|(^.*\.swp$)'
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
ls -Ap | grep -v / | while read -r p; do
	echo $p
	if [[ $p =~ $EXCLUDE_PAT ]]; then
		continue
	fi

	echo "\"$T_HOME/$p\""
	if [ -e "$T_HOME/$p" ] || [ -L "$T_HOME/$p" ]; then
		if [ $force_ -eq 1 ]; then
			echo "force: File $T_HOME/$p already exists. Remove and link."
			rm "$T_HOME/$p"
		else
			if [ -L "$T_HOME/$p" ]; then
				echo "File $p already exist symbolicly. Probably already linked. Skip."
				continue
			fi
			echo "File $p already exists, and is not symbolic. Run with -f to overwrite."
			continue
		fi
	fi

	ln -s "$SCRIPT_DIR/$p" "$T_HOME/$p" && echo "(Link) $SCRIPT_DIR/$p <-> $T_HOME/$p"
done

# link dirs
while read -r p; do
	if [ -e "$T_HOME/$p" ] || [ -L "$T_HOME/$p" ]; then
		if [ $force_ -eq 1 ]; then
			echo "force: Dir $T_HOME/$p already exists. Remove and link."
			rm -r "$T_HOME/$p"
		else
			if [ -L "$T_HOME/$p" ]; then
				echo "Dir $p already exist symbolicly. Probably already linked. Skip."
				continue
			fi
			echo "Dir $p already exists, and is not symbolic. Run with -f to overwrite."
			continue
		fi
	fi

	mkdir -p $(dirname "$T_HOME/$p")
	ln -s "$SCRIPT_DIR/$p" "$T_HOME/$p" && echo "(Link) $SCRIPT_DIR/$line <-> $T_HOME/$line"
done < .linked_dirs

echo "Done."

