#!/bin/bash

RED="\033[91m"
GREEN="\033[92m"
BLUE="\033[94m"
RESET="\033[0m"
file="Makefile"

get_pid_file="$HOME/Minishell_Tester/get_pid.py"

if pgrep -f get_pid.py > /dev/null; then
    echo "get_pid.py is already running"
else
    (python3 $get_pid_file && echo done)>/dev/null & disown
    echo "get_pid.py started"
fi

if [ -e "$file" ]; then
  cp ~/Minishell_Tester/connect.sh .
else
  echo "Makefile not found"
fi


function all_c_files 
{
    find . -type f -name '*.c' ! -path "./ft_destructor/*" ! -path "./libft/*"
}

function find_main_files 
{
    local c_files=("$@")
    local main_files=()
    local i=0

    for file in "${c_files[@]}"; do
        if grep -q "main(" "$file"; then
            main_files+=("$file")
            ((i++))
        fi
    done

    if [[ $i -gt 1 ]]; then
        local input_file=0
        while [[ $input_file -le 0 || $input_file -gt ${#main_files[@]} ]]; do
            echo -e "${RED}There are more than one main functions in the project${RESET}"
            for index in "${!main_files[@]}"; do
                echo -e "${RED}$((index + 1)).${GREEN} ${main_files[$index]}${RESET}"
            done
            read -p "$(echo -e "\n${BLUE}Type the number of the main function you want to use: ${RESET}")" input_file
            if [[ $input_file =~ ^[0-9]+$ ]] && [[ $input_file -le ${#main_files[@]} ]]; then
                echo "${main_files[$((input_file - 1))]}"
                return
            else
                input_file=0
            fi
        done
    elif [[ $i -eq 1 ]]; then
        echo "${main_files[0]}"
    else
        echo -e "${RED}There is no main function in the project${RESET}"
        return 1
    fi
}

func0="\tstruct sigaction sa;"
func1="\tsa.sa_handler = get_signal;"
func2="\tsa.sa_flags = 0;"
func3="\tsigemptyset(&sa.sa_mask);"
func4="\tsigaction(SIGUSR1, &sa, NULL);"
func5="\tsigaction(SIGUSR2, &sa, NULL);"

put_functions() {
    local main_file="$1"
    if [[ -z "$main_file" ]]; then
        return
    fi

    if grep -q "sa.sa_handler = get_signal;" "$main_file"; then
        echo -e "${RED}Functions are already in the file${RESET}"
        return
    fi

    local i=0
    local ft_alloc=0
    local count_brackets=0

    IFS=$'\n' read -d '' -r -a lines < "$main_file"

    exec 3> "$main_file"

    for line in "${lines[@]}"; do
        if [[ "$line" == *"main("* ]]; then
            i=1
        fi
        if [[ $i -gt 0 && "$line" == *"{"* ]]; then
            ((count_brackets++))
        fi
        if [[ $i -gt 0 && "$line" == *"{"* && $ft_alloc -eq 0 ]]; then
            echo "$line" >&3
            echo -e "\n$func0\n$func1\n$func2\n$func3\n$func4\n$func5\n" >&3
            ft_alloc=1
        else
            if [[ "$line" == *"#include"* ]]; then
                echo -e "\n" >&3
                echo "$line" >&3
                echo -e "\n" >&3
            else
                echo "$line" >&3
            fi
        fi
    done

    exec 3>&-
}

c_files=($(all_c_files))
main_file=$(find_main_files "${c_files[@]}")
put_functions "$main_file"

make re
bash connect.sh
rm connect.sh
pkill -f get_pid.py