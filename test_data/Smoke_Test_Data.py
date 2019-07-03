##########################################
#
# Test Data File for the PCC Smoke Test
#
##########################################


# PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.216:9999"
user_name = "admin"
user_pwd = "admin"

# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader_node_name = "i58"
invader_node_host = "172.17.2.58"


# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server_node_name = "sv8"
server_node_host = "172.17.2.101"
server_bmc_host = "172.17.3.101"
server_bmc_user = "ADMIN"
server_bmc_pwd = "ADMIN"
server_console = "ttyS1"
server_managed_by_pcc = "true"
server_ssh_keys = "pcc"


# Test Data for Group Creation
create_group_name = "automation_group"
create_group_desc = "automation_group"


# Assign Group To Node
# Please make sure group name is present in group list
# before select group name
# By Default keep it as "automation_group" as we are creating this
# group just before group assignment test
assign_group_name = "automation_group"


# Node Role Creation Data
# It will assign ROOT as role Tenant
create_role_name = "automation_role"
create_role_desc = "automation_role"


# Assign Roles To Node
# Please make sure role name is present in role list
# before select group role
# By Default it will assign "LLDP" roles to node
assign_role_name = "LLDP"
