import subprocess
import readline
import signal
import os

minishell = "./minishell"

minishellfile = os.path.expanduser("~/Minishell_Tester/minishell_output.txt")

g_nline = 0

def find_prompt(output):
    lines = output.split('\n')
    return lines[-1] if lines else '\0'

def execute_command(proc, command):
    proc.stdin.write(command + '\n')
    proc.stdin.flush()
    output = ''
    while not output.endswith(end_prompt):
        output += proc.stdout.read(1)
    return output

def remove_first_and_last_line(output):
    find = "minishell: (null): command not found"

    if find in output:
        return find
    
    output_lines = output.strip().split('\n')
    if len(output_lines) > 1:
        output_without_first_and_last = '\n'.join(output_lines[1:-1])
    else:
        output_without_first_and_last = ''
    return output_without_first_and_last.strip()

def get_prompt_end(proc):
    prompts = ''
    global end_prompt
    end_prompt = ''
    for i in range(100):
        prompts += proc.stdout.read(1)
        if prompts.endswith('> '):
            end_prompt = '> '
            break
        if prompts.endswith('$ '):
            end_prompt = '$ '
            break
        if prompts.endswith('# '):
            end_prompt = '# '
            break
        if prompts.endswith('% '):
            end_prompt = '% '
            break
    return prompts
    
def run_minishell(minishell):
    global proc
    global end_prompt

    proc = subprocess.Popen(
        minishell,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
        bufsize=1,
        universal_newlines=True
    )
    output = get_prompt_end(proc)

    while True:
        command = input(find_prompt(output))
        if command.strip().lower() == 'exit':
            break
        output = execute_command(proc, command)
        output_lines = remove_first_and_last_line(output)
        if not output_lines:
            with open(minishellfile, "w") as file:
                file.write("\n")
            continue
        else:
            with open(minishellfile, "w") as file:
                file.write(output_lines)
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
            with open(minishellfile, "w") as file:
                file.write("\n")
            pass
        else:
            with open(minishellfile, "w") as file:
                file.write(output_lines)
            print(output_lines)
        print(find_prompt(output))
        readline.add_history(data)

if __name__ == "__main__":
    readline.parse_and_bind('tab: complete')
    signal.signal(signal.SIGUSR1, handle_signal)
    run_minishell(minishell)
