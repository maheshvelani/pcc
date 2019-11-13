*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String
Library         SSHLibrary

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot
Library         ${CURDIR}/../lib/Entry_Criteria_Api.py


*** Test Cases ***
PCC-login-page-testing-with-valid-credentials
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with valid username, password and url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${valid_user_name}    password=${valid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200
        ${bearer_token}    Catenate    Bearer    ${resp.json()['token']}
        Set Suite Variable    ${sec_token}    ${bearer_token}
        &{auth_header}    Create Dictionary   Authorization=${sec_token}
        Set Suite Variable    ${headers}    ${auth_header}


PCC-login-page-testing-with-invalid-username
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with invalid username,valid password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${invalid_user_name}    password=${valid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-invalid-password
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with valid username, invalid password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${valid_user_name}    password=${invalid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-invalid-credentials
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with invalid username,invalid password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${invalid_user_name}    password=${invalid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-empty-username
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with empty username,valid password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=    password=${valid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-empty-password
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with valid username,empty password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${valid_user_name}    password=
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-empty-usernameandpassword
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with empty username,empty password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=    password=
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-empty-username-and-invald-password
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with empty username, invalid password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=    password=${invalid_user_pwd}
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC-login-page-testing-with-invalid-username-and-empty-password
        [Tags]    Login
        [Documentation]    Test login page of PCC UI with invalid username, empty password and valid url
        [Setup]    Create Session    platina    ${server_url}    verify=False
        [Teardown]    Delete All Sessions

        &{data}=    Create Dictionary   username=${invalid_user_name}    password=
        ${resp}  Post Request    platina   ${login}    json=${data}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  401
        Should Contain    ${resp.json()}    Bad credentials!


PCC Node Group
        [Tags]    Node Mgmt    Groups
        [Documentation]    verify User Should Be able to access Node Groups
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	# Click on node group
    	${resp}  Get Request    platina   ${get_group}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}    200
    	Sleep    2s


PCC Node Group Create
        [Tags]    Node Mgmt    Groups
        [Documentation]    Adding new node group
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${group1_name}    Description=${group1_desc}
    	Log    \nCreating Group with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings    ${resp.status_code}    200

    	# Wait for few seconds to reflect group over UI
    	Sleep    5s

        # Validate added group present in Group List
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched group list and verify added Group availability from response data
        ${status}    ${id}    Validate Group    ${resp.json()}    ${group1_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group1_name} is not present in Groups list
        Set Suite Variable    ${create_group1_id}    ${id}
        Log    \n Group ${group1_name} ID = ${create_group1_id}   console=yes
        Sleep    2s


PCC Node group creation without description
        [Tags]    Node Mgmt  Groups
        [Documentation]    Adding new node group without description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group2_name}    Description=
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        Sleep    5s

        # Validate added group present in Group List
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched group list and verify added Group availability from response data
        ${status}    ${id}    Validate Group    ${resp.json()}    ${group2_name}
        Should Be Equal As Strings    ${status}    True    msg=Group Not Created without description successfuly...
        Set Suite Variable    ${create_group2_id}    ${id}
        Log    \n Group ${group2_name} ID = ${create_group2_id}   console=yes
        Sleep    2s


PCC Node group creation without name
        [Tags]    Node Mgmt    Groups
        [Documentation]    Adding new node group without name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Description=${group2_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200  msg=Group created without name...

        # Wait for few seconds to reflect group over UI
        Sleep    5s
#
#        # Validate added group present in Group List
#        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#
#        # Parse fetched group list and verify added Group availability from response data
#        ${status}    ${id}    Validate Group Desc    ${resp.json()}    ${group2_desc}
#        Should Be Equal As Strings    ${status}    False    msg=Group Created without name successfuly...
#        Set Suite Variable    ${create_group2_id}    ${id}
#        Log    \n Group ${group2_name} ID = ${create_group2_id}   console=yes
#        Sleep    2s
#

PCc Node group deletion
        [Tags]    Node Mgmt    Groups
        [Documentation]    Deleting a node group
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group3_name}    Description=${group3_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        Sleep    5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group3_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group3_name} is not present in group list

        # Delete Node Group
	    ${resp}  Delete Request    platina   ${get_group}${group_id}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings    ${resp.status_code}    200

    	# Wait for few seconds to reflect group over UI
    	Sleep    5s

    	# Validate Deleted Group
    	${resp}  Get Request    platina   ${get_group}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings    ${resp.status_code}    200
    	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group3_name}
    	Should Be Equal As Strings    ${status}    False    msg=Group ${group3_name} is present in Groups list
    	Sleep    2s


PCC Node Group Edit
        [Tags]    Node Mgmt    Groups
        [Documentation]    Edit node group
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group4_name}    Description=${group4_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group4_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group4_name} is not present in group list

        # Update Group Information
        &{data}    Create Dictionary  Name=${group5_name}    Description=${group5_desc}  Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get updated Group
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group5_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group4_name} is not present in group list


PCC Duplicate Node Group Creation
        [Tags]    Node Mgmt    Groups
        [Documentation]    Create a Duplicate Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Group
        &{data}    Create Dictionary  Name=${group6_name}    Description=${group6_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Add Duplicate Group
        &{data}    Create Dictionary  Name=${group6_name}    Description=${group6_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        # Should Be Equal As Strings    ${resp.status_code}    200

        # Get Added Groups
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_cnt}    get node group count    ${resp.json()}    ${group6_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group6_name} is not present in group list
        Should Be Equal As Strings    ${group_cnt}    1    msg=Group ${group6_name} is created twice with same name


Clear exist node group description
        [Tags]    Node Mgmt    Groups
        [Documentation]    Clear Node Group description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group7_name}    Description=${group7_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group7_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group7_name} is not present in group list

        # Update Group Information
        &{data}    Create Dictionary  Name=${group7_name}    Description=    Id=${${group_id}}
        Log    \nUpdating Node Group with empty description..    console=yes
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get and validate updated Group
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Get Node Group Count    ${resp.json()}    ${group7_name}  desc=${true}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group7_name} description is not empty/clear


PCC Node Group Name Change
        [Tags]    Node Mgmt    Groups
        [Documentation]    Update node group name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group8_name}    Description=${group8_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group8_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group8_name} is not present in group list

        # Update Group Information
        &{data}    Create Dictionary  Name=${update8_name}  Description=${group8_desc}  Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get updated Group
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${update8_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${update8_name} name is not updated...


PCC Node Group Description Change
        [Tags]    Node Mgmt    Groups
        [Documentation]    Update node group description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group9_name}    Description=${group9_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group9_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group9_name} is not present in group list

        # Update Group Information
        &{data}    Create Dictionary  Name=${group9_name}  Description=${update9_desc}  Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get updated Group
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group Desc    ${resp.json()}    ${update9_desc}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group9_name} description is not updated...


Create Node Group with Special Characters Only
        [Tags]    Node Mgmt    Groups
        [Documentation]    Create Node Groups with Special Character Only
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group10_name}    Description=${group10_name}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        # Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group10_name}
        Should Be Equal As Strings    ${status}    False    msg=Group ${group10_name} Created Successfully....


Create Node Group with Numerics Characters Only
        [Tags]    Node Mgmt    Groups
        [Documentation]    Create Node Group with Numerics Characters Only
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group11_name}    Description=${group11_name}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        # Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group11_name}
        Should Be Equal As Strings    ${status}    False    msg=Group ${group11_name} Created Successfully....


Node group name contain only space
        [Tags]    Node Mgmt    Groups
        [Documentation]    Create Node Group with Space as Name Only
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group12_name}    Description=${group12_name}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        # Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group12_name}
        Should Be Equal As Strings    ${status}    False    msg=Group ${group12_name} Created Successfully....


Create 100 node groups
        [Tags]    Node Mgmt    Groups
        [Documentation]    Create Multiple Node Group
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        : FOR    ${index}    IN RANGE    1    101
        \   &{data}    Create Dictionary  Name=${group13_name}${index}    Description=${group13_desc}${index}
        \   ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \
        \   # Wait for few seconds to reflect group over UI
        \   sleep      5s
        \
        \   ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    ${id}    Validate Group    ${resp.json()}    ${group13_name}${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Group ${group13_name}${index} is not present in Groups list
        \   Sleep    1s


Delete 100 node groups
        [Tags]    Node Mgmt    Groups
        [Documentation]    Delete Multiple Node Group
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        FOR    ${index}    IN RANGE    1    101
        \   # Get Node ID
        \   ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    ${group_id}    Validate Group    ${resp.json()}    ${group13_name}${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Group ${group13_name}${index} is not present in group list
        \
        \   # Delete Group
        \   ${resp}  Delete Request    platina   ${get_group}${group_id}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \
        \   Sleep    5s
        \
        \   # Validate Group deleted
        \   ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    ${id}    Validate Group    ${resp.json()}    ${group13_name}${index}
        \   Should Be Equal As Strings    ${status}   False     msg=Group ${group13_name}${index} is present in Groups list
        \   Sleep    1s


Update PCC Node Group Name with Existing Group Name
        [Tags]    Node Mgmt  Groups
        [Documentation]    Update Node With Existing One
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group14_name}    Description=${group14_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group14_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group14_name} Created Successfully....

        # Update Group Information
        &{data}    Create Dictionary  Name=${group1_name}  Description=${group14_desc}  Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Node Group Updated with Existing name...


Clear exist node group name
        [Tags]    Node Mgmt    Groups
        [Documentation]    Clear Node Group Name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${group15_name}    Description=${group15_desc}
        Log    \nCreating Group with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect group over UI
        sleep      5s

        # Get Added Group ID
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
     	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group15_name}
        Should Be Equal As Strings    ${status}    True    msg=Group ${group15_name} is not present in group list

        # Update Group Information
        &{data}    Create Dictionary  Name=    Description=${group15_desc}    Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Group Name updated with Empty field...


Verify the UI Node Role Information
        [Tags]    Node Mgmt    Roles
        [Documentation]    Verify the UI information on node role
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions


        # Click on node role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Log    \nResponse = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        Sleep    2s


PCC Node Role Creation
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding new node role
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role1_name}    Description=${role1_desc}  templateIDs=@{app}  owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate  Added Node Role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role1_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role1_name} is not present in Role list
        Sleep    2s


PCC Node Role Creation Without Name
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding new node role without name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Description=${role2_desc}  owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Node Role Created successfully without Name

#        # Wait for few seconds to reflect node role over UI
#        Sleep    2s
#
#        # Validate  Added Node Role
#        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#
#        # Parse fetched role list and verify geted Role availability from response data
#        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role2_name}
#        Should Be Equal As Strings    ${status}    True    msg=Role ${role2_name} is not present in Role list
#        Sleep    2s


PCC Node Role Creation Without Description
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding new node role without description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role3_name}  Description=   owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate geted role present in Role List
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role3_name}
        Should Be Equal As Strings    ${status}    False    msg=Role ${role3_name} is not present in Role list
        Sleep    2s


Node Role Creation Without Application
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding new node role without Application
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role4_name}    Description=${role4_desc}    owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate geted role present in Role List
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role4_name}
        Should Be Equal As Strings    ${status}    False    msg=Role ${role4_name} Created successfully without Application
        Sleep    2s


Node Role Creation Without Tenant
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding new node role without Tenant
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role5_name}  Description=${role5_desc}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate geted role present in Role List
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role5_name}
        Should Be Equal As Strings    ${status}    False    msg=Role ${role5_name} Created successfully without Tenant
        Sleep    2s


PCC Node Role Creation With All Fields Empty
        [Tags]    Node Mgmt  Roles
        [Documentation]    Adding new node role with empty fields
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=    Description=     owners=  templateIDs=
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200
        Sleep    2s


PCC Edit Node Role
        [Tags]    Node Mgmt    Roles
        [Documentation]    Updating node roles
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role6_name}  Description=${role6_desc}  owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        sleep      5s

        # Validate Added Node Roles
        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role6_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role6_name} is not present in role list

        &{data}    Create Dictionary  Name=${updated6_name}  Description=${updated6_desc}
        ${resp}     Put Request   platina   ${add_role}${role_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Sleep    10s

        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${updated6_name}
        Should Be Equal As Strings    ${status}    True    msg=Role Not Updated......


PCC Node Role Creation with More Than One App
        [Tags]    Node Mgmt    Roles
        [Documentation]    Create Node Role with More Than one App
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}  ${9}
        &{data}    Create Dictionary  Name=${role7_name}  Description=${role7_desc}  owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        sleep      5s

        # Validate Added Node Roles
        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role7_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role7_name} is not present in role list


PCC Node-Role deletion
        [Tags]    Node Mgmt    Roles
        [Documentation]    Deleting a node role
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role8_name}    Description=${role8_desc}    owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        Sleep    5s

        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role8_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role8_name} is not present in role list

        # Delete Added Node Role
        ${resp}  Delete Request    platina   ${add_role}${role_id}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        Sleep    5s

        # Validate Deleted Role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${role_id}    Validate Roles     ${resp.json()}    ${role8_name}
        Should Be Equal As Strings    ${status}    False    msg=Role ${role8_name} is not Deleted...
        Sleep    2s


Create Duplicate Node
        [Tags]    Node Mgmt    Roles
        [Documentation]    Create a Duplicate Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role1_name}  Description=${role1_desc}  owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200


Clear Exist Node Role Description
        [Tags]    Node Mgmt    Roles
        [Documentation]    Create Role Description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role9_name}    Description=${role9_desc}    owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        Sleep    5s

        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role9_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role9_name} is not present in role list

        # Clear description
        &{data}    Create Dictionary  Name=${role9_name}  Description=
        ${resp}     Put Request   platina   ${add_role}${role_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        Sleep    5s

        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Validate Role Desc    ${resp.json()}  ${role9_name}
        Should Be Equal As Strings    ${status}    True    msg=Role Not Updated......


PCC Node Role Creation With Space Only
        [Tags]    Node Mgmt    Roles
        [Documentation]    Adding node role with space in name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role15_name}    Description=${role15_desc}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200     msg=Node Role created With Only Space as a Name
        sleep    2s


PCC Node Role Creation With name Containing Special Characters Only
        [Tags]    Node Mgmt    Roles
        [Documentation]   Adding a new role with name containing special characters
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role16_name}    Description=${role16_desc}
        Log    \nCreating role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200
        Sleep    10s


PCC Node Role Creation With Name Containing Numbers Only
        [Tags]    Node Mgmt    Roles
        [Documentation]   Adding a new role with name containing numbers
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${role17_name}    Description=${role17_desc}
        Log    \nCreating role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Node Created With Only Numbers as a Name
        Sleep    2s


Create 100 node roles
        [Tags]    Node Mgmt    Roles
        [Documentation]   Adding 100 new roles
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        : FOR    ${index}    IN RANGE    1    101
        \   @{app}    Create List    ${3}
        \   &{data}    Create Dictionary  Name=Test_${index}    Description=Test_${index}  owners=@{owner}  templateIDs=@{app}
        \   ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    ${role_id}    Validate Roles    ${resp.json()}    Test_${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Role Test_${index} is not present in role list


Delete 100 node roles
        [Tags]    Node Mgmt    Roles
        [Documentation]   Deleting 100 node roles
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        : FOR    ${index}    IN RANGE    1    101
        \   ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        \   ${status}    ${role_id}    Validate Roles    ${resp.json()}    Test_${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Role Test_${index} is not present in role list
        \   ${resp}  Delete Request    platina   ${add_role}${role_id}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   # Validate Deleted Role
        \   ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    ${role_id}    Validate Roles     ${resp.json()}    Test_${index}
        \   Should Be Equal As Strings    ${status}    False    msg=Role Test_${index} is not Deleted...
        \   Sleep    2s


Clear exist node role tenant
        [Tags]    Node Mgmt  Roles
        [Documentation]    Changing tenant of node role
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Node
        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role10_name}    Description=${role10_name}  templateIDs=@{app}  owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate  Added Node Role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role10_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role10_name} is not present in Role list
        Sleep    2s

        @{owner}  Create List  ${0}
        # Clear Tenant of Excisting Node
        &{data}    Create Dictionary  Name=${role10_name}  Description=${role10_name}  owners=@{owner}
        ${resp}     Put Request   platina   ${add_role}${role_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        Sleep    5s

        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${id}    Validate Role Tenant    ${resp.json()}  ${role10_name}
        Should Be Equal As Strings    ${status}    True    msg=Role Tenan Is Not Empty......


Change node role name to other exist node role name
        [Tags]    Node Mgmt  Roles
        [Documentation]    Change node role name to other exist node role name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role11_name}    Description=${role11_name}  templateIDs=@{app}  owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate  Added Node Role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${id}    Validate Roles    ${resp.json()}    ${role11_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role11_name} is not present in Role list
        Sleep    2s

        &{data}    Create Dictionary  Name=${role11_name}    Description=${role11_name}  templateIDs=@{app}  owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200


PCC- node role name change
        [Tags]    Node Mgmt  Roles
        [Documentation]    PCC- node role name change
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role12_name}    Description=${role12_desc}  templateIDs=@{app}  owners=@{owner}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        # Validate  Added Node Role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched role list and verify geted Role availability from response data
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role12_name}
        Should Be Equal As Strings    ${status}    True    msg=Role ${role12_name} is not present in Role list
        Sleep    2s

        # Update Node Name
        &{data}    Create Dictionary  Name=${role12_updated}  Description=${role12_desc}
        ${resp}     Put Request   platina   ${add_role}${role_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect node role over UI
        Sleep    5s

        ${resp}  Get Request    platina    ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role12_updated}
        Should Be Equal As Strings    ${status}    True    msg=Role Not Updated......


Verify the information on Sites
        [Tags]    Node Mgmt    Sites
        [Documentation]    verify User Should Be able to access Sites
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Click on node Site
    	${resp}  Get Request    platina   ${get_site}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}    200
    	Sleep    2s


PCC Add Site
        [Tags]    Node Mgmt    Sites
        [Documentation]    Adding new Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site1_name}    Description=${site1_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings    ${resp.status_code}    200

    	# Wait for few seconds to reflect Site over UI
    	Sleep    5s

        # Validate added Site present in Site List
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched site list and verify added Site availability from response data
        ${status}    ${id}    Validate Sites    ${resp.json()}    ${site1_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site1_name} is not present in Site list
        Set Suite Variable    ${create_site1_id}    ${id}
        Log    \nSite ${site1_name} ID = ${create_site1_id}   console=yes
        Sleep    2s


PCC Add Site Without Description
        [Tags]    Node Mgmt    Sites
        [Documentation]    Adding new Site without description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site2_name}    Description=
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings    ${resp.status_code}    200

    	# Wait for few seconds to reflect Site over UI
    	Sleep    5s

        # Validate added Site present in Site List
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched site list and verify added Site availability from response data
        ${status}    ${id}    Validate Sites    ${resp.json()}    ${site2_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site2_name} is not present in Site list
        Set Suite Variable    ${create_site2_id}    ${id}
        Log    \n Site ${site2_name} ID = ${create_site2_id}   console=yes
        Sleep    2s


PCC Add Site Without Name
        [Tags]    Node Mgmt    Sites
        [Documentation]    Adding new Site without name
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Description=${site3_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully without name
    	Sleep    5s


PCC Add Site With Special Character Only
        [Tags]    Node Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only special characters
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site4_name}    Description=${site4_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Special character only
    	Sleep    5s


PCC Add Site With Numeric Value Only
        [Tags]    Node Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site5_name}    Description=${site5_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with numeric value only
    	Sleep    5s


PCC Add Site With Blank Space Only
        [Tags]    Node Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site6_name}    Description=${site6_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with blank space only
    	Sleep    5s


PCC Add Site with name contain mixture of special character, numerical value, alphabet
        [Tags]    Node Mgmt    Sites
        [Documentation]    Add Site in the PCC- name contain mixture of special character, numerical value, alphabet
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

    	&{data}    Create Dictionary  Name=${site7_name}    Description=${site7_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Mixture of special, alphabet and numeric character
    	Sleep    5s


PCC Edit Site Name
        [Tags]    Node Mgmt    Sites
        [Documentation]    Updating Sites
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${site8_name}    Description=${site8_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Node Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site8_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site8_name} is not present in site list

        &{data}    Create Dictionary  Name=${site8_name_update}  Description=${site8_desc}
        ${resp}     Put Request   platina   ${get_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Status code = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Sleep    10s

        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site8_name_update}
        Should Be Equal As Strings    ${status}    True    msg=Site Name Not Updated......


PCC Edit Site Description
        [Tags]    Node Mgmt    Sites
        [Documentation]    Updating Sites
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=${site9_name}    Description=${site9_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Node Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site9_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site9_name} is not present in site list

        &{data}    Create Dictionary  Name=${site9_name}  Description=${site9_desc_update}
        ${resp}     Put Request   platina   ${get_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        Sleep    10s

        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    validate sites desc    ${resp.json()}    ${site9_desc_update}
        Should Be Equal As Strings    ${status}    True    msg=Site Desc Not Updated......


PCC Add Duplicate Site
        [Tags]    Node Mgmt    Sites
        [Documentation]    Creating Duplicate Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site10_name}    Description=${site10_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Node Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site10_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site10_name} is not present in site list

        # Create Duplicate Site
        &{data}    Create Dictionary  Name=${site10_name}    Description=${site10_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200


PCC Delete Single Site
        [Tags]    Node Mgmt    Sites
        [Documentation]    Deleting Single Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site11_name}    Description=${site11_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site11_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site11_name} is not present in site list

        # Delete Site
        @{data}    Create List  ${site_id}
        ${resp}  Post Request    platina   ${delete_site}    headers=${headers}    json=${data}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        Sleep    5s

        # Validate Deleted Site
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site11_name}
        Should Be Equal As Strings    ${status}    False    msg=Deleted Site ${site11_name} is present in Site list


PCC Delete Multiple Site
        [Tags]    Node Mgmt    Sites
        [Documentation]    Deleting Multiple Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site12_name}    Description=${site12_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site1_id}    Validate Sites    ${resp.json()}    ${site12_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site12_name} is not present in site list

        # Add Site
        &{data}    Create Dictionary  Name=${site13_name}    Description=${site13_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site2_id}    Validate Sites    ${resp.json()}    ${site13_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site13_name} is not present in site list

        # Delete Site
        @{data}    Create List  ${site1_id}  ${site2_id}
        ${resp}  Post Request    platina   ${delete_site}    headers=${headers}    json=${data}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        Sleep    5s

        # Validate Deleted Site
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site12_name}
        Should Be Equal As Strings    ${status}    False    msg=Deleted Site ${site12_name} is present in Site list
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site13_name}
        Should Be Equal As Strings    ${status}    False    msg=Deleted Site ${site13_name} is present in Site list


Create 100 Sites
        [Tags]    Node Mgmt    Sites
        [Documentation]    Create Multiple Node Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        : FOR    ${index}    IN RANGE    1    101
        \   &{data}    Create Dictionary  Name=${site14_name}${index}    Description=${site14_name}${index}
        \   ${resp}  Post Request    platina   ${add_site}    json=${data}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \
        \   # Wait for few seconds to reflect Site over UI
        \   sleep      5s
        \
        \   ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    ${id}    Validate Sites    ${resp.json()}    ${site14_name}${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Site ${site14_name}${index} is not present in Sites list
        \   Sleep    1s


Delete 100 Sites
        [Tags]    Node Mgmt    Sites
        [Documentation]    Delete Multiple Sites
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        FOR    ${index}    IN RANGE    1    101
        \   # Get Node ID
        \   ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    ${Site_id}    Validate Sites    ${resp.json()}    ${site14_name}${index}
        \   Should Be Equal As Strings    ${status}    True    msg=Site ${site14_name}${index} is not present in Site list
        \
        \   # Delete Site
        \   @{data}    Create List  ${Site_id}
        \   ${resp}  Post Request    platina   ${delete_site}    headers=${headers}    json=${data}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \
        \   Sleep    5s
        \
        \   # Validate Site deleted
        \   ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    ${id}    Validate Sites    ${resp.json()}    ${site14_name}${index}
        \   Should Be Equal As Strings    ${status}   False     msg=Site ${site14_name}${index} is present in Site list
        \   Sleep    1s


PCC clear Site Name
        [Tags]    Node Mgmt    Sites
        [Documentation]    Clear Existing Site
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site15_name}    Description=${site15_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site15_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site15_name} is not present in site list

        &{data}    Create Dictionary  Name=    Description=${site15_desc}
        ${resp}     Put Request   platina   ${get_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site updated with Emty name


PCC clear Site Description
        [Tags]    Node Mgmt    Sites
        [Documentation]    Clear Existing Site description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site16_name}    Description=${site16_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site16_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site16_name} is not present in site list

        &{data}    Create Dictionary  Name=${site16_name}    Description=
        ${resp}     Put Request   platina   ${get_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200    msg=Site not updated with Emty description

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites Desc   ${resp.json()}    ${site16_desc}
        Should Be Equal As Strings    ${status}    False    msg=Site description not updated


PCC Change Site Name into existing site name in the PCC
        [Tags]    Node Mgmt    Sites
        [Documentation]    Clear Existing Site description
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Site
        &{data}    Create Dictionary  Name=${site17_name}    Description=${site17_desc}
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify Site reflect over UI
        sleep      5s

        # Validate Added Sites
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site17_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site17_name} is not present in site list

        # Update Site
        &{data}    Create Dictionary  Name=${site1_name}    Description=${site1_desc}
        ${resp}     Put Request   platina   ${add_site}${site_id}    json=${data}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Name Updated with existing site name


PCC-Tenant-Creation
        [Tags]    Tenant Mgmt
        [Documentation]    Adding a new Tenant
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Ceate Tenant
        &{data}    Create Dictionary    name=${tenant1_name}  description=${tenant1_desc}  parent=${1}
        Log    \nCreating Tenant with Data = ${data}    console=yes
        ${resp}    Post Request    platina    ${add_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        #Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    ${tenant1_name}
        Should Be Equal As Strings    ${status}    True    msg=Tenant ${tenant1_name} is not present in tenant list
        Log    \nTenant ID = ${tenant_id}    console=yes
        Set Suite Variable    ${tenant1_id}    ${tenant_id}


PCC-Tenant-Deletion
        [Tags]    Tenant Mgmt
        [Documentation]    Deleting a Tenant
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Delete Tenant
        &{data}    Create Dictionary    id=${tenant1_id}
        ${resp}    Post Request    platina    ${delete_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        #Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    ${tenant1_name}
        Should Be Equal As Strings    ${status}    False    msg=Tenant ${tenant1_name} not deleted


PCC-Sub-Tenant-Creation
        [Tags]    Tenant Mgmt
        [Documentation]    Adding a new Sub Tenant
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Ceate Tenant
        &{data}    Create Dictionary    name=${tenant2_name}  description=${tenant2_desc}  parent=${1}
        Log    \nCreating Tenant with Data = ${data}    console=yes
        ${resp}    Post Request    platina    ${add_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        #Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    ${tenant2_name}
        Should Be Equal As Strings    ${status}    True    msg=Tenant ${tenant2_name} is not present in tenant list
        Log    \nTenant ID = ${tenant_id}    console=yes

        # Ceate Sub Tenant
        &{data}    Create Dictionary    name=${tenant3_name}  description=${tenant3_desc}  parent=${${tenant_id}}
        Log    \nCreating Tenant with Data = ${data}    console=yes
        ${resp}    Post Request    platina    ${add_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        #Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    ${tenant3_name}
        Should Be Equal As Strings    ${status}    True    msg=Tenant ${tenant3_name} is not present in tenant list
        Log    \n tenant ID = ${tenant_id}    console=yes
        Set Suite Variable    ${tenant2_id}    ${tenant_id}


PCC-Sub-Tenant-Deletion
        [Tags]    Tenant Mgmt
        [Documentation]    Deleting a Sub Tenant
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Create Tenant
        &{data}    Create Dictionary    id=${tenant2_id}
        ${resp}    Post Request    platina    ${delete_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        #Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    ${tenant3_name}
        Should Be Equal As Strings    ${status}    False    msg=Tenant ${tenant3_name} not deleted


Invader and Server Cleanup from UI
        [Tags]    Entry Criteria
        [Documentation]    Get and Delete available Invader and Server from the PCC
        [Setup]    Verify User Login
        [Teardown]    Delete All Sessions

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
        \    Sleep    3 minutes


Add Invader-1 as a Node and Verify Online Status
        [Tags]    Entry Criteria
        [Documentation]    Add Invader-1 as a Node and Verify Online Status
        [Setup]    Verify User Login
        [Teardown]    Delete All Sessions


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


Pcc-Node-Site-Assignment
        [Tags]    Node Mgmt    Sites
        [Documentation]    Assign a site to Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        &{data}    Create Dictionary  Name=Site_7    Description=Site_7
        Log    \nCreating Site with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect Site over UI
        Sleep    5s

        # Validate added Site present in Site List
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched site list and verify added Site availability from response data
        ${status}    ${id}    Validate Sites    ${resp.json()}    Site_7
        Should Be Equal As Strings    ${status}    True    msg=Site Site_7 is not present in Site list
        Log    \nSite Site_7 ID = ${id}   console=yes
        Set Suite Variable    ${assign_site_id}    ${id}

        Sleep    2s

        # Update Site With Node
        &{data}    Create Dictionary  Id=${invader1_id}    Site_Id=${id}
        ${resp}  Put Request    platina    ${add_site_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        Sleep    60s

        # Validated Updated Site
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Site    ${resp.json()}    ${invader1_node_name}    ${id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${invader1_node_name} is not updated with the site Site_7


Delete Site in the PCC when site is associated with the Node
        [Tags]    Sites
        [Documentation]    Delete Site in the PCC when site is associated with the Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Delete Site
        @{data}    Create List  ${assign_site_id}
        ${resp}  Post Request    platina   ${delete_site}    headers=${headers}    json=${data}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200

        Sleep    5s

        # Validate Site present in Site List
        ${resp}  Get Request    platina   ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched site list and verify added Site availability from response data
        ${status}    ${id}    Validate Sites    ${resp.json()}    Site_7
        Should Be Equal As Strings    ${status}    True    msg=Site Site_7 is not present in Site list


PCC-Node-Tenant-Assignment
        [Tags]    Node Mgmt    Tenant Mgmt
        [Documentation]    Assign a tenant to Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Create Tenant
        &{data}    Create Dictionary    name=Tenant_007   description=Tenant_007    parent=${1}
        ${resp}    Post Request    platina    ${add_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        # Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

        # Wait for few seconds
        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant1_id}    Get Tenant Id    ${resp.json()}    Tenant_007
        Set Suite Variable    ${assign_tenant_id}    ${tenant1_id}
        Log    \n tenant ID = ${tenant1_id}    console=yes

        # Update Node With Tenants
        @{node_id_list}    Create List    ${invader1_id}
        &{data}    Create Dictionary    tenant=${tenant1_id}    ids=@{node_id_list}
        ${resp}    Put Request    platina    ${node_tenant_assignment}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        # Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        Sleep    10s


Delete Tenant in the PCC when tenant is associated with the Node
        [Tags]    Tenant Mgmt
        [Documentation]    Delete Tenant in the PCC when Tenant is associated with the Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Delete Tenant
        &{data}    Create Dictionary    id=${assign_tenant_id}
        ${resp}    Post Request    platina    ${delete_tenant}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings  ${resp.status_code}    200

        # Wait for few seconds
        Sleep    10s

        # Get Tenant Id
        ${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${tenant_id}    Get Tenant Id    ${resp.json()}    Tenant_7
        Should Be Equal As Strings    ${status}    True    msg=Tenant Tenant_7 deleted successfully


Pcc-Node-Group-Assignment
        [Tags]    Node Mgmt    regression_test
        [Documentation]    Node to Group Assignment
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Add Group
        &{data}    Create Dictionary  Name=Group_7    Description=Group_7
        ${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        Sleep    5s

        # Validate added group
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${group_id}    Validate Group    ${resp.json()}    Group_7
        Log    \n Group Group_7 ID = ${group_id}   console=yes
        Set Suite Variable    ${assign_group_id}    ${group_id}
        Should Be Equal As Strings    ${status}    True    msg=Group Group_7 is not present in Groups list

        # Assign Group to Node
        &{data}    Create Dictionary  Id=${invader1_id}    ClusterId=${group_id}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes

        Sleep    60s

        # Validated Assigned Group
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node Group    ${resp.json()}    ${invader1_node_name}    ${group_id}
        Should Be Equal As Strings    ${status}    True    msg=Node ${invader1_node_name} is not updated with the Group_7


Delete Group in the PCC when group is associated with the Node
        [Tags]    Groups
        [Documentation]    Delete Group in the PCC when Group is associated with the Node
        [Setup]  Verify User Login
        [Teardown]  Delete All Sessions

        # Delete Group
        ${resp}  Delete Request    platina   ${get_group}${assign_group_id}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to reflect changes over UI
        Sleep    5s

        # Validate group present
        ${resp}  Get Request    platina   ${get_group}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${group_id}    Validate Group    ${resp.json()}    Group_7
        Should Be Equal As Strings    ${status}    True    msg=Group Group_7 is not present in Groups list


Add Server-1 as a Node and Verify Online Status
        [Tags]    Entry Criteria
        [Documentation]    Add Server-1 as a Node and Verify Online Status
        [Setup]    Verify User Login
        [Teardown]    Delete All Sessions

        # Add Server Node
        ${name}    Set Variable  ${server1_node_name}
        ${host}   Set Variable   ${server1_node_host}
        ${bmc_host}   Set Variable  ${server1_bmc_host}
        ${bmc_user}   Set Variable  ${server1_bmc_user}
        ${bmc_pwd}   Set Variable  ${server1_bmc_pwd}
        ${console}   Set Variable  ${server1_console}
        ${manage_pcc}    Set Variable  ${server1_managed_by_pcc}
        ${ssh_key}    Set Variable  ${server1_ssh_keys}

        @{server1_bmc_users}    Create List    ${bmc_user}
        @{server1_ssh_keys}    Create List
        &{data}    Create Dictionary  	Name=${name}  Host=${host}
        ...    console=${console}  bmc=${bmc_host}  bmcUser=${bmc_user}
        ...    bmcPassword=${bmc_pwd}  bmcUsers=@{server1_bmc_users}
        ...    sshKeys=@{server1_ssh_keys}  managed=${${server1_managed_by_pcc}}

        Log    \nCreating Server node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200

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
        Set Suite Variable    ${server1_id}    ${node_id}

        # Verify Online Status of Added Server
        ${status}    Validate Node Online Status    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${name} added successfully but it is offline


#Assign LLDP and MaaS Roles to Invader - 1
#        [Tags]    Entry Criteria
#        [Documentation]    Assign LLDP and MaaS Role to Invader - 1
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Get Id of MaaS role
#        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#        ${status}    ${role_id}    Get MaaS Role Id    ${resp.json()}
#        Should Be Equal As Strings    ${status}    True    msg=MaaS Role Not Found in Roles
#        Set Suite Variable    ${maas_role_id}    ${role_id}
#        Log    \n MaaS Role ID = ${maas_role_id}    console=yes
#
#        # Get Id of LLDP role
#        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#        ${status}    ${role_id}    Get LLDP Role Id    ${resp.json()}
#        Should Be Equal As Strings    ${status}    True    msg=LLDP Role Not Found in Roles
#        Set Suite Variable    ${lldp_role_id}    ${role_id}
#        Log    \n LLDP Role ID = ${lldp_role_id}    console=yes
#
#        # Assign MaaS role to node - 1
#        @{roles_group}    create list    ${lldp_role_id}    ${maas_role_id}
#        &{data}    Create Dictionary  Id=${invader1_id}    roles=${roles_group}
#        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#
#        # Wait for few Seconds
#        Sleep    150s
#
#        # SSH into invader and verify MaaS installation process started
#        Run Keyword And Ignore Error	SSH into Invader and Verify mass installation started    ${invader1_node_host}
#
#        # Wait for 10 minutes
#        Sleep	10 minutes
#
#        # Verify Maas Installation Complete status
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${invader1_node_name}    ${maas_role_id}
#        Should Be Equal As Strings    ${status}    True    msg=Node ${invader1_node_name} is not updated with the MaaS Roles
#
#        Run Keyword And Ignore Error	SSH into Invader and Verify mass installation started    ${invader1_node_host}
#
#
#Assign LLDP role to server - 1
#        [Tags]    Entry Criteria
#        [Documentation]    Assign LLDP Role to Server - 1
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Assign MaaS role to node - 2
#        @{roles_group}    create list    ${lldp_role_id}
#        &{data}    Create Dictionary  Id=${server1_id}    roles=${roles_group}
#        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#
#        # Wait for few Seconds
#        Sleep	5 minutes
#
#        # Verify Maas Installation Complete status
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${server1_node_name}    ${lldp_role_id}
#        Should Be Equal As Strings    ${status}    True    msg=Node ${server1_node_name} is not updated with the LLDP Role
#
#
#PXE Boot to Server
#        [Tags]    Entry Criteria
#        [Documentation]    Server PXE Boot
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        ${status}    Server PXE boot    ${server2_bmc_host}
#        Should Be Equal As Strings    ${status}    True    msg=PXE boot Failed Over Server ${server2_node_host}
#        # Wait till Server Get Booted
#        Log    \nPXE boot Started......    console=yes
#        Sleep   5 minutes
#        Log    \nPXE boot Started......    console=yes
#        Sleep   5 minutes
#
#
#Validate Interface Mode - Expected Inventory Mode
#        [Tags]    Entry Criteria
#        [Documentation]    Verify that Server is in inventory mode
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
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
#
#
#Update Server information added after PXE boot
#        [Tags]    Entry Criteria
#        [Documentation]    Update Server information
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Get Server ID
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    ${node_id}    Get Server Id    ${resp.json()}    ${server2_bmc_host}
#        Should Be Equal As Strings    ${status}    True    msg=Booted Server ${server2_bmc_host} is not present in node list
#        Log    \n Server ${server2_node_name} ID = ${node_id}   console=yes
#        Set Suite Variable    ${server2_id}    ${node_id}
#
#        # Get server Interface from topology
#        Log    \nGetting Topology Data...    console=yes
#        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#
#        ${i_interface}  Get_booted_server_interface  ${resp.json()}  ${server2_id}
#        Log    \n\nBooted server Interface = ${i_interface}  console=yes
#
#        # Get Booted server details
#        ${resp}  Get Request    platina   ${get_node_list}/${server2_id}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#
#        # Get valid server interface to set management IP
#        ${mngmt_interface}    get management ip interface    ${resp.json()}  ${i_interface}
#        Log    \nFound Suitable interface to assign management Ip = ${mngmt_interface}  console=yes
#
#        # Set Management Ip
#        @{mgt_ip}    Create List    ${server2_node_host}
#        &{data}    Create Dictionary  nodeID=${${server2_id}}  ipv4Addresses=@{mgt_ip}  ifName=${mngmt_interface}  gateway=172.17.2.1  management=${true}
#        Log    \nAssigning management ip with params = ${data}    console=yes
#        ${resp}  Post Request    platina    ${add_interface}    json=${data}     headers=${headers}
#        Log    \n MGT IP Assign status Code = ${resp.status_code}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#        Sleep    1 minutes
#
#
#        # Update Server Node with proper information
#        @{server2_bmc_users}    Create List    ${server2_bmc_user}
#        @{server2_ssh_keys}    Create List    ${server2_ssh_keys}
#
#        &{data}    Create Dictionary    Id=${server2_id}  Name=${server2_node_name}  console=${server2_console}
#        ...    managed=${${server2_managed_by_pcc}}  bmc=${server2_bmc_host}/23  bmcUser=${server2_bmc_user}
#        ...    bmcPassword=${server2_bmc_pwd}  bmcUsers=@{server2_bmc_users}
#        ...    sshKeys=@{server2_ssh_keys}  Host=${server2_node_host}
#        Log    \n Updating Server with Data : \n${data}\n    console=yes
#        ${resp}  Put Request    platina    ${update_node}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        # Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#
#        # wait for few seconds
#        Sleep    90s
#
#        # Validate Updated Server Present in Node List
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        # And verify Node availability from the latest fetched node data
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#
#        # Parse fetched node list and verify added Node availability from response data
#        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${server2_node_name}
#        Should Be Equal As Strings    ${status}    True    msg=Server ${server2_node_name} is not present in node list
#        Log    \n Server ${server2_node_name} ID = ${node_id}   console=yes
#        Set Suite Variable    ${server2_id}    ${node_id}
#
#
#OS Deployment over Server machine
#        [Tags]    Entry Criteria
#        [Documentation]    OS Deployment
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Start OS Deployment
#        &{data}    Create Dictionary  nodes=[${${server2_id}}]  image=${image_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
#        Log    \n Deploying OS with params = ${data}    console=yes
#        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n Response Data = ${resp.json()}    console=yes
#    	Should Be Equal As Strings  ${resp.status_code}  200
#
#        # Wait for 15 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	7 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	7 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	7 minutes
#
#        # Verify Provision Status over server
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Validate OS Provision Status    ${resp.json()}    ${server2_node_name}
#        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server2_node_name} is not Finished
#
#        # Verify CentOS installed in remote machine
#        Run Keyword And Ignore Error    Verify CentOS installed in server machine
#
#
#Assign LLDP role to Server - 2
#        [Tags]    Entry Criteria
#        [Documentation]    Assign LLDP to Server - 2
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Assign Role to Node
#        &{data}    Create Dictionary  Id=${server2_id}    roles=${lldp_role_id}
#        Log    \nAssigning a Roles with parameters: \n${data}\n    console=yes
#        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#
#        # Wait for few seconds to reflect assign roles over node
#        Sleep	5 minutes
#
#        # Validate Assigned Roles
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${server2_node_name}    ${lldp_role_id}
#        Should Be Equal As Strings    ${status}    True    msg=Node ${server2_node_name} is not updated with the Roles LLDP
#
#        Sleep	2 minutes
#
#        # Verify Online Status of Added Server
#        ${status}    Validate Node Online Status    ${resp.json()}    ${server2_node_name}
#        Should Be Equal As Strings    ${status}    True    msg=Server ${server2_node_name} added successfully but it is offline
#
#
#Assign Interface Ip to node to form Topology
#        [Tags]    Entry Criteria
#        [Documentation]	  Assign IP to interfaces
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        Log    \nGetting Topology Data...    console=yes
#        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#
#        ${interface_sv1}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server1_node_name}
#        ${interface_sv2}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server2_node_name}
#        ${interface1_name}  Get Interface Name    ${resp.json()}  ${server1_node_name}  ${invader1_node_name}
#        ${interface2_name}  Get Interface Name    ${resp.json()}  ${server2_node_name}  ${invader1_node_name}
#
#        Log  \n\nInterface Between ${invader1_node_name} and ${server1_node_name} = ${interface_sv1}  console=yes
#        Log  \n\nInterface Between ${invader1_node_name} and ${server2_node_name} = ${interface_sv2}  console=yes
#        Log  \n\nInterface Between ${server1_node_name} and ${invader1_node_name} = ${interface1_name}  console=yes
#        Log  \n\nInterface Between ${server2_node_name} and ${invader1_node_name} = ${interface2_name}  console=yes
#
#        Set Suite Variable    ${interface_sv1}
#        Set Suite Variable    ${interface_sv2}
#        Set Suite Variable    ${interface1_name}
#        Set Suite Variable    ${interface2_name}
#
#        # Get Invader Topology
#        ${status}    ${sv1_topology}    Prepare Invader Topology  ${resp.json()}  ${invader1_id}  ${interface_sv1}  192.0.2.102/31
#        ${status}    ${sv2_topology}    Prepare Invader Topology  ${resp.json()}  ${invader1_id}  ${interface_sv2}  192.0.2.100/31
#        ${status}    ${i1_topology}    Prepare Invader Topology  ${resp.json()}  ${server1_id}  ${interface1_name}  192.0.2.103/31
#        ${status}    ${i2_topology}    Prepare Invader Topology  ${resp.json()}  ${server2_id}  ${interface2_name}  192.0.2.101/31
#
#        # Update Invader interfaces
#        Log    \n Updating invader topology with data = ${sv1_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${sv1_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
#        #Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    5s
#
#        Log    \n Updating invader topology with data = ${sv2_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${sv2_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
#        #Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    5s
#
#        Log    \n Updating Server topology with data = ${i1_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${i1_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
#        #Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    5s
#
#        Log    \n Updating Server topology with data = ${i2_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${i2_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
#        #Should Be Equal As Strings  ${resp.status_code}  200
#
#        # Wait for few minutes to reflect assign IP into topology
#        Sleep  5 minutes
#
#
#Validate Interface Mode - Expected user mode
#        [Tags]    Entry Criteria
#        [Documentation]    Verify that Server is in inventory mode
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # verify Mode into Inventory
#        Validate server Mode    user
#
#
#Create Kubernetes Cluster
#        [Tags]    Entry Criteria
#        [Documentation]    Create Kubernetes Cluster
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Create Kubernetes cluster
#        &{data1}    Create Dictionary  id=${${invader1_id}}
#        &{data2}    Create Dictionary  id=${${server1_id}}
#        &{data3}    Create Dictionary  id=${${server2_id}}
#        @{json}    Create List    ${data1}  ${data2}  ${data3}
#
#        &{data}    Create Dictionary  name=${cluster_name}  k8sVersion=${cluster_version}  cniPlugin=${cni_plugin}
#        ...    nodes=@{json}
#        Log    \nCreating Cluster with data: ${data}\n
#        ${resp}  Post Request    platina   ${add_kubernetes_cluster}    json=${data}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}  200
#
#        # Wait for few seconds
#        Sleep  5 minutes
#        Log To Console    \nK8s is installing.....
#        Sleep  5 minutes
#        Log To Console    \nK8s is installing.....
#        Sleep  5 minutes
#        Log To Console    \nK8s is installing.....
#        Sleep  5 minutes
#        Log To Console    \nK8s is installing.....
#        Sleep  3 minutes
#
#        # Verify cluster created
#        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    ${id}    Validate Cluster    ${resp.json()}    ${cluster_name}
#        Should Be Equal As Strings    ${status}    True    msg=Created Cluster ${cluster_name} is not present in Cluster list
#        Set Suite Variable    ${cluster_id}    ${id}
#        ${status}    Validate Cluster Deploy Status    ${resp.json()}
#        Should Be Equal As Strings    ${status}    True    msg=Cluster installation failed#
#        ${status}    Validate Cluster Health Status    ${resp.json()}
#        Should Be Equal As Strings    ${status}    True    msg=Cluster installed but Health status is not good
#
#
#Verify Created K8s Cluster installation from back end
#        [Tags]    Entry Criteria
#        [Documentation]    Verify Kubernetes Cluster
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        Verify K8s installed
#
#
#Add an app to k8s
#        [Tags]    Entry Criteria
#        [Documentation]    Add an App to K8S
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Add an App to Kubernetes cluster
#        &{data}    Create Dictionary  label=${app_name}  appName=${app_name}  appNamespace=${app_name}  gitUrl=${git_url}
#        ...  gitRepoPath=${git_repo_path}  gitBranch=${git_branch}
#        Log    \nAdding App with Data: ${data}\n  console=yes
#        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    2 minutes
#
#        # Verify App Installed Successfully..
#        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Verify App Present in Cluster    ${resp.json()}    ${app_name}
#        Should Be Equal As Strings    ${status}    True    msg=Installed App ${app_name} is not present/installed in cluster
#
#
#Update k8s and verify version updated
#        [Tags]    Entry Criteria
#        [Documentation]    Update K8s version
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Upgrade K8s Version
#        &{data}    Create Dictionary  k8sVersion=${upgrade_k8_version}
#        Log    \nUpgrading k8s with Data: ${data}\n  console=yes
#        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/upgrade  json=${data}  headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n RESP = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#        Sleep    5 minutes
#        Log To Console    K8s Upgrading........
#
#        # Verify K8s Upgradded
#        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Verify Cluster Version    ${resp.json()}    ${upgrade_k8_version}
#        Should Be Equal As Strings    ${status}    True    msg=K8s is not upgradder with version = ${upgrade_k8_version}
#
#
#Install another app as sanity check
#        [Tags]    Entry Criteria
#        [Documentation]    Insatall Another app as sanity check
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#
#        # Install an App to K8s Cluster
#        &{data}    Create Dictionary  label=${app2_name}  appName=${app2_name}  appNamespace=${app2_name}  gitUrl=${git2_url}
#        ...  gitRepoPath=${git2_repo_path}  gitBranch=${git2_branch}
#        Log    \nAdding App with Data: ${data}\n  console=yes
#        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}  200
#
#        Sleep    2 minutes
#
#        # Verify App Installed Successfully..
#        ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Verify App Present in Cluster    ${resp.json()}    ${app2_name}
#        Should Be Equal As Strings    ${status}    True    msg=Installed App ${app2_name} is not present/installed in cluster
#
#
#Delete K8s Cluster
#        [Tags]    Entry Criteria
#        [Documentation]    Delete K8s Cluster
#        [Setup]    Verify User Login
#        [Teardown]    Delete All Sessions
#
#        # Delete K8s Cluster
#        Log    \n\nDeleting Cluster...    console=yes
#        ${resp}  Delete Request	   platina    ${add_kubernetes_cluster}/${cluster_id}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}  200
#
#        # Wait for few seconds
#        Sleep    5 minutes
#
#        # Verify Cluster Deleted
#        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
#        Should Be Equal As Strings    ${status}    True    msg=Cluster ${cluster_name} not deleted


PCC_Add_Existing_Invader
        [Tags]    Node Mgmt
        [Documentation]    Add Existing Node
        [Setup]    Verify User Login
        [Teardown]    Delete All Sessions

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
        ${status}    Validate Node 2    ${resp.json()}    ${invader1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Invader ${invader1_node_name} is not present twice in node list


PCC_Add_Existing_Server
        [Tags]    Node Mgmt
        [Documentation]    PCC_Add_Existing_Server
        [Setup]    Verify User Login
        [Teardown]    Delete All Sessions

        # Add Server Node
        ${name}    Set Variable  ${server1_node_name}
        ${host}   Set Variable   ${server1_node_host}
        ${bmc_host}   Set Variable  ${server1_bmc_host}
        ${bmc_user}   Set Variable  ${server1_bmc_user}
        ${bmc_pwd}   Set Variable  ${server1_bmc_pwd}
        ${console}   Set Variable  ${server1_console}
        ${manage_pcc}    Set Variable  ${server1_managed_by_pcc}
        ${ssh_key}    Set Variable  ${server1_ssh_keys}

        @{server1_bmc_users}    Create List    ${bmc_user}
        @{server1_ssh_keys}    Create List
        &{data}    Create Dictionary  	Name=${name}  Host=${host}
        ...    console=${console}  bmc=${bmc_host}  bmcUser=${bmc_user}
        ...    bmcPassword=${bmc_pwd}  bmcUsers=@{server1_bmc_users}
        ...    sshKeys=@{server1_ssh_keys}  managed=${${server1_managed_by_pcc}}

        Log    \nCreating Server node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200

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
        ${status}    Validate Node 2    ${resp.json()}    ${name}
        Should Be Equal As Strings    ${status}    False    msg=Server ${name} is present twice in node list


*** keywords ***
SSH into Invader and Verify mass installation started
        [Arguments]    ${invader_ip}
        ${i_ip}    get ip   ${invader_ip}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}        ${invader_usr_pwd}
        Sleep    2s
        ${output}=         SSHLibrary.Execute Command    ps -aef | grep ROOT
        SSHLibrary.Close All Connections
        Log    \n\n INVADER DATA = ${output}    console=yes
	Should Contain    ${output}    lighttpd.conf
        Should Contain    ${output}    tinyproxy.conf
        Should Contain    ${output}    dnsmasq




Verify CentOS installed in server machine
        # Get OS release data from server
        ${server_ip}    get ip   ${server2_node_host}
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
        SSHLibrary.Close All Connections
        Log    \n\nK8S - DATA = ${output} \n\n    console=yes
        Should Contain  ${output}    Ready
        Should Contain  ${output}    master


Validate server Mode
        [Arguments]    ${mode}
        # Get OS release data from server
        ${i_ip}    get ip   ${invader1_node_host}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}  ${invader_usr_pwd }
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo grep \'${interface_sv2}\' /srv/maas/state/tenants.json -C 2
        SSHLibrary.Close All Connections
        Log    \nINVENTORY DATA = ${output}\n    console=yes
        Sleep    2s
        ${status}    Validate Inventory Data    ${output}    ${mode}
        Should Be Equal As Strings    ${status}  True  msg=Expected mode is = ${mode} but actual mode is different...


*** variables ***
@{owner}    ${1}
