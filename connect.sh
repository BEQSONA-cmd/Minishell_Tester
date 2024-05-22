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
bashfile="$HOME/Minishell_Tester/bash_output.txt"
minishellfile="$HOME/Minishell_Tester/minishell_output.txt"
test=("ls -la" "ls -l" "echo Hello" "export new" "env" "export" "pwd")

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

compare_output() 
{
    bash_output=$(cat "$bashfile")
    minishell_output=$(cat "$minishellfile")
    if [ "$bash_output" == "$minishell_output" ]; then
        echo -e "${GREEN}[Test passed] ✅${NC}"
    else
        echo -e "${RED}[Test failed] ❌${NC}"
        # uncomment the line below to see the difference between the two outputs
        # diff -y --suppress-common-lines "$bashfile" "$minishellfile"
    fi
}

test_commands() 
{
    for i in "${test[@]}"; do
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
