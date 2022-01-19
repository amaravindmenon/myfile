#!usr/bin/bash

echo " My script ";

nuclei --update-templates --silent

read -p "Enter domain name => " input
for i in ${input[@]}
do
echo "
.
.
.
scan started for $i
"

mkdir bugs/$i

amass enum -passive -norecursive -noalts -d $i -o bugs/$i/domain.txt
cat bugs/$i/domain.txt | httpx -o bugs/$i/domainhttpx.txt
cat bugs/$i/domainhttpx.txt | nuclei -t /root/nuclei-templates

done



