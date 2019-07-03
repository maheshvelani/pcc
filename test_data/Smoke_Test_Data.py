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


# Test Data for Server as Node
# Update This data as per supported Server over PCC server
server_node_name = "sv8"
server_node_host = "172.17.2.101"
server_bmc_host = "172.17.3.101"
server_bmc_user = "ADMIN"
server_bmc_pwd = "ADMIN"
server_console = "ttyS1"
server_managed_by_pcc = "true"
server_ssh_keys = "pcc"




node2_name = "i31"
node2_host_addr = "172.17.2.29"
node2_bmc = "172.17.3.29"
node2_bmc_user = "ADMIN"

node3_name = "i32"
node3_host_addr = "172.17.2.29"
node3_bmc = "172.17.3.29"
node3_bmc_pwd = "ADMIN"

node4_name = "i33"
node4_host_addr = "172.17.2.29"
node4_bmc = "172.17.3.29"
node4_bmc_user = "ADMIN"
node4_bmc_pwd = "ADMIN"

node5_name = "i99"
node5_host_addr = "172.17.4.29"

group1_name = "Test_Group"
group1_desc = "Test_Group"
group2_name = "Test_Group_2"
group2_desc = "Test_Group_2"

role1_name = "test_role"
role1_desc = "test_role"
role1_id = 4

role2_name = "test_role_2"
role2_desc = "test_role_2"
role2_id = 4

site1_name = "test_site1"
site1_desc = "test_site1"
site2_name = "test_site2"
site2_desc = "test_site2"
site3_name = "@#%$@"
site3_desc = "@#%$@"
site4_name = "updated_site"
site4_desc = "updated_site"
site5_name = "test_site5"
site5_desc = "test_site5"
site6_name = "test_site6"
site6_desc = "test_site6"
site7_name = "test_site7"
site7_desc = "test_site7"

tenant1_name = "test01_tenant"
tenant1_desc = "test01_tenant"
tenant2_name = "test02_tenant"
tenant2_desc = "test02_tenant"
tenant3_name = "test03_tenant"
tenant3_desc = "test03_tenant"

delete_site_err = """pq: update or delete on table "sites" violates foreign key constraint"""
