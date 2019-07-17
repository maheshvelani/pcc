
*** Settings ***
Library  	      	OperatingSystem
Library  	      	Collections
Library  	      	String

Library    	      	${CURDIR}/../lib/Request.py
Variables         	${CURDIR}/../test_data/Url_Paths.py
Library           	${CURDIR}/../lib/Data_Parser.py
Resource          	${CURDIR}/../resource/Resource_Keywords.robot

Test Setup       	Verify User Login
Test Teardown    	Delete All Sessions



*** Test Cases ***
Add Invader as a Node
        [Tags]    Invader
        [Documentation]    Verify User Should be able to add Invader as Node

        :For  ${index}  IN RANGE    0  ${total_node}
        \    ${Index}    Evaluate    ${index}+1
        \    Run Keyword And Continue On Failure    Add Invader    ${Index}


Add Invader as a Node
        [Tags]    Server
        [Documentation]    Verify User Should be able to add Invader as Node

        :For  ${index}  IN RANGE    0  ${total_server}
        \    ${Index}    Evaluate    ${index}+1
        \    Run Keyword And Continue On Failure    Add Server    ${Index}




*** keywords ***
Add Invader
	[Arguments]    ${Index}
 
        # Add Invader Node
	${name}     Set Variable  ${Invader${index}_node_name}
	${host}    Set Variable  ${Invader${index}_node_host}
        &{data}     Create Dictionary  	Name=${name}  Host=${host}
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
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${name} is not present in node list
        Log    \n Invader ${name} ID = ${node_id}   console=yes
        Set Suite Variable    ${invader${index}_id}    ${node_id}

        # Verify Online Status of Added Invader
        ${status}    Validate Node Online Status    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${name} added successfully but it is offline


Add Server
	[Arguments]    ${Index}

        # Add Server Node

	${name}    Set Variable  ${server${index}_node_name}
	${host}   Set Variable   ${server${index}_node_host}
	${bmc_host}   Set Variable  ${server${index}_bmc_host}
	${bmc_user}   Set Variable  ${server${index}_bmc_user}
	${bmc_pwd}   Set Variable  ${server${index}_bmc_pwd}
	${console}   Set Variable  ${server${index}_console}
	${manage_pcc}    Set Variable  ${server${index}_managed_by_pcc}
	${ssh_key}    Set Variable  ${server${index}_ssh_keys}


        @{server_bmc_users}    Create List    ${bmc_user}
        @{server_ssh_keys}    Create List    ${ssh_key}
        &{data}    Create Dictionary  	Name=${name}  Host=${host}
        ...    console=${console}  bmc=${bmc_host}  bmcUser=${bmc_user}
        ...    bmcPassword=${bmc_pwd}  bmcUsers=@{server_bmc_users}
        ...    sshKeys=@{server_ssh_keys}  managed=${${server${Index}_managed_by_pcc}}
        Log    \nCreating Server node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # wait for few seconds to add Server into Node List
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
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${name} is not present in node list
        Log    \n Server ID = ${node_id}   console=yes
        Set Suite Variable    ${server${Index}_id}    ${node_id}

        # Verify Online Status of Added Server
        ${status}    Validate Node Online Status    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${name} added successfully but it is offline
