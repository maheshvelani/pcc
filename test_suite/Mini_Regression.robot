*** Settings ***
Library         SSHLibrary
Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Json_validator.py
Library         ${CURDIR}/../lib/Pcc_cli_api.py
Resource        ${CURDIR}/../resource/Common_api.robot

Test Setup      Login into PCC    host_url=${server_url}    user_name=${user_name}    password=${user_pwd}
Test Teardown   Logout from PCC
Suite Setup    Set Tags        Mini Regression

*** Test Cases ***
Add Invader as a Node and Verify Online Status
        [Documentation]    Add Invader as a Node and Verify Online Status

        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is Online    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True


Add Server-1 as a Node and Verify Online Status
	    [Documentation]    Add Server-1 as a Node and Verify Online Status

	    ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_host}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True


Assign LLDP Role to Invader
        [Documentation]    Assign LLDP and MaaS Role to Invader - 1

	    ${status}    Install LLDP Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True


Assign LLDP role to server
        [Documentation]    Assign LLDP Role to Server - 1

	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True


Assign MaaS Role to Invader
	    [Documentation]    Assign LLDP and MaaS Role to Invader - 1

	    ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True


PXE Boot to Server
        [Tags]    pxe
        [Documentation]    Server PXE Boot

        ${status}    PXE Boot the server    bmc_ip=${server1_bmc_ip}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Booted server reflected over PCC UI   bmc_ip=${server1_bmc_ip}
        Should Be Equal As Strings    ${status}    True
        ${status}    Assign Management IP to PXE booted Server    ${server1_node_host}
        Should Be Equal As Strings    ${status}    True
        ${status}    Update Booted Server Information    server_name=${server1_node_name}    host=${server1_node_host}    console=${server1_console}
        ...  bmc_ip=${server1_bmc_ip}     bmc_user=${server1_bmc_user}    bmc_password=${server1_bmc_pwd}    bmc_users=${server1_bmc_user}
        ...  ssh_key=${server1_ssh_keys}     managed_by_pcc=${server1_managed_by_pcc}
        Should Be Equal As Strings    ${status}    True


OS Deployment over Server machine
        [Documentation]    OS Deployment

        ${status}    OS Deployment    node=${server1_node_name}     image=${image1_name}     locale=${locale}    time_zone=${PDT}
         ...  admin_user=${admin_user}    ssh_key=${ssh_key}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify OS installed  node_name=${server1_node_name}       os_name=${image1_name}
        Should Be Equal As Strings    ${status}    True


Assign LLDP role to PXE booted Server
        [Documentation]    Assign LLDP to Server - 2

	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True


Form Topology
        [Tags]    topology
        Assign Interface Ip to node to form Topology    ${invader1_node_name}  ${server1_node_name}  ${server2_node_name}


Create Kubernetes Cluster
        [Documentation]    Create Kubernetes Cluster

        ${status}    Install K8s Cluster    name=${cluster_name}    version=${cluster_version}    cni_plugin=${cni_plugin}    node1_name=${invader1_node_name}    node2_name=${server1_node_name}    node3_name=${server2_node_name}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify K8s installed    cluster_name=${cluster_name}    node_name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True


Verify Created K8s Cluster installation from back end
        [Documentation]    Verify Kubernetes Cluster
        Verify K8s installed


Add an app to k8s
        [Documentation]    Add an App to K8S

        ${status}    Add an Application to K8s    cluster_name=${cluster_name}    label=${app_name}    app_name=${app_name}    name_space=${app_name}    git_url=${git_url}    git_repo_path=${git_repo_path}    git_branch=${git_branch}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify App installed over K8s Cluster    cluster_name=${cluster_name}    app_name=${app_name}
        Should Be Equal As Strings    ${status}    True


Update k8s and verify version updated
        [Documentation]    Update K8s version

        ${status}    Upgrade K8s Cluster    cluster_name=${cluster_name}    version=${upgrade_k8_version}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify k8s Upgraded    cluster_name=${cluster_name}    version=${upgrade_k8_version}
        Should Be Equal As Strings    ${status}    True


Install another app as sanity check
        [Documentation]    Install Another app as sanity check

        ${status}    Add an Application to K8s    cluster_name=${cluster_name}    label=${app2_name}    app_name=${app2_name}    name_space=${app2_name}    git_url=${git2_url}    git_repo_path=${git2_repo_path}    git_branch=${git2_branch}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify App installed over K8s Cluster    ${cluster_name}=${cluster_name}    ${app_name}=${app2_name}
        Should Be Equal As Strings    ${status}    True