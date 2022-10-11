## Instructions to run

### 1. Rename value for "name"
Find obi-wan in the "variables.yml" file and change it to the same name used with Terraform.

### 2. Optional - set memorable admin login password for the firewall
Within the "variables.yml" file again change the password. Initially it is mandatory to use the "admin" user.

### 3. Install the requirements
ansible-galaxy install -r requirements.yml

### 4. Run the playbooks
ansible-playbook -vvv set_firewall_password.yml

ansible-playbook -vvv configure_firewall.yml