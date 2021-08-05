#!/bin/bash
#
# Email:          vitorpaulasantos@gmail.com
# Author:         Vitor de Paula Santos
# Maintenance:    Vitor de Paula Santos
# --------------------------------------------------------- #
# ChangeLog:
#
#     v1.0 23/07/2021
#
# --------------------------------------------------------- #
# Pega os arquivos que contem os ips das insntacias slaves
# e escreve tudo no arquivo de hosts do ansible
#
# ------------------------ Main --------------------------- #
sudo apt update
sudo apt-get install -y ansible

for VALUE in 0 1; do
    echo "[testing_ansible]" >> /etc/ansible/hosts
    cat private_ip_slave_$VALUE.txt >> /etc/ansible/hosts
done
# --------------------------------------------------------- #