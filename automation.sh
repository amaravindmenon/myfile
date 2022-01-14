#!usr/bin/bash

echo " My script ";

/Users/aravind/go/bin/nuclei --update-templates --silent

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
/Users/aravind/go/bin/subfinder -d $i | /Users/aravind/go/bin/httpx >> bugs/$i/subdomains.txt

echo "Subdomains Saved"
echo "scan for cves started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/cves -o bugs/$i/cves.txt
echo "scan for vulnerabilities started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/vulnerabilities -o bugs/$i/vuln.txt
echo "scan for takeover started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/takeovers -o bugs/$i/takeover.txt
echo "scan for exposures started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/exposures -o bugs/$i/exposures.txt
echo "scan for fuzz started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/fuzzing -o bugs/$i/fuzz.txt
echo "scan for panel started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/exposed-panels -o bugs/$i/panel.txt
echo "scan for default-login started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/default-logins -o bugs/$i/login.txt
echo "scan for misconf started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/misconfiguration -o bugs/$i/misconf.txt
echo "scan for misconf started"
/Users/aravind/go/bin/nuclei -l bugs/$i/subdomains.txt -t /Users/aravind/nuclei-templates/file -o bugs/$i/files.txt
echo "Nuclei scan completed"


echo "Scan For Log4j"
python3 log4j-scan/log4j-scan.py -l bugs/$i/subdomains.txt --headers-file log4j-scan/headers.txt> bugs/$i/log4j-check.txt
python3 log4j-scan/log4j-scan.py -l bugs/$i/subdomains.txt --test-CVE-2021-45046 --headers-file log4j-scan/headers.txt > bugs/$i/log4j-cve-check.txt
echo "Log4 scan Completed File saved"


echo "Scan for takeovers again"
python3 subdomain-takeover/takeover/takeover.py -l bugs/$i/subdomains.txt -o bugs/$i/takeover-test.txt
echo "Scan completed"

echo "IDOR Test"
/Users/aravind/go/bin/waybackurls $i | /Users/aravind/go/bin/gf idor | egrep -iv ".(jpg|jpeg|gif|tif|tiff|ico|pdf|svg|png|css|woff|woff2)" > bugs/$i/idorfile.txt
echo "IDOR saved"

echo "Clickjacking test"
python3 Clickjacking-Tester/Clickjacking_Tester.py bugs/$i/subdomains.txt
echo "Clickjacking test done"

echo "XSS Hunting using gf and dalfox and xsstrike"
/Users/aravind/go/bin/waybackurls $i > bugs/$i/temp_waybackxss.txt
cat bugs/$i/temp_waybackxss.txt | /Users/aravind/go/bin/gf xss | sed 's/=.*/=/' | egrep -iv ".(jpg|jpeg|gif|tif|tiff|ico|pdf|svg|png|css|woff|woff2)" > bugs/$i/temp2_waybackxss.txt
sort bugs/$i/temp2_waybackxss.txt | uniq -i > bugs/$i/waybackxss.txt
cat bugs/$i/waybackxss.txt | /Users/aravind/go/bin/dalfox pipe -o bugs/$i/dalfoxoutput.txt
python3 XSStrike/xssattack.py bugs/$i/waybackxss.txt
echo "XSSATACK FINISH"

done


:'
URL REDIRECTION with grep and gf pattern

/Users/aravind/go/bin/waybackurls testphp.vulnweb.com | /Users/aravind/go/bin/gf redirect | /Users/aravind/go/bin/qsreplace 'https://evil.com' > gffile.txt
/Users/aravind/go/bin/waybackurls testphp.vulnweb.com | grep -a -i \=http | /Users/aravind/go/bin/qsreplace 'https://evil.com' > grep.txt
cat *.txt > urlredirect.txt
cat urlredirect.txt |while read host do;do curl -s -L $host -I| grep "evil.com" && echo "$host \033[0;31mVulnerable\n" ; done

Openresirect tool
python3 openredirex.py -l urlredirect.txt -p payloads.txt > redirects.txt
'


