#!/bin/bash

IFS=$'\n' # not really necessary
mkdir -p /home/PortMonitor
touch /home/PortMonitor/counter.txt
counter="0"
PORT=$1
INTERVAL=$2
declare -a IPAddresses

# Checking to see if JQ is installed.
if ! dpkg -s jq >/dev/null 2>&1; then
    echo -e "[-] jq is not installed.\nInstalling...\n"
    sudo apt-get install jq
fi

# Default to 443 if port was not given.
if [[ -z $1 ]]; then
    PORT="443"
fi

# Default to 60 seconds if interval was not given.
if [[ -z $2 ]]; then
    INTERVAL="60s"
fi

while true; do
    IPAddresses=$(ss -tn | grep :$PORT | awk '{print $5}' | cut -d: -f1 | sort | uniq)
    time="$(date +%Y-%m-%d-%H:%M:%S)"

    if [[ -z "$IPAddresses" ]]; then
        sleep 10s
        continue
    fi

    counter=$(cat /home/PortMonitor/counter.txt)

    for i in ${IPAddresses[@]}; do
        data=$(curl -s http://ip-api.com/json/$i)
        status=$(echo $data | jq '.status' -r)

        if [[ $status == "success" ]]; then
            country=$(echo $data | jq '.country' -r)
            city=$(echo $data | jq '.city' -r)
            regionName=$(echo $data | jq '.regionName' -r)
            isp=$(echo $data | jq '.isp' -r)
            as=$(echo $data | jq '.as' -r)
            org=$(echo $data | jq '.org' -r)

            counter=$((counter + 1))
            echo "$counter" >/home/PortMonitor/counter.txt
            {
                echo -e "\n********************************************************************\n"
                echo -e "Number:      $counter"
                echo -e "Time:        $time\n"
                echo -e "IP Address:  $i"
                echo -e "ISP:         $isp"
                echo -e "AS:          $as"
                echo -e "City:        $city"
                echo -e "Country:     $country"
                echo -e "Region:      $regionName"
                echo -e "ORG:         $org"
                echo -e "\n********************************************************************\n"
            } >>/home/PortMonitor/report.txt
        fi
    done
    sleep $INTERVAL
done
