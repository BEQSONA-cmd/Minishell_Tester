import time
import subprocess

def background_task():
    file = "pid.txt"
    cmd = "ps aux | grep minishell | grep -iv grep"
    while True:
        pid = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)
        pid = pid.stdout.decode("utf-8")
        if pid:
            print(f"minishell is running with PID: {pid.split()[1]}")
            with open(file, "w") as f:
                f.write(pid.split()[1])
        else:
            print("minishell is not running")
            with open(file, "w") as f:
                f.write("0")
        time.sleep(1) 

if __name__ == "__main__":
    background_task()
