echo "Hello World"
echo Hello World
echo 'hello world'
echo 'hello' world
echo $?
echo $HOME
echo $PWD
echo $USER
echo $SHELL
echo "Date is:" $(date) | tee date_file | cut -d ' ' -f 1-3
rm date_file
echo $(ls -l) | tee ls_file | wc -l
echo $(whoami) | tee user_file | xargs echo "User is"
echo $(date +%F) | tee date_file | cut -d '-' -f 1
echo $(uname -r) | tee kernel_file | cut -d '.' -f 1
rm ls_file user_file date_file kernel_file
