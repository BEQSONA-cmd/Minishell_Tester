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
clientfile="$HOME/Minishell_Tester/client"
test=("ls" "ls -la" "ls -l" "pwd" "export" "env" "echo hello" "echo here")

execute_command_in_bash() 
{
    local command="$1"
    eval "$command"
}

execute_command_in_minishell() 
{
    local pid="$1"
    local command="$2"
    local send="$clientfile $pid \"$command\""
    eval "$send"
}

test_commands() 
{
    for i in "${test[@]}"; do
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        if(( $? != 0 )); then
            echo -e "${RED}[Test failed] ❌${NC}"
            break
        else
            echo -e "${GREEN}[Test passed] ✅${NC}"
        fi
        sleep 1
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
            echo "minishell is not running"
        else
            execute_command_in_minishell "$pid" "$command"
            execute_command_in_bash "$command"
        fi
    history -s "$command"
    history -w
    else
        echo "pid.txt file not found"
    fi
done

# open pid.txt file and write 0
echo 0 > "$pidfile"