*** Settings ***
Library  	OperatingSystem
Library  	Collections
Library  	String

Library    	${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Test_Data.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions


*** test cases ***

Pcc-node-summary-add-node
	[Tags]    Node Management    regression_test
	[Documentation]    Add node in the PCC

	# Add Node
	&{data}    Create Dictionary  	Name=${node1_name}  Host=${node1_host_addr}  bmc=${node1_bmc}  bmcUser=${node1_bmc_user}  bmcPassword=${node1_bmc_pwd}
	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings    ${resp.status_code}    200
	Should Be Equal As Strings    ${resp.json()['status']}    200

	Sleep    10s

	# Validate Added Node
	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
 	${status}    Validate Node    ${resp.json()}    ${node1_name}
	Should Be Equal As Strings    ${status}    True    msg=node ${node1_name} is not present in node list


Pcc-node-summary-add-node-without-BMC-password
	[Tags]    Node Management    regression_test
	[Documentation]    Add node in the PCC without BMC pass

	# Add Node
	&{data}    Create Dictionary  	Name=${node2_name}  Host=${node2_host_addr}  bmc=${node2_bmc}  bmcUser=${node2_bmc_user}
	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings    ${resp.status_code}    200
	Should Be Equal As Strings    ${resp.json()['status']}    200

	Sleep    10s

	# Validate Added Node
	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
	${resp}  Get Request    platina   ${get_node_list}    params=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
 	${status}    Validate Node    ${resp.json()}    ${node2_name}
	Should Be Equal As Strings    ${status}    True    msg=node ${node2_name} is not present in node list


Pcc-node-summary-add-node-managed-by-pcc
	[Tags]    Node Management    regression_test
	[Documentation]    Add node – managed-by-pcc check box should be not be checked by default

	# Validate Added Node
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
        ${status}    Validate Node Manage Status    ${resp.json()}    ${node1_name}    false
        Should Be Equal As Strings    ${status}    True    msg=node manage status of ${node1_name} is true by default


Create 10 sites over platina server
	[Tags]    Node    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
	&{headers}=    Create Dictionary   Authorization=${sec_token}
	:FOR    ${index}    IN RANGE    1  11
	\    &{data}    Create Dictionary  Name=Site_${Index}    Description=Site_${Index}
	\    ${resp}  Post Request    platina   /pccserver/site/add/    json=${data}     headers=${headers}
	\    Log    \n Status code = ${resp.status_code}    console=yes
	\    Log    \n Response = ${resp.json()}    console=yes
	\    Should Be Equal As Strings  ${resp.status_code}    200
