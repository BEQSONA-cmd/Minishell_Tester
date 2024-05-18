import time
import subprocess

home = subprocess.run("echo $HOME", shell=True, stdout=subprocess.PIPE)
home = home.stdout.decode("utf-8").strip()
file = home + "/Minishell_Tester/pid.txt"

def background_task():
    cmd = "ps aux | grep minishell | grep -iv grep"
    while True:
        pid = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)
        pid = pid.stdout.decode("utf-8")
        if pid:
            with open(file, "w") as f:
                f.write(pid.split()[1])
        else:
            with open(file, "w") as f:
                f.write("0")
        time.sleep(1) 

if __name__ == "__main__":
    background_task()
