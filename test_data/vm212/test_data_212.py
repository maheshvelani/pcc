############################################
#
# Test Data File for the PCC Entry Criteria
#
############################################

# PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.212:9999"
user_name = "admin"
user_pwd = "admin"

# Invalid credentials
invalid_server_url = "https://172.17.2.477:9999"
invalid_user_name = "invaliduser"
invalid_user_pwd  = "invalidpwd"

# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server

# Node Data
total_node = 2
total_server = 4

node1_name = "i43"
node2_name = "i42"

invader1_node_name = "i43"
invader1_node_host = "172.17.2.43/23"
invader1_ip = "172.17.2.43"
invader1_usr_name = "pcc"
invader1_usr_pwd = "cals0ft"

invader2_node_name = "i42"
invader2_node_host = "172.17.2.42/23"
invader2_ip = "172.17.2.42"
invader2_usr_name = "pcc"
invader2_usr_pwd = "cals0ft"

# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server1_node_name = "sv124"
server1_node_host = "172.17.2.125/23"
server1_bmc_ip = "172.17.3.125"
server1_bmc_user = "ADMIN"
server1_bmc_pwd = "ADMIN"
server1_console = "ttyS1"
server1_managed_by_pcc = "true"
server1_ssh_keys = "pcc"


# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server2_node_name = "sv110"
server2_node_host = "172.17.2.110/23"
server2_bmc_host = "172.17.3.110"
server2_bmc_user = "ADMIN"
server2_bmc_pwd = "ADMIN"
server2_console = "ttyS1"
server2_managed_by_pcc = "true"
server2_ssh_keys = "pcc"


# Credentials to access invader via ssh
invader_usr_name = "pcc"
invader_usr_pwd = "cals0ft"


# OS Deployment data
image1_name = "centos76"
image2_name = "ubuntu-bionic"
image3_name = "ubuntu-disco"
image4_name = "ubuntu-cosmic"
image5_name = "debian-stretch"
image6_name = "centos75"
image7_name = "ubuntu-xenial"
locale = "en_US"
PDT = "PDT"
admin_user = "pcc"
ssh_key = "pcc"


# K8S Cluster Test data
cluster_name = "calsoft"
cluster_version = "v1.14.3"
cni_plugin = "kube-router"


# App installation data
app_name = "iperf-app"
git_url = " https://github.com/platinasystems/devops"
git_branch = "master"
git_repo_path = "helm-charts"

# App installation data
app2_name = "nginxapp"
git2_url = " https://github.com/platinasystems/devops"
git2_branch = "master"
git2_repo_path = "helm-charts"

upgrade_k8_version = "v1.13.5"

status_false = "false"

# for k8s test
node1_id = 1
node2_id = 2
node3_id = 3
run_cnt = 100

# OS Deployment server IP
server1_ip = "172.17.2.110"
server1_usr_name = "pcc"
server1_usr_pwd = "cals0ft"

server2_ip = "172.17.2.111"
server2_usr_name = "pcc"
server2_usr_pwd = "cals0ft"

server3_ip = "172.17.2.124"
server3_usr_name = "pcc"
server3_usr_pwd = "cals0ft"

server4_ip = "172.17.2.125"
server4_usr_name = "pcc"
server4_usr_pwd = "cals0ft"


# Node Group data
group1_name = "Test_Group_1"
group1_desc = "Test_Group_1"

group2_name = "Test_Group_2"
group2_desc = "Test_Group_2"

group3_name = "Test_Group_3"
group3_desc = "Test_Group_3"

group4_name = "Test_Group_4"
group4_desc = "Test_Group_4"

group5_name = "Updated_Group"
group5_desc = "Updated_group"

group6_name = "Test_Group_6"
group6_desc = "Test_Group_6"

group7_name = "Test_Group_7"
group7_desc = "Test_Group_7"

group8_name = "Test_Group_8"
group8_desc = "Test_Group_8"
update8_name = "update_Group_8"

group9_name = "Test_Group_9"
group9_desc = "Test_Group_9"
update9_desc = "update_Group_9"

group10_name = "!@#$%^&*()_{}"
group10_desc = "!@#$%^&*()_{}"

group11_name = "11223344556677"
group11_desc = "11223344556677"

group12_name = "  "
group12_desc = "Test"

group13_name = "Test_"
group13_desc = "Test_"

group14_name = "Test_Group_14"
group14_desc = "Test_Group_14"

group15_name = "Test_Group_15"
group15_desc = "Test_Group_15"


# Node role data
role1_name = "test_role1"
role1_desc = "test_role1"
role2_name = "test_role2"
role2_desc = "test_role2"
role3_name = "test_role3"
role3_desc = "test_role3"
role4_name = "test_role4"
role4_desc = "test_role4"
role5_name = "test_role5"
role5_desc = "test_role5"
role6_name = "test_role6"
role6_desc = "test_role6"
updated6_name = "updated_role_6"
updated6_desc = "updated_role_6"
role7_name = "test_role7"
role7_desc = "test_role7"
role8_name = "test_role8"
role8_desc = "test_role8"
role9_name = "test_role9"
role9_desc = "test_role9"
role10_name = "test_role10"
role10_desc = "test_role10"
role11_name = "test_role11"
role11_desc = "test_role11"
role12_name = "test_role12"
role12_desc = "test_role12"
role12_updated = "updated_role12"
role13_name = "test_role13"
role13_desc = "test_role13"
role14_name = "test_role14"
role14_desc = "test_role14"
role15_name = "  "
role15_desc = "  "
role16_name = "!@#$%^&*()"
role16_desc = "!@#$%^&*()"
role17_name = "12345"
role17_desc = "12345"
role18_name = "test_1#$"
role18_desc = "test_1#$"
role19_name = "test_role19"
role19_desc = "test_role19"
role20_name = "test_role20"
role20_desc = "test_role20"
role21_name = "test_role21"
role21_desc = "test_role21"
role22_name = "test_role22"
role22_desc = "test_role22"


# Node Site data
site1_name = "Test_Site_1"
site1_desc = "Test_Site_1"

site2_name = "Test_Site_2"
site2_desc = "Test_Site_2"

site3_name = "Test_Site_3"
site3_desc = "Test_Site_3"

site4_name = "!@#$%^&*()"
site4_desc = "Test_Site_4"

site5_name = "123456"
site5_desc = "Test_Site_5"

site6_name = "  "
site6_desc = "Test_Site_6"

site7_name = "Test@123^&"
site7_desc = "Test_Site_7"

site8_name = "Test_Site_8"
site8_desc = "Test_Site_8"

site8_name_update = "Update_Site_8"
site8_desc_update = "Update_Site_8"

site9_name = "Test_Site_9"
site9_desc = "Test_Site_9"

site9_name_update = "Update_Site_9"
site9_desc_update = "Update_Site_9"

site10_name = "Test_Site_10"
site10_desc = "Test_Site_10"

site11_name = "Test_Site_11"
site11_desc = "Test_Site_11"

site12_name = "Test_Site_12"
site12_desc = "Test_Site_12"

site13_name = "Test_Site_13"
site13_desc = "Test_Site_13"

site14_name = "Test_"
site14_desc = "Test_"

site15_name = "Test_Site_15"
site15_desc = "Test_Site_15"

site16_name = "Test_Site_16"
site16_desc = "Test_Site_16"

site17_name = "Test_Site_17"
site17_desc = "Test_Site_17"

# pcc tenant data
tenant1_name = "Test_Tenant_1"
tenant1_desc = "Test_Tenant_1"

tenant2_name = "Test_Tenant_2"
tenant2_desc = "Test_Tenant_2"

tenant3_name = "Test_Tenant_3"
tenant3_desc = "Test_Tenant_3"

tenant4_name = "Test_Tenant_4"
tenant4_desc = "Test_Tenant_4"

tenant5_name = "Test_Tenant_5"
tenant5_desc = "Test_Tenant_5"

#PXE
pxe_booted_server = "0123456789"
gateway = "172.17.2.1"
