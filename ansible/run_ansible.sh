#!/bin/bash
set +ex

# todo genereate inventory.yml file with ec2 host
cd ../infra
terraform output make_inventory > ../ansible/inventory.yml


# todo add any additional variables
cd ../ansible 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml -e 'record_host_keys=True' -u ec2-user playbook.yml --extra-vars "ansible_sudo_pass=123456"