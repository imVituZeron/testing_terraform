# Lab de terraform

Um projeto totalmente voltado para o aprendizado, onde com a ferramenta _terraform_ eu criei 3 instancias **ec2**, 2 arquivos de _shell script_ e um arquivo _yaml_ do ansible, tudo isso usando o provider **aws**

### script.sh

Dificuldades:

- Procurei uma forma de executar o arquivo ./scripts/script.sh pelo próprio terraform, achei o **null_resource** juntamente com o **local-exec** só que o problema é que ele executa antes das instancias serem criadas.
- Assim o script não consegue capturar as informações do tfstate e "rodar" normalmente.
 
### install_ansible.sh

Dificuldades:

- Encontrei uma forma do terraform executar o script assim que ele estiver criando as instancias com o **remote-exec** mas não consegui configurar corretamente os paramentros. Então decidi executar o script manualmente nas instancias.

### Observações

- Antes de executar o arquivos **install_ansible_config_master.sh**, lembre-se de entrar como usuario
root primeiro, pra depois executar:

```
 sudo su
 ./install_ansible_config_master.sh
```