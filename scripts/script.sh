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
#  Seleciona as instancias atravez dos public_dns adquiridos no tfstate.
#  Logo depois ele insere alguns arquivos nas instancias pelas funções
# 
#  A instancia master recebe um arquivo yaml, para o ansible
#
# ------------------------- Variables ----------------------------- #
PUBLIC_DNS=$(cat terraform.tfstate | grep "public_dns" | cut -d'"' -f4)
INSTANCE_NAME="ubuntu"
PATH_SCRIPT="./scripts/install_ansible.sh"
PATH_SCRIPT_ANSIBLE="./scripts/playbook.yml"
COUNT=0
# ------------------------------------------------------------------ #
# ---------------------------- Functions --------------------------- #
insert_files_in_instance(){
   echo "---------- slave -----------------"
   scp $PATH_SCRIPT $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./text_files/public_dns_master.txt $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./scripts/config_slaves.sh $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   echo "---------------------------"
}

insert_files_in_instance_master(){
   echo "------------ master ---------------"
   scp $PATH_SCRIPT $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp $PATH_SCRIPT_ANSIBLE $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./text_files/public_dns_slave.txt $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp ./scripts/config_master.sh $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
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
sudo chmod 777 ./scripts/config_master.sh
sudo chmod 777 ./scripts/config_slaves.sh

for VALUE in $(echo $PUBLIC_DNS); do 
   echo "Instance = $VALUE"
   if [ $COUNT -eq 2 ]; then
      echo $VALUE >> ./text_files/public_dns_master.txt
   sudo chmod 777 ./text_files/public_dns_master.txt
      insert_files_in_instance_master
   else
      echo $VALUE >> ./text_files/public_dns_slave.txt
      sudo chmod 777 ./text_files/public_dns_slave.txt
      insert_files_in_instance
   fi
   COUNT=$[$COUNT + 1]
done
# ------------------------------------------------------------------ #



