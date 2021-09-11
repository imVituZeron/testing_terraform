#!/bin/bash
#
# Email:          vitorpaulasantos@gmail.com
# Author:         Vitor de Paula Santos
# Maintenance:    Vitor de Paula Santos
# --------------------------------------------------------- #
# ChangeLog:
#
#     v1.04/07/2021
#
# --------------------------------------------------------- #
# Pega os arquivos que contem os ips das insntacias slaves
# e escreve tudo no arquivo de hosts do ansible
#
# ------------------------ Main --------------------------- #
sudo apt update
sudo apt-get install -y ansible
sudo chmod 777 $HOME/ansible/inventory.yml
sudo ssh-keygen

echo "[lab_ansible]" >> $HOME/ansible/inventory.yml
for VALUE in 0 1; do
    cat private_ip_slave_$VALUE.txt >> $HOME/ansible/inventory.yml
done
# --------------------------------------------------------- #