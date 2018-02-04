# Folder

* /etc/ansible/
* /bin/ansible/
* Module
** ${HOME}/.ansible/plugins/modules/
** /usr/share/ansible/plugins/modules/
** /usr/lib/python2.7/site-packages/ansible/modules/

# Ansible Sample

* Inventory file : /etc/ansible/hosts
ansible ~ -i /work/conf/hosts -m ~ -a "~"

cd  /service/service_sw/Ansible
ansible-playbook -v -i /work/conf/hosts /service/service_sw/Ansible/playbook/test.yml
ansible-playbook -v -i /work/conf/hosts /service/service_sw/Ansible/playbook/obcon.yml

