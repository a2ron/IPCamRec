#!/bin/bash

mkdir -p ${DIST} ${RECORDS_PATH}

# vpn
if [ "$VPN" == "yes" ]; then

    # to query instance metadata
    route add 169.254.170.2 gw 172.17.0.1 eth0 

    # vpns0="US"
    # vpns1="FR"
    # random=$(awk -v min=0 -v max=1 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
    # eval vpn="\$vpns$random"
    # vpnRegion="$vpn"
    vpnRegion="FR"

    cd /etc/vpn
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
    
    vpnFile=$(ls /etc/vpn/*.ovpn | grep $vpnRegion | shuf -n 1)
    echo $vpnFile
    cp "$vpnFile" /etc/vpn/conf.ovpn
    echo "auth-user-pass /etc/vpn/ovpn.user.conf" >> /etc/vpn/conf.ovpn 
    openvpn /etc/vpn/conf.ovpn  2>&1 >> /etc/vpn/log.log &
    sleep 3
    rm ${WD}/taint 2> /dev/null
    grep "Initialization Sequence Completed" /etc/vpn/log.log
    echo $? > ${WD}/taint
    cd ${WD}
    wget -qO- ifconfig.co > ip.txt
    echo "IP: $(cat ip.txt)"
fi

# tail -f /dev/null
sh scripts/record.sh 