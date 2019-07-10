############################################
#
# Test Data File for the PCC Entry Criteria
#
############################################


# PCC Login Data
# Login into PCC mentioned into Server URL
# E.g. Here it will be Login into PCC-216
server_url = "https://172.17.2.216:9999"
user_name = "admin"
user_pwd = "admin"


# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader1_node_name = "i58"
invader1_node_host = "172.17.2.58"


# Test Data for Invader as Node
# Update This data as per supported Invader over PCC server
invader2_node_name = "i59"
invader2_node_host = "172.17.2.59"


# Test Data to Add Server as Node
# Update This data as per supported Server over PCC
server_node_name = "sv101"
server_node_host = "172.17.2.101"
server_bmc_host = "172.17.3.101"
server_bmc_user = "ADMIN"
server_bmc_pwd = "ADMIN"
server_console = "ttyS1"
server_managed_by_pcc = "true"
server_ssh_keys = "pcc"


# Credentials to access invader via ssh
invader_usr_name = "pcc"
invader_usr_pwd = "cals0ft"


# OS Deployment data
image_name = "centos76"
en_US = "en_US"
PDT = "PDT"
mass_user = "auto_test"
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
