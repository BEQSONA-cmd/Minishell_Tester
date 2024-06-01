ls -la >file1>file2>file3
cat file1
cat file2
cat file3
rm file1 file2 file3
ls -la >file4 >file5 >file6 file1 file2 file3
cat file1
cat file4
cat file5
cat file6
rm file1 file2 file3 file4 file5 file6
echo "Hello World" | tee file1 file2 file3
grep "Hello" file1
grep "World" file2
grep "!" file3
ls -la >file1 >file2 >file3
grep "ls" file1
grep "total" file2
grep "." file3
rm file1 file2 file3
date >file1
whoami >file2
ls -la file1 file2 file3
paste file1 file2 file3 >file4
ls -la file4
rm file1 file2 file3 file4
echo "Test Case 6" | tee file1 | tee file2 >file3
wc -l file1 file2 file3 | cat >file4
cat file4
ls -la >file3
ls -la >file1 >file2 >file3
wc -l file1 file2 file3 | cat >file4
cat file4
rm file1 file2 file3 file4
echo "Complex case" | tee file1 file2 | grep "Complex" >file3
cat file1
cat file2
cat file3
ls -l >file3
tail -n 1 file3
rm file1 file2 file3
hostname >file1
uname -a >file2
who >file3
paste file1 file2 >file4
paste file3 file4 >file5
ls -la >file4 >file5
tail -n 2 file4
tail -n 3 file5
rm file1 file2 file3 file4 file5
df -h >file1
free -m >file2
uptime >file3
cat file1 file2 >file4
cat file3 file4 >file5
ls -la >file5
wc -l file1 file2 file3 file4 file5 | cat >file6
cat file6
rm file1 file2 file3 file4 file5 file6
echo "Final Case" | tee file1 | tee file2 | tee file3 >file4
grep "Final" file1 file2 file3 file4
ls -la file1 file2 file3 file4
ls -l >file4
cat file4
rm file1 file2 file3 file4
