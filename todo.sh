#!/bin/bash

DIR="${HOME}/.todo"

write_todo="${EDITOR} ${DIR}/todo-$(date +%Y%m%d).txt"
read_todo="grep -EvH \"^\+\" ${DIR}/todo*.txt | perl -pe \"s#${DIR}/todo-(\d{4})(\d{2})(\d{2})\.txt#\\\$1-\\\$2-\\\$3#g\""

usage() {
	echo "Usage: $0 [OPTION]
	-r		Read TODO;
	-w		Write TODO."
	exit 0
}

if [ ${#} -eq 0 ]; then
	usage
elif [ ${1} == "-w" ]; then
	eval ${write_todo}
elif [ ${1} == "-r" ]; then
	eval ${read_todo}
fi

