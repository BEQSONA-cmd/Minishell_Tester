export new
export | grep new
env | grep new
unset new
export new
env | grep new
export new=/tmp/new
env | grep new
env | grep new
export VAR1="Hello"
export VAR2="World"
export | grep VAR
env | grep VAR
echo $VAR1 | tee file1
echo $VAR2 | tee file2
unset VAR1
export | grep VAR1
env | grep VAR1
export VAR1="Hello Again"
env | grep VAR1
cat file1
cat file2
rm file1 file2
export USER_VAR1="Test1" USER_VAR2="Test2"
export | grep USER_VAR
env | grep USER_VAR
echo $USER_VAR1 >file1
echo $USER_VAR2 >file2
head -n 1 file1
head -n 1 file2
unset USER_VAR1
export | grep USER_VAR1
env | grep USER_VAR1
rm file1 file2
export CURRENT_DATE=$(date)
export | grep CURRENT_DATE
env | grep CURRENT_DATE
echo $CURRENT_DATE >date_file
cat date_file
unset CURRENT_DATE
export | grep CURRENT_DATE
env | grep CURRENT_DATE
rm date_file
export TMP_VAR1="Variable1" TMP_VAR2="Variable2"
export | grep TMP_VAR
env | grep TMP_VAR
echo $TMP_VAR1 >file1
echo $TMP_VAR2 >file2
paste file1 file2 >file3
unset TMP_VAR1 TMP_VAR2
export | grep TMP_VAR
env | grep TMP_VAR
rm file1 file2 file3
export SYS_INFO=$(uname -a)
echo $SYS_INFO | tee file1 | wc -w >file2
cat file1
cat file2
export | grep SYS_INFO
env | grep SYS_INFO
unset SYS_INFO
export | grep SYS_INFO
env | grep SYS_INFO
rm file1 file2
export COMBINED_VAR=$(hostname)_$(whoami)
echo $COMBINED_VAR | tee file1 | grep "_"
export | grep COMBINED_VAR
env | grep COMBINED_VAR
unset COMBINED_VAR
export | grep COMBINED_VAR
env | grep COMBINED_VAR
rm file1
export LOAD_AVG=$(uptime | awk '{print $10}')
export | grep LOAD_AVG
env | grep LOAD_AVG
echo $LOAD_AVG >load_avg_file
cat load_avg_file
unset LOAD_AVG
export | grep LOAD_AVG
env | grep LOAD_AVG
rm load_avg_file
export DYNAMIC_VAR=$(date +%s)_$RANDOM
export | grep DYNAMIC_VAR
env | grep DYNAMIC_VAR
echo $DYNAMIC_VAR >dynamic_var_file
cat dynamic_var_file
unset DYNAMIC_VAR
export | grep DYNAMIC_VAR
env | grep DYNAMIC_VAR
rm dynamic_var_file
