#!/bin/bash
###########################
Author: Saad Ur Rehman
###########################


#### task 1 ####
function task1_q1 {
	echo "Hello everyone!"
	 #<--- delete this colon in all functions when starting work on the task
}

function task1_q2 {
	read -p "Please enter your name: " uname
	echo "Welcome, $uname, to my Cyber Operations assessment"
	#remember, when prompting user for input use the command: 
	#read -p "<some text prompt>: " some_var 
	
}

function task1_q3 {
	read -p "Enter the first number: " num1
	read -p "Enter the second number: " num2
	echo "`expr $num1 \* $num2`"
}

function task1_q4 {
	read -p "Enter a value between 1 and 100: " num
	if [ $num -lt 50 ]
	then
		echo "Failed"
	else
		echo "Passed"
	fi
}

function task1_q5 {
	read -p "Enter a filename: " fname
	if [ -f $fname ]
	then
		echo "The file already exists"
	else
		touch $fname
	fi
}

#### task 2 ####
function task2_q1 {
	read -p "Enter a directory to search: " search_dir
	ls $search_dir/*.txt | xargs -n 1 basename
}

function task2_q2 {
	grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\#[0-9]\{1,2\}' dig_google.txt |
	while read IPwithHost
	do
		echo "$IPwithHost"
	done
}

function task2_q3 {
	exec 3<&0
	while IFS= read -r line || [ -n "$line" ]; do
    	printf '%s\n' "Store $line y or n: "
		read -r -u3 input
		if [ $input == "y" ]
		then
			echo $line >> saved_domains.txt
		fi
	done < "urls.txt"
}

function task2_q4 {
	#Loopback IPs
	grep -E -o '^127.*.*.*' ips.txt |
	while read IP
	do
		echo "$IP"
	done | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 >> loopback_ips.txt
	#done | sort -t . -k 3,3n -k 4,4n >> loopback_ips.txt

	#Suspect IPs
	#grep '^162.*.*.* | ^175.*.*.*' ips.txt |
	grep -E -o '^162.*.*.*|^175.*.*.*' ips.txt |
	while read IPs
	do
		echo "$IPs"
	done | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 >> suspect_ips.txt
	#done | sort -t . -k 3,3n -k 4,4n >> suspect_ips.txt
}

#### task 3 ####
function task3_q1 {
	#email address
	grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" webpage.html|
	while read email
	do
		#echo "$email" >> temp.txt
		echo "$email"
	done | sort -u >> emails.txt
	#sort -u temp.txt >> email.txt

	#phone number
	grep -Eo '\(?[[:digit:]]{5}\)?[[:space:]]?[[:digit:]]{6}' webpage.html > numbers.txt
	
}


function task3_q2 {
	#save weekly average to a file
	awk -F"," 'FNR>=2 { printf "%s %10.3f\n", $2, ($3+$4+$5+$6+$7)/5.0 }' user-list.txt | sort -nk2 > averages.txt

	#Computer use on wednesday
	hours=0
	#echo "\n" >> user-list.txt
	awk -F, 'FNR>1 { hours += $5 } END { print hours/10; }' user-list.txt > wednesday.txt

	#Superusers
	#awk -F, '$2~/[24680]$/{for(i=3;i<=7;i++){a+=$i};printf "%s\t%.2g\n",$2,a/5;a=0}'
	#user-list.txt > superuser.txt

	awk -F, '
	$2~/[24680]$/{
	count++
	for(x=3;x<=7;x++){
		sumx+=$x
	}
	total+=sumx/5
	sumx=0
	}
	END{
	print (count?total/count:"NaN")
	}
	' user-list.txt > superuser.txt

	#-----------Logged on Monday-----------------
	#awk -F, 'NR == 1 { next } $3 > 0 { arr[$2]="" } END { PROCINFO["sorted_in"]="@ind_str_asc";for (x in arr) { print x } }' user-list.txt > login.txt
	
	while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 || [[ -n $col1 ]]
	do
		if [ $col3 -gt 0 ] 
		then
			echo "$col2"
		fi
	done < <(tail -n+2 user-list.txt) | sort -k1.5,1.7n > login.txt
	
}


task1_q1
task1_q2
task1_q3
task1_q4
task1_q5
task2_q1
task2_q2
task2_q3
task2_q4
task3_q1
task3_q2
