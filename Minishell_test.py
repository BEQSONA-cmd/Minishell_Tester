import subprocess
import threading
import asyncio
import signal
import time
import sys
import os

minishell = "./minishell"

def execute_command(proc, command):
    proc.stdin.write(command + '\n')
    proc.stdin.flush()
    output = ''
    while not output.endswith('$ '):
        output += proc.stdout.read(1)
    return output

def run_minishell(minishell):
    global proc
    proc = subprocess.Popen(
        minishell,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
        bufsize=1,
        universal_newlines=True
    )
    output = ''
    while not output.endswith('$ '):
        output += proc.stdout.read(1)

    while True:
        command = input("Enter command: ")
        if command.strip().lower() == 'exit':
            break
        output = execute_command(proc, command)
        print(output.strip())

    proc.stdin.write('exit\n')
    proc.stdin.flush()
    proc.terminate()

def handle_signal(signum, frame):
    with open("/tmp/signal_data.txt", "r") as file:
        data = file.read()
        output = execute_command(proc, data)
        print(output.strip())


if __name__ == "__main__":
    signal.signal(signal.SIGUSR1, handle_signal)
    run_minishell(minishell)
