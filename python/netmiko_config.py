#!/usr/bin/env python3
import boto3
import json
import os

#CHANGE MY NAME
name = "obi-wan"

#Get the EIP

AWS_REGION = "eu-west-1"
EC2_CLIENT = boto3.client('ec2', region_name=AWS_REGION)

response = EC2_CLIENT.describe_addresses(
    Filters=[
        {
            'Name': 'tag:Name',
            'Values': [f'palo-fw-workshop-{name}-eip-mgmt']
        }
    ]
)

print('EIP attributes:')

for address in response['Addresses']:
    print(json.dumps(address, indent=4))

#Print in a decent JSON format

print(json.dumps(address, indent=4))

print('Management EIP: ')

mgmt_eip = (response['Addresses'][0]['PublicIp'])

#Print filtered IP
print(mgmt_eip)



print('Connect to the firewall to create the object')

from netmiko import ConnectHandler

#MAKE SURE THE PASSWORD IS THE SAME AS CONFIGURED WITH ANSIBLE
palo_username = 'admin'
palo_password = 'CiscoPalo123!'

object_name = 'google_dns_2'

object_value = '8.8.4.4'

config_commands = (f'set address {object_name} ip-netmask {object_value}')


virtual_palo = {
	'device_type': 'paloalto_panos',
	'host':   mgmt_eip,
	'username': palo_username,
	'password': palo_password,
}

net_connect = ConnectHandler(**virtual_palo)

output = net_connect.send_config_set(config_commands, exit_config_mode=False)
print(output)

output = net_connect.commit()
print(output)