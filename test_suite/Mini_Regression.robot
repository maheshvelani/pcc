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

        Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is present in Node List    name=${invader1_node_name}
        Verify Invader is Online    name=${invader1_node_name}


Add Server-1 as a Node and Verify Online Status
	[Documentation]    Add Server-1 as a Node and Verify Online Status
	Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_host}/23  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	Verify Server is present in Node List    name=${server1_node_name}
	Verify Server is Online    name=${server1_node_name}


Assign LLDP Role to Invader
        [Documentation]    Assign LLDP and MaaS Role to Invader - 1
	Install LLDP Role    node_name=${invader1_node_name}
	Verify LLDP Installed    node_name=${invader1_node_name}
	

Assign LLDP role to server
        [Documentation]    Assign LLDP Role to Server - 1
	Install LLDP Role    node_name=${server1_node_name}
        Verify LLDP Installed    node_name=${server1_node_name}


Assign MaaS Role to Invader
#        [Tags]    test_1
	 [Documentation]    Assign LLDP and MaaS Role to Invader - 1
	 Install MaaS Role    node_name=${invader1_node_name}
	 Verify MaaS Installed    node_name=${invader1_node_name}


PXE Boot to Server
        [Tags]    pxe
        [Documentation]    Server PXE Boot
        PXE Boot the server    bmc_ip=${server1_bmc_ip}
        Verify Booted server reflected over PCC UI   bmc_ip=${server1_bmc_ip}
        Assign Management IP to PXE booted Server    ${server1_node_host}
        Update Booted Server Information    server_name=${server1_node_name}    host=${server1_node_host}    console=${server1_console}
        ...  bmc_ip=${server1_bmc_ip}     bmc_user=${server1_bmc_user}    bmc_password=${server1_bmc_pwd}    bmc_users=${server1_bmc_user}
        ...  ssh_key=${server1_ssh_keys}     managed_by_pcc=${server1_managed_by_pcc}

#Validate Interface Mode - Expected Inventory Mode
#        [Tags]    Entr
#        [Documentation]    Verify that Server is in inventory mode
#
#        # Get SV2 interface
#        Log    \nGetting Topology Data...    console=yes
#        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${interface_sv2}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  0123456789
#        Set Suite Variable    ${interface_sv2}
#
#        # verify Mode into Inventory
#        Validate server Mode    inventory


OS Deployment over Server machine
        [Documentation]    OS Deployment
	
	OS Deployment    node=${server1_node_name}     image=${image1_name}     locale=${locale}    time_zone=${PDT}
         ...  admin_user=${admin_user}    ssh_key=${ssh_key}
         Verify OS installed  node_name=${server1_node_name}       os_name=${image1_name}


Assign LLDP role to PXE booted Server
        [Documentation]    Assign LLDP to Server - 2
	
	Install LLDP Role    node_name=${server1_node_name}
	Verify LLDP Installed    node_name=${server1_node_name}


Form Topology
        [Tags]    topology
        Assign Interface Ip to node to form Topology    ${invader1_node_name}  ${server1_node_name}  ${server2_node_name}

Validate Interface Mode - Expected user mode
        [Tags]    Entry Criteria
        [Documentation]    Verify that Server is in inventory mode

        # verify Mode into Inventory
        Validate server Mode    user


Create Kubernetes Cluster
        [Documentation]    Create Kubernetes Cluster

        Install K8s Cluster    name=${cluster_name}    version=${cluster_version}    cni_plugin=${cni_plugin}    node1_name=${invader1_node_name}    node2_name=${server1_node_name}    node3_name=${server2_node_name}
        Verify K8s installed    cluster_name=${cluster_name}    node_name=${invader1_node_name}



Verify Created K8s Cluster installation from back end
        [Documentation]    Verify Kubernetes Cluster
        Verify K8s installed


Add an app to k8s
        [Documentation]    Add an App to K8S

        Add an Application to K8s    cluster_name=${cluster_name}    label=${app_name}    app_name=${app_name}    name_space=${app_name}    git_url=${git_url}    git_repo_path=${git_repo_path}    git_branch=${git_branch}
        Verify App installed over K8s Cluster    cluster_name=${cluster_name}    app_name=${app_name}

Update k8s and verify version updated
        [Documentation]    Update K8s version

        Upgrade K8s Cluster    cluster_name=${cluster_name}    version=${upgrade_k8_version}
        Verify k8s Upgraded    cluster_name=${cluster_name}    version=${upgrade_k8_version}


Install another app as sanity check
        [Documentation]    Install Another app as sanity check

        Add an Application to K8s    cluster_name=${cluster_name}    label=${app2_name}    app_name=${app2_name}    name_space=${app2_name}    git_url=${git2_url}    git_repo_path=${git2_repo_path}    git_branch=${git2_branch}
        Verify App installed over K8s Cluster    ${cluster_name}=${cluster_name}    ${app_name}=${app2_name}


