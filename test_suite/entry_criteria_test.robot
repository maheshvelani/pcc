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
