## Instructions to run

### 1. Rename value for "name"
Find obi-wan in both folders and replace with your name.
Or it should only be present in the "variables.tf" and "state.tf files in each layer.
Layer 2 also has it in the "data.tf" file.

### 2. Double check your public IP
Check your public IP and make sure it is the same as what can be seen in the layer 1 "variables.tf" file.
This will be used to SSH and browse to the firewalls WebUI.

### 3. CD Into each layer
cd 01_env_init

### 4. Run Terraform
terraform init
terraform apply

### 5. To destroy
terraform init
terraform destroy
