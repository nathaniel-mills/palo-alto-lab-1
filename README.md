## Instructions before building the infrastructure


### 1. Retrieve Network Sandpit account credentials from SSO (If running this job locally)

### 2. Create the S3 bucket in Network Sandpit account for the TF-State file. Copy these commands in CLI (new line after region)
aws s3 mb s3://<bucket-name> --region <region>
aws s3api put-bucket-versioning --bucket <bucket-name> --versioning-configuration Status=Enabled --region <region>

### Example:

aws s3 mb s3://obi-wan-bucket-labs --region eu-west-1
aws s3api put-bucket-versioning --bucket obi-wan-bucket-labs --versioning-configuration Status=Enabled --region eu-west-1

### 3. Ensure your bucket name is referenced in both Terraform layers.
Select the 'state.tf' and change bucket name. Use your name instead of obi-wan.
In layer two make sure to change the 'state.tf' and 'data.tf' bucket names.

### 4. Enjoy and May the force be with you!!
 <br />

![alt text](diagrams/01_star_wars.jpeg)
