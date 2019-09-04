*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

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

        : FOR    ${index}    IN RANGE    1    6
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

        FOR    ${index}    IN RANGE    1    6
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
        Should Be Equal As Strings    ${status}    True    msg=Role ${role3_name} is not present in Role list
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
        Should Be Equal As Strings    ${status}    True    msg=Role ${role4_name} is not present in Role list
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
        Should Be Equal As Strings    ${status}    True    msg=Role ${role5_name} is not present in Role list
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

        : FOR    ${index}    IN RANGE    1    6
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

        : FOR    ${index}    IN RANGE    1    6
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

        : FOR    ${index}    IN RANGE    1    6
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

        FOR    ${index}    IN RANGE    1    6
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


*** variables ***
@{owner}    ${1}
