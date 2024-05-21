import subprocess
import readline
import signal

minishell = "./minishell"

g_nline = 0

def find_prompt(output):
    lines = output.split('\n')
    return lines[-1] if lines else '\0'

def execute_command(proc, command):
    proc.stdin.write(command + '\n')
    proc.stdin.flush()
    output = ''
    while not output.endswith('$ '):
        output += proc.stdout.read(1)
    return output

def sort_ls(output):
    output_lines = output.strip().split('\n')
    output_lines = output_lines[1:-1]
    output_lines = '  '.join(output_lines)
    return output_lines

def remove_first_and_last_line(output):
    find = "minishell: (null): command not found"

    if find in output:
        return find
    
    if "ls\n" in output or "ls -a\n" in output:
        output = sort_ls(output)
        g_nline = 1
        return output

    output_lines = output.strip().split('\n')
    if len(output_lines) > 1:
        output_without_first_and_last = '\n'.join(output_lines[1:-1])
    else:
        output_without_first_and_last = ''
    return output_without_first_and_last.strip()

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
        command = input(find_prompt(output))
        if command.strip().lower() == 'exit':
            break
        output = execute_command(proc, command)
        output_lines = remove_first_and_last_line(output)
        if not output_lines:
            continue
        else:
            print(output_lines)

    proc.stdin.write('exit\n')
    proc.stdin.flush()
    proc.terminate()


def handle_signal(signum, frame):
    with open("/tmp/signal_data.txt", "r") as file:
        data = file.read()
        output = execute_command(proc, data)
        output_lines = remove_first_and_last_line(output)
        if g_nline == 1:
            print("\n\n")

        if not output_lines:
            pass
        else:
            print(output_lines)
        print(find_prompt(output))
        readline.add_history(data)

if __name__ == "__main__":
    readline.parse_and_bind('tab: complete')
    signal.signal(signal.SIGUSR1, handle_signal)
    run_minishell(minishell)
