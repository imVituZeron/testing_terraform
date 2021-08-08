#!/bin/bash
#
# Email:          vitorpaulasantos@gmail.com
# Author:         Vitor de Paula Santos
# Maintenance:    Vitor de Paula Santos
# --------------------------------------------------------- #
# ChangeLog:
#
#     v1.0 23/07/2021
#     v1.0 04/08/2021
#
# --------------------------------------------------------- #
#  Seleciona as instancias atravez dos public_dns adquiridos no tfstate.
#  Logo depois ele insere alguns arquivos nas instancias pelas funções
# 
#  A instancia master recebe um arquivo yaml, para o ansible
#
# ------------------------- Variables ----------------------------- #
PUBLIC_DNS=$(cat terraform.tfstate | grep "public_dns" | cut -d'"' -f4)
PRIVATE_ARRAY=($(cat terraform.tfstate | grep "private_ip" | grep -v "secondary_private_ips" | cut -d'"' -f4 ))
INSTANCE_NAME="ubuntu"
PATH_SCRIPT="./scripts/install_ansible.sh"
PATH_SCRIPT_ANSIBLE="./scripts/playbook.yml"
COUNT=0
# ------------------------------------------------------------------ #
# ---------------------------- Functions --------------------------- #
insert_files_in_instance(){
   echo "---------- slave -----------------"
   scp $PATH_SCRIPT $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   echo "---------------------------"
}

insert_files_in_instance_master(){
   echo "------------ master ---------------"
   scp $PATH_SCRIPT_ANSIBLE $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./text_files/private_ip_slave_0.txt $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./text_files/private_ip_slave_1.txt $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./scripts/install_ansible_config_master.sh $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   echo "---------------------------"
}
# ------------------------------------------------------------------ #
# --------------------------- Main --------------------------------- #
if [ -d "./text_files" ]; then
   rm -rf ./text_files
   mkdir text_files
fi

sudo chmod 777 $PATH_SCRIPT
sudo chmod 777 $PATH_SCRIPT_ANSIBLE
sudo chmod 777 ./scripts/install_ansible_config_master.sh

# creating ip address files.
for VALUE in ${PRIVATE_ARRAY[*]}; do
   if [ $COUNT -ne 2 ]; then
      echo $VALUE >> ./text_files/private_ip_slave_$COUNT.txt
      sudo chmod 777 ./text_files/private_ip_slave_$COUNT.txt
   fi
   COUNT=$[$COUNT + 1]
done

COUNT=0

for VALUE in $(echo $PUBLIC_DNS); do 
   echo "Instance = $VALUE"
   if [ $COUNT -eq 2 ]; then
      insert_files_in_instance_master
   else
      insert_files_in_instance
   fi
   COUNT=$[$COUNT + 1]
done
# ------------------------------------------------------------------ #



