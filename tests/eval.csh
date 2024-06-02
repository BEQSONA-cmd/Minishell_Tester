ls
echo hello
echo hello world
ls -l
ls -la
echo $?
bin/ls filethatdoesntexist
expr $?
expr $? $?
echo $?
ls
ls -la
echo 'USER'
echo $USER
env | grep USER_ZD
env | grep USER=
env | grep OLDPWD
export | grep USER
export | grep OLDPWD
export new
export | grep new
export new=HELLO
export | grep new
export hello=home/wazaap
unset new
export | grep new
unset home/wazaap
export | grep hello
unset hello
export | grep hello
cd ls
cd something
cd
cd Desktop/Minishell/minishell
cd ..
cd ..
cd Minishell/minishell
pwd
cd ..
pwd
cd ..
pwd
cd Minishell/minishell
dsbksdgbksdghsd
echo $USER
export USER=NEWUSER
echo $USER
