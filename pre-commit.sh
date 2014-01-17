#!/bin/bash

FILES_TO_CHECK=$(git status | grep -e '\#.*\(modified\|new file\)'| egrep "(.php|.module|.inc|.install)" | awk '{print $NF}')
ERRORS=""

echo -e "\n=============="
echo -e "= PHP pre commit verification"
echo -e "=============="



for FILE in $FILES_TO_CHECK; do
	echo -ne "Checking \e[01;33m$FILE\e[00m..."
	ERROR=$(php -l $FILE 2>&1 | grep "Parse error")
	if [ "$ERROR" == "" ]; then
		echo -e "\e[00;34mOK\e[00m"
	else
		echo -e "\e[00;31mERROR\e[00m"
		ERRORS="$ERRORS\n$FILE => $ERROR"
	fi
done

if [ "$ERRORS" == "" ]; then
	echo -e "\e[01;32mAll seems to be OK... proceed to commit...\e[00m"
else
	echo -e "\e[00;31mErrors where encountered processing files.\e[00m"
	echo -e $ERRORS
	echo "=========="
	echo "Exiting"
	exit 1
fi
