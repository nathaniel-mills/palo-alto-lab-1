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

#MAKE SURE THE PASSWORD IS THE SAME AS CONFIGURED WITH ANSIBLE
palo_username = 'admin'
palo_password = 'CiscoPalo123!'

object_name = 'cloudflare_1'

object_value = '1.1.1.1'



from panos.firewall import Firewall

from panos.objects import AddressObject
#alternatively instead of importing module the whole library can be imported:
#import panos

fw = Firewall((mgmt_eip), (palo_username), (palo_password))


webserver = AddressObject((object_name), (object_value))
fw.add(webserver)
webserver.create()
fw.commit()