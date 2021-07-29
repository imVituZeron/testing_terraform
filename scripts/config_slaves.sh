#!/bin/bash
#
# Email:          vitorpaulasantos@gmail.com
# Author:         Vitor de Paula Santos
# Maintenance:    Vitor de Paula Santos
# --------------------------------------------------------- #
# ChangeLog:
#
#     v1.0 28/07/2021
#
#
# ----------------------- Variable --------------------- #
DNS_MASTER=$(cat ~/public_dns_master.txt)
DATE=$(date)
KEY="ssh_key.txt"
INSTANCE_NAME="ubuntu"
# -------------------------------------------------------#
# ------------------------ Main ------------------------ #
if [ -e "ip.txt" ] && [ -e "logs_ips.txt" ];then
    echo "file already readed and IP ADDRESS sended!"
else
    sudo hostname -I >> ip.txt
    chmod 777 ip.txt
    scp ~/ip.txt $INSTANCE_NAME@$DNS_MASTER:/home/$INSTANCE_NAME
    echo "IP ADDRESS sended [ $DATE ]" >> logs_ips.txt
fi

if [ -e "logs_key.txt" ];then
    echo "already was configured the key!"
elif [ -e $KEY ]; then
    cat $KEY >> ~/.ssh/authorized_keys
    echo "SSH KEY configured [ $DATE ]" >> logs_key.txt
else 
    echo "file not found"
fi
# -------------------------------------------------------- #