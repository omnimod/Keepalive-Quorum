#! /bin/bash
ip_string="192.168.1.11 192.168.1.12 192.168.1.13"
hosts=0
count=0

for i in $ip_string
do
    count=$((count+1))
    ping -c 1 -w 1 $i 1>/dev/null 2>/dev/null
    result=$?

    if [ $result -eq 0 ]
    then
        hosts=$((hosts+1))
    fi
done

if [ $hosts -le $(($count/2)) ]
then 
   exit 1
fi
exit 0
#EOF