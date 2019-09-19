############################################
#
# Test Data File for the PCC OS Deployment
#
############################################


# PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.212:9999"
user_name = "admin"
user_pwd = "admin"

# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader1_node_name = "i61"
invader1_node_host = "172.17.2.61/23"

# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server1_node_name = "sv16"
server1_node_host = "172.17.2.116/23"
server1_bmc_host = "172.17.3.116/23"
server1_bmc_user = "ADMIN"
server1_bmc_pwd = "ADMIN"
server1_console = "ttyS1"
server1_managed_by_pcc = "true"
server1_ssh_keys = "pcc"


# OS Deployment data
image1_name = "centos76"
image2_name = "ubuntu-bionic"
image3_name = "ubuntu-disco"
image4_name = "ubuntu-cosmic"
image5_name = "debian-stretch"
image6_name = "centos75"
image7_name = "ubuntu-xenial"
en_US = "en_US"
PDT = "PDT"
mass_user = "pcc"
ssh_key = "['pcc']"

