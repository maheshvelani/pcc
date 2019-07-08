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
#	Log    \nDeleting the Node's from UI......     console=yes
#	:FOR    ${id}    IN    @{node_id}
#	\    @{data}    Create List    ${id}
#        \    Log    \nDeleting Node with ID = ${id}    console=yes
#	\    ${resp}    Post Request    platina    ${delete_node}    headers=${headers}    json=${data}
#	\    Log    \n Status code = ${resp.status_code}    console=yes
#	\    Log    \n Response = ${resp.json()}    console=yes
#	\    Should Be Equal As Strings    ${resp.status_code}    200
#	\    Sleep    10s


Invader and Server Cleanup from Back-End
        [Tags]    Entry Criteria
        [Documentation]    Get and Delete available Invader and Server from back-end

        Pass Execution If       ${node_avail_status}==False    No Nodes are available over PCC
        ${node_type}    Get Node Type    ${node_host}
        Log    Node Type Data = ${node_type}    console=yes
        ${status}    Node Clean up from Back-End Command    ${node_type}
        Should Be Equal As Strings    ${status}    True    msg=Failed to clean up Data from Node Back End		


Add Invader-1 as a Node and Verify Online Status
        [Tags]    Entry Criteria
        [Documentation]    Add Invader-1 as a Node and Verify Online Status

        # Add Invader Node
        &{data}    Create Dictionary  	Name=${invader1_node_name}  Host=${invader1_node_host}
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
        &{data}    Create Dictionary  	Name=${invader2_node_name}  Host=${invader2_node_host}
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


Assign MaaS Roles to Invader - 1
        [Tags]    Entry Criteria
        [Documentation]    Assign MaaS Roles to Invader - 1

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

        # Wait for 12 minutes
        Sleep	12 minutes

        # Verify Maas Installation Complete status
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${invader1_node_name}    ${maas_role_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${invader1_node_name} is not updated with the MaaS Roles


Assign MaaS Roles to Invader - 2
        [Tags]    Entry Criteria
        [Documentation]    Assign MaaS Roles to Invader - 2

        # Assign MaaS role to node - 2
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

        # Wait for 12 minutes
        Sleep	12 minutes

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
        ${status}    Server PXE boot    ${server_node_host}
        Should Be Equal As Strings    ${status}    True    msg=PXE boot Failed Over Server ${server_node_host}
        Sleep   2 minutes


Update Server information added after PXE boot
        [Tags]    Entry Criteria
        [Documentation]    Update Server information

        # Get Server ID
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${server_id}    Get Server Id    ${resp.json()}    ${server_node_host}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server_node_name} is not present in node list
        Log    \n Server ${server_node_name} ID = ${server_id}   console=yes
        Set Suite Variable    ${server1_id}    ${node_id}

        # Update Server Node with proper information
        &{data}    Create Dictionary    Id=${server1_id}  Name=${server_node_name}  console=${server_console}
        ...    managed=${${server_managed_by_pcc}}  bmc=${server_bmc_host}  bmcUser=${server_bmc_user}
	    ...    bmcPassword=${server_bmc_pwd}  bmcUsers=@{server_bmc_users}
	    ...    sshKeys=@{server_ssh_keys}
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
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${server_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server_node_name} is not present in node list
        Log    \n Server ${server_node_name} ID = ${node_id}   console=yes
        Set Suite Variable    ${server1_id}    ${node_id}

        # Verify Online Status of Added Server
        ${status}    Validate Node Online Status    ${resp.json()}    ${server_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server_node_name} added successfully but it is offline


Assign LLDP role to Server
        [Tags]    Entry Criteria
        [Documentation]    Assign LLDP to Server

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
        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${server_node_name}    ${lldp_role_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${server_node_name} is not updated with the Roles LLDP


*** keywords ***
SSH into Invader and Verify mass installation started
        [Arguments]    ${invader_ip}
        Open Connection     ${invader_ip}    timeout=1 hour
        Login               ${invader_usr_name}        ${invader_usr_pwd}
        Sleep    2s
        ${output}=         Execute Command    ps -aef | grep ROOT
        Log    \n\n INVADER DATA = ${output}    console=yes
        Should Contain    ${output}    tinyproxy.conf
        Close All Connections