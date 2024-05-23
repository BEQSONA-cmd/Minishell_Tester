#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

HISTSIZE=1000
exit_cmd="exit"
test_cmd="test"
HISTFILESIZE=1000
HISTFILE=~/.minishell_history
pidfile="$HOME/Minishell_Tester/pid.txt"
clientfile="$HOME/Minishell_Tester/client.py"
test_echo="$HOME/Minishell_Tester/tests/echo.csh"
test_export="$HOME/Minishell_Tester/tests/export.csh"
bashfile="$HOME/Minishell_Tester/compare/bash_output.csh"
minishellfile="$HOME/Minishell_Tester/compare/minishell_output.csh"

test=()
while IFS= read -r line; do
    test+=("$line")
done < "$test_echo"

test2=()
while IFS= read -r line; do
    test2+=("$line")
done < "$test_export"

execute_command_in_bash() 
{
    local command="$1"
    eval "$command"
    output=$(eval "$command")
    echo "$output" > "$bashfile"
}

execute_command_in_minishell() 
{
    local pid="$1"
    local command="$2"
    local send="python3 $clientfile $pid \"$command\""
    eval "$send"
}


# get testing command here also and print what command is testing 
compare_output() 
{
    local command="$1"
    bash_output=$(cat "$bashfile")
    minishell_output=$(cat "$minishellfile")
    if [ "$bash_output" == "$minishell_output" ]; then
        echo -e "${GREEN}[$i] (Test passed) ✅${NC}"
    else
        echo -e "${RED}[$i] (Test failed) ❌${NC}"
        # uncomment the line below to see the difference between the two outputs
        # diff -y --suppress-common-lines "$bashfile" "$minishellfile"
    fi
}

test_commands() 
{
    echo -e "${YELLOW}Running 'echo' tests...${NC}"
    for i in "${test[@]}"; do
        if [[ "$i" == *"echo"*"\""* ]]; then
            execute_command_in_minishell "$pid" "$i"
            execute_command_in_bash 'echo "Hello" World'
        else
            execute_command_in_minishell "$pid" "$i"
            execute_command_in_bash "$i"
        compare_output
        sleep 0.5
        fi
    done
    echo -e "${YELLOW}Running 'export' tests...${NC}"
    for i in "${test2[@]}"; do
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        compare_output
        sleep 0.5
    done
}


while true; do
    Bash="Reallyshell~"
    path=$(pwd | sed "s|/home/$(whoami)||")
    prompt="$(echo -e ${GREEN}$Bash${NC})$path$ "
    read -ep "$prompt" command
    if [ "$command" == "$exit_cmd" ]; then
        break
    elif [ "$command" == "$test_cmd" ]; then
        test_commands
    fi

    if [[ -f "$pidfile" ]]; then
        pid=$(<"$pidfile")
        if [ "$pid" -eq 0 ]; then
            execute_command_in_bash "$command"
        else
            execute_command_in_minishell "$pid" "$command"
            sleep 0.0001
            execute_command_in_bash "$command"
            # compare_output
        fi
    history -s "$command"
    history -w
    else
        echo "pid.txt file not found"
    fi
done
