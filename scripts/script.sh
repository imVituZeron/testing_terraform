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
PATH_SCRIPT_ANSIBLE = "./scripts/playbook.yml"
COUNT=0
# ------------------------------------------------------------------ #
# ---------------------------- Functions --------------------------- #
insert_files_in_instance(){
   sudo chmod 777 $PATH_SCRIPT
   scp $PATH_SCRIPT $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
}

insert_files_in_instance_master(){
   sudo chmod 777 $PATH_SCRIPT
   sudo chmod 777 $PATH_SCRIPT_ANSIBLE
   scp $PATH_SCRIPT $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
   scp $PATH_SCRIPT_ANSIBLE $INSTANCE_NAME@$VALUE:/home/$INSTANCE_NAME
}
# ------------------------------------------------------------------ #
# --------------------------- Main --------------------------------- #
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



