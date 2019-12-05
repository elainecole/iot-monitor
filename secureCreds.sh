#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "USAGE: $0 <vulnerable ip list>"
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m'
command -v expect >/dev/null 2>&1 || { 
    echo "*********";
    echo -e >&2 "${RED} expect not installed.${NC}";
    echo "*********";
    echo "sudo apt-get install expect" ;
    echo "--------------------"
    exit 1; 
}



file=$1 
IFS=$'\n' read -d '' -r -a lines < $1
# printf "line 1: %s\n" "${lines[1]}"

own_ip=$(hostname -I)

for i in "${lines[@]}"
do

    # echo "Vunerable Machine : $i"
    # echo "Would you like to change the default password of vulnerable devices? "
    username=$(echo $i | cut -d " " -f2)
    old_pass=$(echo $i | cut -d " " -f3)
    hostip=$(echo $i | cut -d " " -f1)

    
    if [ $hostip = $own_ip ] ; then
        echo "my ip is in the list"
        
    else
        echo "Vunerable Machine : $i"
        echo "Would you like to change the default password of vulnerable devices? "
        while true; do 
            read -p "Y/n :" ans
            #echo $ans
                case $ans in
                    'Y') 
                        echo "What would you like the new password to be?";
                        read -sp 'Password: ' passvar;
                        echo " ";
                        ./ssh_change $username $old_pass $passvar $hostip >/dev/null
                        break ;;
                    'n') 
                        echo ".";
                        echo ".";
                        echo ".";
                        sleep 1;
                        break ;;
                    *) echo "Invalid Response";;
                esac
        done
    fi



done

