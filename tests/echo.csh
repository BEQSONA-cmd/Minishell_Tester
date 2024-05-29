echo "Hello World"
echo Hello World
echo "\"hello\"" world
echo 'hello world'
echo 'hello' world
echo $$
echo $0
echo $?
echo $#
echo $HOME
echo $PWD
echo $USER
echo $SHELL
echo $$ | tee pid_file | grep -o '[0-9]*'
echo $0 | tee script_name_file | grep "bash"
echo $? | tee last_status_file | grep "0"
echo $# | tee arg_count_file | grep "0"
rm pid_file script_name_file last_status_file arg_count_file
echo "Path is:" $PATH | tee path_file | grep ":"
echo "Date is:" $(date) | tee date_file | cut -d ' ' -f 1-3
echo "Hostname is:" $(hostname) | tee hostname_file | wc -c
echo "Uptime is:" $(uptime) | tee uptime_file | grep "up"
rm path_file date_file hostname_file uptime_file
echo $(ls -l) | tee ls_file | wc -l
echo $(whoami) | tee user_file | xargs echo "User is"
echo $(date +%F) | tee date_file | cut -d '-' -f 1
echo $(uname -r) | tee kernel_file | cut -d '.' -f 1
rm ls_file user_file date_file kernel_file
