*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String
Library         SSHLibrary

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Library         ${CURDIR}/../lib/Entry_Criteria_Api.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Test Setup      Verify User Login
Test Teardown   Delete All Sessions


*** Test Cases ***
Invader and Server Cleanup from UI
        [Tags]    Entry Criteria
        [Documentation]    Get and Delete available Invader and Server from the PCC

        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Get Nodes Status code = ${resp.status_code}    console=yes
        Log    \n Get Nodes Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}  ${node_id}  ${node_data}  Get Available Node Data  ${resp.json()}
        Set Suite Variable    ${node_host}    ${node_data}
        Set Suite Variable    ${node_avail_status}    ${status}
        Pass Execution If	${node_avail_status}==False    No Nodes are available over PCC
        Log    \nDeleting the Node's from UI......     console=yes
        :FOR    ${id}    IN    @{node_id}
        \    @{data}    Create List    ${id}
        \    Log    \nDeleting Node with ID = ${id}    console=yes
        \    ${resp}    Post Request    platina    ${delete_node}    headers=${headers}    json=${data}
        \    Log    \n Status code = ${resp.status_code}    console=yes
        \    Log    \n Response = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    Sleep    60s


Add Invader-1 as a Node and Verify Online Status
        [Tags]    Entry Criteria
        [Documentation]    Add Invader-1 as a Node and Verify Online Status

        # Add Invader Node
        &{data}    Create Dictionary  	Name=${invader1_node_name}  Host=${invader1_node_host}  managed=${${status_false}}
        Log    \nCreating Invader Node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # wait for few seconds to add Invader into Node List
        Sleep    90s

        # Validate Added Node Present in Node List
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        # Hit get_node_list API for few times to refresh the node list
        # And verify Node availability from the latest fetched node data
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched node list and verify added Node availability from response data
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${invader1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${invader1_node_name} is not present in node list
        Log    \n Invader ${invader1_node_name} ID = ${node_id}   console=yes
        Set Suite Variable    ${invader1_id}    ${node_id}

        # Verify Online Status of Added Invader
        ${status}    Validate Node Online Status    ${resp.json()}    ${invader1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${invader1_node_name} added successfully but it is offline


Add Invader-2 as a Node and Verify Online Status
        [Tags]    Entry Criteria
        [Documentation]    Add Invader-2 as a Node and Verify Online Status

        # Add Invader Node
        &{data}    Create Dictionary  	Name=${invader2_node_name}  Host=${invader2_node_host}  managed=${${status_false}}
        Log    \nCreating Invader Node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # wait for few seconds to add Invader into Node List
        Sleep    90s

        # Validate Added Node Present in Node List
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        # Hit get_node_list API for few times to refresh the node list
        # And verify Node availability from the latest fetched node data
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched node list and verify added Node availability from response data
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${invader2_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${invader2_node_name} is not present in node list
        Log    \n Invader ${invader2_node_name} ID = ${node_id}   console=yes
        Set Suite Variable    ${invader2_id}    ${node_id}

        # Verify Online Status of Added Invader
        ${status}    Validate Node Online Status    ${resp.json()}    ${invader2_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${invader2_node_name} added successfully but it is offline


Assign LLDP and MaaS Roles to Invader - 1
        [Tags]    Entry Criteria
        [Documentation]    Assign LLDP and MaaS Role to Invader - 1

        # Get Id of MaaS role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get MaaS Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=MaaS Role Not Found in Roles
        Set Suite Variable    ${maas_role_id}    ${role_id}
        Log    \n MaaS Role ID = ${maas_role_id}    console=yes

        # Get Id of LLDP role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get LLDP Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=LLDP Role Not Found in Roles
        Set Suite Variable    ${lldp_role_id}    ${role_id}
        Log    \n LLDP Role ID = ${lldp_role_id}    console=yes

        # Assign MaaS role to node - 1
        @{roles_group}    create list    ${lldp_role_id}    ${maas_role_id}
        &{data}    Create Dictionary  Id=${invader1_id}    roles=${roles_group}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        # Wait for few Seconds
        Sleep    150s

        # SSH into invader and verify MaaS installation process started
        Run Keyword And Ignore Error	SSH into Invader and Verify mass installation started    ${invader1_node_host}

        # Wait for 10 minutes
        Sleep	10 minutes

        # Verify Maas Installation Complete status
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${invader1_node_name}    ${maas_role_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${invader1_node_name} is not updated with the MaaS Roles


Assign LLDP and MaaS Roles to Invader - 2
        [Tags]    Entry Criteria
        [Documentation]    Assign LLDP and MaaS Role to Invader - 2

        # Assign MaaS role to node - 1
        @{roles_group}    create list    ${lldp_role_id}    ${maas_role_id}
        &{data}    Create Dictionary  Id=${invader2_id}    roles=${roles_group}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        # Wait for few Seconds
        Sleep    150s

        # SSH into invader and verify MaaS installation process started
        Run Keyword And Ignore Error	SSH into Invader and Verify mass installation started    ${invader2_node_host}

        # Wait for 10 minutes
        Sleep	10 minutes

        # Verify Maas Installation Complete status
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${invader2_node_name}    ${maas_role_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${invader2_node_name} is not updated with the MaaS Roles


PXE Boot to Server
        [Tags]    Entry Criteria
        [Documentation]    Server PXE Boot
        ${status}    Server PXE boot    ${server1_bmc_host}
        Should Be Equal As Strings    ${status}    True    msg=PXE boot Failed Over Server ${server1_node_host}
        # Wait till Server Get Booted
        Log    \nPXE boot Started......    console=yes
        Sleep   5 minutes
        Log    \nPXE boot Started......    console=yes
        Sleep   5 minutes


Validate Interface Mode - Expected Inventory Mode
        [Tags]    Entry Criteria
        [Documentation]    Verify that Server is in inventory mode

        # Get SV2 interface
        Log    \nGetting Topology Data...    console=yes
        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${interface_sv1}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server1_node_name}
        ${interface_sv2}    Get Interface Name    ${resp.json()}  ${invader2_node_name}  ${server1_node_name}
        Set Suite Variable    ${interface_sv1}
        Set Suite Variable    ${interface_sv2}

        # verify Mode into Inventory
        Validate server Mode 1    inventory
        Validate server Mode 2    inventory


Update Server information added after PXE boot
        [Tags]    Entry Criteria
        [Documentation]    Update Server information

        # Get Server ID
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Get Server Id    ${resp.json()}    ${server1_bmc_host}
        Should Be Equal As Strings    ${status}    True    msg=Booted Server ${server1_bmc_host} is not present in node list
        Log    \n Server ${server1_node_name} ID = ${node_id}   console=yes
        Set Suite Variable    ${server1_id}    ${node_id}

        # Get server Interface from topology
        Log    \nGetting Topology Data...    console=yes
        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes

        ${i1_interface}  ${i2_interface}  Get_booted_server_interface_2  ${resp.json()}  ${server1_id}
        Log    \n\nBooted server Interface = ${i_interface}  console=yes

        # Get Booted server details
        ${resp}  Get Request    platina   ${get_node_list}/${server1_id}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes

        # Get valid server interface to set management IP
        ${mngmt_interface}    get management ip interface_2    ${resp.json()}  ${i1_interface}  ${i2_interface}
        Log    \nFound Suitable interface to assign management Ip = ${mngmt_interface}  console=yes

        # Set Management Ip
        @{mgt_ip}    Create List    ${server1_node_host}
        &{data}    Create Dictionary  nodeID=${${server1_id}}  ipv4Addresses=@{mgt_ip}  ifName=${mngmt_interface}  gateway=172.17.2.1  management=${true}
        Log    \nAssigning management ip with params = ${data}    console=yes
        ${resp}  Post Request    platina    ${add_interface}    json=${data}     headers=${headers}
        Log    \n MGT IP Assign status Code = ${resp.status_code}    console=yes
        # Should Be Equal As Strings  ${resp.status_code}    200
        Sleep    1 minutes

        # Update Server Node with proper information
        @{server1_bmc_users}    Create List    ${server1_bmc_user}
        @{server1_ssh_keys}    Create List    ${server1_ssh_keys}

        &{data}    Create Dictionary    Id=${server1_id}  Name=${server1_node_name}  console=${server1_console}
        ...    managed=${${server1_managed_by_pcc}}  bmc=${server1_bmc_host}/23  bmcUser=${server1_bmc_user}
        ...    bmcPassword=${server1_bmc_pwd}  bmcUsers=@{server1_bmc_users}
        ...    sshKeys=@{server1_ssh_keys}  Host=${server1_node_host}
        Log    \n Updating Server with Data : \n${data}\n    console=yes
        ${resp}  Put Request    platina    ${update_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        # Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        # wait for few seconds
        Sleep    90s

        # Validate Updated Server Present in Node List
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        # And verify Node availability from the latest fetched node data
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched node list and verify added Node availability from response data
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server1_node_name} is not present in node list
        Log    \n Server ${server1_node_name} ID = ${node_id}   console=yes
        Set Suite Variable    ${server1_id}    ${node_id}


OS Deployment over Server machine
        [Tags]    Entry Criteria
        [Documentation]    OS Deployment

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 15 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Run Keyword And Ignore Error    Verify CentOS installed in server machine


Assign LLDP role to Server
        [Tags]    Entry Criteria
        [Documentation]    Assign LLDP to Server - 2

        # Assign Role to Node
        &{data}    Create Dictionary  Id=${server1_id}    roles=${lldp_role_id}
        Log    \nAssigning a Roles with parameters: \n${data}\n    console=yes
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        # Wait for few seconds to reflect assign roles over node
        Sleep	5 minutes

        # Validate Assigned Roles
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${server1_node_name}    ${lldp_role_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${server1_node_name} is not updated with the Roles LLDP

        Sleep	2 minutes

        # Verify Online Status of Added Server
        ${status}    Validate Node Online Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server1_node_name} added successfully but it is offline


Assign Interface Ip to node to form Topology
        [Tags]    Entry Criteria
        [Documentation]	  Assign IP to interfaces

        Log    \nGetting Topology Data...    console=yes
        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        ${interface_sv1}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server1_node_name}
        ${interface_sv2}    Get Interface Name    ${resp.json()}  ${invader2_node_name}  ${server1_node_name}
        ${interface1_name}  Get Interface Name    ${resp.json()}  ${server1_node_name}  ${invader1_node_name}
        ${interface2_name}  Get Interface Name    ${resp.json()}  ${server1_node_name}  ${invader2_node_name}

        Log  \n\nInterface Between ${invader1_node_name} and ${server1_node_name} = ${interface_sv1}  console=yes
        Log  \n\nInterface Between ${invader2_node_name} and ${server1_node_name} = ${interface_sv2}  console=yes
        Log  \n\nInterface Between ${server1_node_name} and ${invader1_node_name} = ${interface1_name}  console=yes
        Log  \n\nInterface Between ${server1_node_name} and ${invader2_node_name} = ${interface2_name}  console=yes

#        Set Suite Variable    ${interface_sv1}
#        Set Suite Variable    ${interface_sv2}
#        Set Suite Variable    ${interface1_name}
#        Set Suite Variable    ${interface2_name}

        # Get Invader Topology
        ${status}    ${sv1_topology}    Prepare Invader Topology  ${resp.json()}  ${invader1_id}  ${interface_sv1}  192.0.2.102/31
        ${status}    ${sv2_topology}    Prepare Invader Topology  ${resp.json()}  ${invader2_id}  ${interface_sv2}  192.0.2.100/31
        ${status}    ${i1_topology}    Prepare Invader Topology  ${resp.json()}  ${server1_id}  ${interface1_name}  192.0.2.103/31
        ${status}    ${i2_topology}    Prepare Invader Topology  ${resp.json()}  ${server1_id}  ${interface2_name}  192.0.2.101/31

        # Update Invader interfaces
        Log    \n Updating invader topology with data = ${sv1_topology} \n    console=yes
        ${resp}  Post Request    platina   ${add_interface}    json=${sv1_topology}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating invader topology with data = ${sv2_topology} \n    console=yes
        ${resp}  Post Request    platina   ${add_interface}    json=${sv2_topology}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating Server topology with data = ${i1_topology} \n    console=yes
        ${resp}  Post Request    platina   ${add_interface}    json=${i1_topology}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating Server topology with data = ${i2_topology} \n    console=yes
        ${resp}  Post Request    platina   ${add_interface}    json=${i2_topology}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200
        Sleep    30s


Validate Interface Mode - Expected user mode
        [Tags]    Entry Criteria
        [Documentation]    Verify that Server is in inventory mode

        # verify Mode into Inventory
        Validate server Mode 1  user
        Validate server Mode 2  user


Create Kubernetes Cluster
        [Tags]    Entry Criteria
        [Documentation]    Create Kubernetes Cluster

        # Create Kubernetes cluster
        &{data1}    Create Dictionary  id=${${invader1_id}}
        &{data2}    Create Dictionary  id=${${server1_id}}
        &{data3}    Create Dictionary  id=${${invader2_id}}
        @{json}    Create List    ${data1}  ${data2}  ${data3}

        &{data}    Create Dictionary  name=${cluster_name}  k8sVersion=${cluster_version}  cniPlugin=${cni_plugin}
        ...    nodes=@{json}
        Log    \nCreating Cluster with data: ${data}\n
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for few seconds
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  3 minutes

        # Verify cluster created
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${id}    Validate Cluster    ${resp.json()}    ${cluster_name}
        Should Be Equal As Strings    ${status}    True    msg=Created Cluster ${cluster_name} is not present in Cluster list
        Set Suite Variable    ${cluster_id}    ${id}
        ${status}    Validate Cluster Deploy Status    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=Cluster installation failed#
        ${status}    Validate Cluster Health Status    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=Cluster installed but Health status is not good


Verify Created K8s Cluster installation from back end
        [Tags]    Entry Criteria
        [Documentation]    Verify Kubernetes Cluster
        Verify K8s installed


Add an app to k8s
        [Tags]    Entry Criteria
        [Documentation]    Add an App to K8S

        # Add an App to Kubernetes cluster
        &{data}    Create Dictionary  label=${app_name}  appName=${app_name}  appNamespace=${app_name}  gitUrl=${git_url}
        ...  gitRepoPath=${git_repo_path}  gitBranch=${git_branch}
        Log    \nAdding App with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    2 minutes

        # Verify App Installed Successfully..
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify App Present in Cluster    ${resp.json()}    ${app_name}
        Should Be Equal As Strings    ${status}    True    msg=Installed App ${app_name} is not present/installed in cluster


Update k8s and verify version updated
        [Tags]    Entry Criteria
        [Documentation]    Update K8s version

        # Upgrade K8s Version
        &{data}    Create Dictionary  k8sVersion=${upgrade_k8_version}
        Log    \nUpgrading k8s with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/upgrade  json=${data}  headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n RESP = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5 minutes
        Log To Console    K8s Upgrading........
        Sleep    5 minutes
        Log To Console    K8s Upgrading........
        Sleep    5 minutes
        Log To Console    K8s Upgrading........
        Sleep    5 minutes
        Log To Console    K8s Upgrading........
        Sleep    5 minutes
        Log To Console    K8s Upgrading........
        Sleep    2 minutes
        Log To Console    K8s Upgrading........

        # Verify K8s Upgradded
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify Cluster Version    ${resp.json()}    ${upgrade_k8_version}
        Should Be Equal As Strings    ${status}    True    msg=K8s is not upgradder with version = ${upgrade_k8_version}


Install another app as sanity check
        [Tags]    Entry Criteria
        [Documentation]    Insatall Another app as sanity check

        # Install an App to K8s Cluster
        &{data}    Create Dictionary  label=${app2_name}  appName=${app2_name}  appNamespace=${app2_name}  gitUrl=${git2_url}
        ...  gitRepoPath=${git2_repo_path}  gitBranch=${git2_branch}
        Log    \nAdding App with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    2 minutes

        # Verify App Installed Successfully..
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify App Present in Cluster    ${resp.json()}    ${app2_name}
        Should Be Equal As Strings    ${status}    True    msg=Installed App ${app2_name} is not present/installed in cluster


Delete K8s Cluster
        # Delete K8s Cluster
        Log    \n\nDeleting Cluster...    console=yes
        ${resp}  Delete Request	   platina    ${add_kubernetes_cluster}/${cluster_id}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for few seconds
        Sleep    5 minutes

        # Verify Cluster Deleted
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
        Should Be Equal As Strings    ${status}    True    msg=Cluster ${cluster_name} not deleted



*** keywords ***
SSH into Invader and Verify mass installation started
        [Arguments]    ${invader_ip}
        ${i_ip}    get ip   ${invader_ip}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}        ${invader_usr_pwd}
        Sleep    2s
        ${output}=         SSHLibrary.Execute Command    ps -aef | grep ROOT
        Log    \n\n INVADER DATA = ${output}    console=yes
        Should Contain    ${output}    tinyproxy.conf
        SSHLibrary.Close All Connections


Verify CentOS installed in server machine
        # Get OS release data from server
        ${server_ip}    get ip   ${server1_node_host}
        SSHLibrary.Open Connection     ${server_ip}    timeout=1 hour
        SSHLibrary.Login               root        plat1na
        Sleep    2s
        ${output}=        SSHLibrary.Execute Command    cat /etc/os-release
        Log    \n\nSERVER RELEASE DATA = ${output}    console=yes
        Should Contain    ${output}    CentOS Linux
        ${output}    SSHLibrary.Execute Command    uptime -p
        Log    \n\nSERVER UP Time Data DATA = ${output} \n\n    console=yes
        ${status}    Verify server up time     ${output}
        Should Be Equal As Strings    ${status}    True    msg=There are no new OS deployed in last few minutes
        SSHLibrary.Close All Connections


Verify K8s installed
        # Verify k8s installed
        ${i_ip}    Get Ip    ${invader1_node_host}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}  ${invader_usr_pwd }
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo kubectl get nodes
        Log    \n\nK8SDATA = ${output} \n\n    console=yes
        Should Contain  ${output}    Ready
        Should Contain  ${output}    master
        SSHLibrary.Close All Connections


Validate server Mode 1
        [Arguments]    ${mode}
        # Get OS release data from server
        ${i_ip}    get ip   ${invader1_node_host}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}  ${invader_usr_pwd }
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo grep \'${interface_sv1}\' /srv/maas/state/tenants.json -C 2
        SSHLibrary.Close All Connections
        Log    \nINVENTORY DATA = ${output}\n    console=yes
        Sleep    2s
        ${status}    Validate Inventory Data    ${output}    ${mode}
        Should Be Equal As Strings    ${status}  True  msg=Expected mode is = ${mode} but actual mode is different...


Validate server Mode 2
        [Arguments]    ${mode}
        # Get OS release data from server
        ${i_ip}    get ip   ${invader2_node_host}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}  ${invader_usr_pwd }
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo grep \'${interface_sv2}\' /srv/maas/state/tenants.json -C 2
        SSHLibrary.Close All Connections
        Log    \nINVENTORY DATA = ${output}\n    console=yes
        Sleep    2s
        ${status}    Validate Inventory Data    ${output}    ${mode}
        Should Be Equal As Strings    ${status}  True  msg=Expected mode is = ${mode} but actual mode is different...
