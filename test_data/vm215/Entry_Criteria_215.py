############################################
#
# Test Data File for the PCC Entry Criteria
#
############################################


# PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.215:9999"
user_name = "admin"
user_pwd = "admin"


# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader1_node_name = "i61"
invader1_node_host = "172.17.2.61/23"
# Invader interface
#interface_sv1 = "xeth29-1"
#asign_ip_to_interface1 = "192.0.2.12/31"
#interface_sv2 = "xeth29-2"
#asign_ip_to_interface2 = "192.0.2.8/31"


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
#interface1_name = "enp139s0"
#interface1_ip = "192.0.2.13/31"


# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server2_node_name = "sv17"
server2_node_host = "172.17.2.117/23"
server2_bmc_host = "172.17.3.117"
server2_bmc_user = "ADMIN"
server2_bmc_pwd = "ADMIN"
server2_console = "ttyS1"
server2_managed_by_pcc = "true"
server2_ssh_keys = "pcc"
# Management parameters
#management_interface = "eth3"
#management_ip = "172.17.2.117/23"
#gateway_ip = "172.17.2.1"
# topolofy parameters
#interface2_name = "enp129s0"
#interface2_ip = "192.0.2.9/31"


# Credentials to access invader via ssh
invader_usr_name = "pcc"
invader_usr_pwd = "cals0ft"


# OS Deployment data
image_name = "centos76"
en_US = "en_US"
PDT = "PDT"
mass_user = "pcc"
ssh_key = "['pcc']"


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

satus_false = "false"
