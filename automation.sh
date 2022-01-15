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
subfinder -d $i | httpx >> bugs/$i/subdomains.txt

echo "Subdomains Saved"
echo "scan for cves started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/cves -o bugs/$i/cves.txt
echo "scan for vulnerabilities started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/vulnerabilities -o bugs/$i/vuln.txt
echo "scan for takeover started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/takeovers -o bugs/$i/takeover.txt
echo "scan for exposures started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/exposures -o bugs/$i/exposures.txt
echo "scan for fuzz started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/fuzzing -o bugs/$i/fuzz.txt
echo "scan for panel started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/exposed-panels -o bugs/$i/panel.txt
echo "scan for default-login started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/default-logins -o bugs/$i/login.txt
echo "scan for misconf started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/misconfiguration -o bugs/$i/misconf.txt
echo "scan for misconf started"
nuclei -l bugs/$i/subdomains.txt -t nuclei-templates/file -o bugs/$i/files.txt
echo "Nuclei scan completed"

echo "XSS Hunting using gf and dalfox and xsstrike"
waybackurls $i > bugs/$i/temp_waybackxss.txt
cat bugs/$i/temp_waybackxss.txt | gf xss | sed 's/=.*/=/' | egrep -iv ".(jpg|jpeg|gif|tif|tiff|ico|pdf|svg|png|css|woff|woff2)" > bugs/$i/temp2_waybackxss.txt
sort bugs/$i/temp2_waybackxss.txt | uniq -i > bugs/$i/waybackxss.txt
cat bugs/$i/waybackxss.txt | dalfox pipe -o bugs/$i/dalfoxoutput.txt
echo "XSSATACK FINISH"

done



