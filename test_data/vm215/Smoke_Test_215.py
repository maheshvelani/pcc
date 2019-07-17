     ##########################################
#
# Test Data File for the PCC Smoke Test
#
##########################################


 # PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.215:9999"
user_name = "admin"
user_pwd = "admin"

 #Node data
total_node = 2
total_server = 4

 # Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader1_node_name = "i61"
invader1_node_host = "172.17.2.61"

invader2_node_name = "i62"
invader2_node_host = "172.17.2.62"


 # Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server1_node_name = "sv16"
server1_node_host = "172.17.2.116"
server1_bmc_host = "172.17.3.116"
server1_bmc_user = "ADMIN"
server1_bmc_pwd = "ADMIN"
server1_console = "ttyS1"
server1_managed_by_pcc = "true"
server1_ssh_keys = "pcc"

server2_node_name = "sv17"
server2_node_host = "172.17.2.117"
server2_bmc_host = "172.17.3.117"
server2_bmc_user = "ADMIN"
server2_bmc_pwd = "ADMIN"
server2_console = "ttyS1"
server2_managed_by_pcc = "true"
server2_ssh_keys = "pcc"

server3_node_name = "sv18"
server3_node_host = "172.17.2.118"
server3_bmc_host = "172.17.3.118"
server3_bmc_user = "ADMIN"
server3_bmc_pwd = "ADMIN"
server3_console = "ttyS1"
server3_managed_by_pcc = "true"
server3_ssh_keys = "pcc"

server4_node_name = "sv19"
server4_node_host = "172.17.2.119"
server4_bmc_host = "172.17.3.119"
server4_bmc_user = "ADMIN"
server4_bmc_pwd = "ADMIN"
server4_console = "ttyS1"
server4_managed_by_pcc = "true"
server4_ssh_keys = "pcc"



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


# Site Creation Data
create_site_name = "automation_site"
create_site_desc = "automation_site"


# Assign Sites To Node
# Please make sure Site name is present in Site list
# before select Site name
# By Default it will assign "automation_site" site to node
assign_site_name = "automation_site"


# Tenant Creation Data
create_tenant_name = "automation_tenant"
create_tenant_desc = "automation_tenant"


 # Assign Tenant To Node
# Please make sure Tenant name is present in Tenant list
# before select Tenant name
# By Default it will assign "automation_tenant" tenant to node
assign_tenant_name = "automation_tenant"
