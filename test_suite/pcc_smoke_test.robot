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
        [Tags]    Smoke_Test    Node Management
        [Documentation]    Verify User Should be able to add Invader as Node

        # Add Invader Node
	&{data}    Create Dictionary  	Name=${invader_node_name}  Host=${invader_node_host}
	Log    Creating Invader with parameters : \n${data} \n    console=yes
	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings    ${resp.status_code}    200
	Should Be Equal As Strings    ${resp.json()['status']}    200

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
    	Should Be Equal As Strings    ${resp.json()['status']}    200

 	# Parse fetched node list and verify added Node availability from response data
 	${status}    ${node_id}    Validate Node    ${resp.json()}    ${invader_node_name}
 	Should Be Equal As Strings    ${status}    True    msg=Invader ${invader_node_name} is not present in node list
 	Log    \n Invader ${invader_node_name} ID = ${node_id}   console=yes
	Set Suite Variable    ${invader_id}    ${node_id}

        # Verify Online Status of Added Invader
 	${status}    Validate Node Online Status    ${resp.json()}    ${invader_node_name}
	Should Be Equal As Strings    ${status}    True    msg=Invader ${invader_node_name} added successfully but it is offline


Add Server as a Node
        [Tags]    Smoke_Test    Node Management
        [Documentation]    Verify User Should be able to add Server as Node

        # Add Server Node
        @{server_bmc_users}    Create List    ${server_bmc_user}
        @{server_ssh_keys}    Create List    ${server_ssh_keys}
	&{data}    Create Dictionary  	Name=${server_node_name}  Host=${server_node_host}
	...    console=${server_console}  bmc=${server_bmc_host}  bmcUser=${server_bmc_user}
	...    bmcPassword=${server_bmc_pwd}  bmcUsers=@{server_bmc_users}
	...    sshKeys=@{server_ssh_keys}  managed=${${server_managed_by_pcc}}
	Log    Creating Server with parameters : \n${data} \n    console=yes
	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings    ${resp.status_code}    200
	Should Be Equal As Strings    ${resp.json()['status']}    200

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
    	Should Be Equal As Strings    ${resp.json()['status']}    200

 	# Parse fetched node list and verify added Node availability from response data
 	${status}    ${node_id}    Validate Node    ${resp.json()}    ${server_node_name}
 	Should Be Equal As Strings    ${status}    True    msg=Server ${server_node_name} is not present in node list
 	Log    \n Server ${server_node_name} ID = ${node_id}   console=yes
	Set Suite Variable    ${server_id}    ${node_id}

        # Verify Online Status of Added Server
 	${status}    Validate Node Online Status    ${resp.json()}    ${server_node_name}
	Should Be Equal As Strings    ${status}    True    msg=Server ${server_node_name} added successfully but it is offline