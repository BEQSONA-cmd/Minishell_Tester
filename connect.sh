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
test_eval="$HOME/Minishell_Tester/tests/eval.csh"
test_echo="$HOME/Minishell_Tester/tests/echo.csh"
test_export="$HOME/Minishell_Tester/tests/export.csh"
bashfile="$HOME/Minishell_Tester/compare/bash_output.csh"
test_redirect="$HOME/Minishell_Tester/tests/redirect.csh"
minishellfile="$HOME/Minishell_Tester/compare/minishell_output.csh"

test=()
while IFS= read -r line; do
    test+=("$line")
done < "$test_echo"

test2=()
while IFS= read -r line; do
    test2+=("$line")
done < "$test_export"

test3=()
while IFS= read -r line; do
    test3+=("$line")
done < "$test_redirect"

test4=()
while IFS= read -r line; do
    test4+=("$line")
done < "$test_eval"

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
    local command="$1"
    
    bash_output=$(cat "$bashfile")
    minishell_output=$(cat "$minishellfile")
    minishell_length=${#minishell_output}
    bash_output_sub=${bash_output:0:minishell_length}
    
    if [ "$bash_output" == "$minishell_output" ]; then
        echo -e "${GREEN}[$i] (Test passed) ✅${NC}"
        ((success++))
    else
        echo -e "${RED}[$i] (Test failed) ❌${NC}"
        ((failed++))
    fi
}

test_commands() 
{
    success=0
    failed=0
    total=0
    echo -e "${YELLOW}Running 'eval' tests...${NC}"
    for i in "${test4[@]}"; do
        total=$((total+1))
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        compare_output
        sleep 0.1
    done
    echo -e "${YELLOW}Running 'echo' tests...${NC}"
    execute_command_in_bash "mkdir test1 test2"
    sleep 0.5
    execute_command_in_minishell "$pid" "cd test1"
    execute_command_in_bash "cd test2"
    for i in "${test[@]}"; do
        total=$((total+1))
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        compare_output
        sleep 0.1
    done
    execute_command_in_minishell "$pid" "cd .."
    sleep 0.1
    execute_command_in_bash "cd .."
    execute_command_in_bash "rm -rf test1 test2"
    echo -e "${YELLOW}Running 'export' tests...${NC}"
    execute_command_in_bash "mkdir test1 test2"
    sleep 0.5
    execute_command_in_minishell "$pid" "cd test1"
    execute_command_in_bash "cd test2"
    for i in "${test2[@]}"; do
        total=$((total+1))
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        compare_output
        sleep 0.1
    done
    execute_command_in_minishell "$pid" "cd .."
    sleep 0.1
    execute_command_in_bash "cd .."
    execute_command_in_bash "rm -rf test1 test2"
    echo -e "${YELLOW}Running 'redirect' tests...${NC}"
    execute_command_in_bash "mkdir test1 test2"
    sleep 0.5
    execute_command_in_minishell "$pid" "cd test1"
    execute_command_in_bash "cd test2"
    for i in "${test3[@]}"; do
        total=$((total+1))
        execute_command_in_minishell "$pid" "$i"
        execute_command_in_bash "$i"
        compare_output
        sleep 0.1
    done
    execute_command_in_minishell "$pid" "cd .."
    sleep 0.1
    execute_command_in_bash "cd .."
    execute_command_in_bash "rm -rf test1 test2"

    success_rate=$((success*100/total))
    failed_rate=$((failed*100/total))
    echo -e "${YELLOW}Total tests: $total${NC}"
    echo -e "${GREEN}Success rate: $success_rate%${NC}"
    echo -e "${RED}Failed rate: $failed_rate%${NC}"
    echo -e "${YELLOW}Tests completed!${NC}"
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
