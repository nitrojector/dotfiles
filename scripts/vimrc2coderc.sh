#!/bin/bash

VIMRC_REG="$HOME/.vimrc"
VIMRC_CODE="$HOME/.code.vimrc"

LOG_FILE="$(dirname "$0")/log/vimrc2coderc.log"

# Clear code vimrc
touch $VIMRC_CODE
echo "" > $VIMRC_CODE

# Create log file
mkdir -p $(dirname "$LOG_FILE")
touch $LOG_FILE

INVALID_REGION=0
LINE_NO=0
SKIP_START=0

c_out() {
	echo "$*"
	echo "$*" >> $LOG_FILE
}

c_out $(date +"%Y/%m/%d %T %Z")

while IFS= read -r line; do
	((LINE_NO++))

	if [[ $line == *"VSCODE_UNSUPPORTED_BEGIN"* ]]; then
		SKIPPED_COUNT=0
		INVALID_REGION=1
		SKIP_START=$LINE_NO
	elif [[ $line == *"VSCODE_UNSUPPORTED_END"* ]]; then
		SKIP_END=$((SKIP_START + SKIPPED_COUNT))
		c_out "Skipped $SKIP_START:$SKIP_END => $SKIPPED_COUNT lines"
		INVALID_REGION=0
		continue
	fi

	if [ $INVALID_REGION -eq 0 ]; then
		echo "$line" >> $VIMRC_CODE
	else
		((SKIPPED_COUNT++))
	fi
done < "$VIMRC_REG"
