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
  cp ~/Minishell_Tester/Minishell_test.py .
  make
  python3 Minishell_test.py
  rm Minishell_test.py
else
  echo "Makefile not found"
  echo -e "${RED}please run this script in the root of your project${RESET}"
  pkill -f get_pid.py
  echo 0 > $HOME/Minishell_Tester/pid.txt
  exit 1
fi

pkill -f get_pid.py

echo 0 > $HOME/Minishell_Tester/pid.txt