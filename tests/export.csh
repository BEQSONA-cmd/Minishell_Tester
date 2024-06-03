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
echo $VAR1 | grep VAR1 > file1
echo $VAR2 | grep VAR2 > file1
unset VAR1
export | grep VAR1
env | grep VAR1
export VAR1="Hello_Again"
env | grep VAR1
cat file1
cat file2
rm file1 file2
export new=/tmp/new
export | grep new | tee file1
cat file1
rm file1
export USER_VAR1="Test1" USER_VAR2="Test2"
export | grep USER_VAR
env | grep USER_VAR1
env | grep USER_VAR2
echo $USER_VAR1 | grep USER_VAR1 > file1
echo $USER_VAR2 | grep USER_VAR2 > file2
cat file1
cat file2
unset USER_VAR1
export | grep USER_VAR1
env | grep USER_VAR1
rm file1 file2
export TMP_VAR1="Variable1" TMP_VAR2="Variable2"
export | grep TMP_VAR
env | grep TMP_VAR1
env | grep TMP_VAR2
echo $TMP_VAR1 | grep TMP_VAR1 > file1
echo $TMP_VAR2 | grep TMP_VAR2 > file2
unset TMP_VAR1 TMP_VAR2
export | grep TMP_VAR
env | grep TMP_VAR
rm file1 file2 file3
echo $SYS_INFO | cat > file1 | wc -w >file2
cat file1
cat file2
unset SYS_INFO
export | grep SYS_INFO
env | grep SYS_INFO
rm file1 file2 file3 file4
export COMBINED_VAR=$(hostname)_$(whoami)
echo $COMBINED_VAR | grep COMBINED_VAR > file1
cat file1
export | grep COMBINED_VAR
env | grep COMBINED_VAR
unset COMBINED_VAR
export | grep COMBINED_VAR
env | grep COMBINED_VAR
rm file1
export LOAD_AVG=$(uptime | awk '{print $10}')
export | grep LOAD_AVG
env | grep LOAD_AVG
echo $LOAD_AVG | cat > load_avg_file
cat load_avg_file
unset LOAD_AVG
export | grep LOAD_AVG
env | grep LOAD_AVG
rm load_avg_file
