#!/bin/bash

# colors usage : ${RED}Possible base 64 detected :${NC}
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m'
command -v nmap >/dev/null 2>&1 || { 
    echo "*********";
    echo -e >&2 "${RED} nmap not installed.${NC}";
    echo "*********";
    echo "sudo apt install nmap" ;
    echo "--------------------"
    exit 1; 
}



# rm tmp_ip.txt 2>/dev/null
rm ip_vulnerable.txt 2>/dev/null
echo "-----Scanning for devices in the network-----"
getip=$(hostname -I | cut -d "." -f1-3)

#initial identification of machines in the network
nmap -n -sn ${getip}.1/24

# touch tmp_ip.txt
arp -a -n  | grep -v incomplete | awk '{print $2}' | tr -d '()' > tmp

#max_ip=$(sort -r tmp | grep -m1 "" | cut -d '.' -f4)
max_ip=$(sort -r -t . -k 3,3n -k 4,4n tmp | tail -n 1 | cut -d '.' -f4)
#echo $max_ip

echo "-----checking for open port 22-------"

#echo "---PORT 22 ---" >> ip_vulnerable.txt
result22=$(nmap -PN -p 22 --open -oG - ${getip}.0-$max_ip | awk '$NF~/ssh/{print $2}' )
echo "$result22" >> ip_vulnerable.txt
echo -e "${GREEN}done ${NC}"

echo "-----checking for open port 23-------"

# echo "---PORT 23 ---" >> ip_vulnerable.txt
result23=$(nmap -PN -p 23 --open -oG - ${getip}.0-$max_ip | awk '$NF~/telnet/{print $2}')
# echo "$result23" >> ip_vulnerable.txt
echo -e "${GREEN}done ${NC}"

echo "-----Showing results-------"
cat ip_vulnerable.txt

