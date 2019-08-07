*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Test_Data_Node_Group.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions


*** Test Cases ***
PCC Node Group
        [Tags]    Node Mgmt    Groups
        [Documentation]    verify User Should Be able to access Node Groups

    	# Click on node group
    	${resp}  Get Request    platina   ${get_group}    headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yShould Be Equal As Strings  ${resp.status_code}    200
	Should Be Equal As Strings  ${resp.status_code}    200
	Sleep    2s


PCC Node Group Create
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Adding new node group

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
        [Tags]    NodeG Mgmt  Groups
        [Documentation]    Adding new node group without description

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
        Should Be Equal As Strings    ${status}    False    msg=Group Created without description successfuly...
        Set Suite Variable    ${create_group2_id}    ${id}
        Log    \n Group ${group2_name} ID = ${create_group2_id}   console=yes
        Sleep    2s


PCC Node group creation without name
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Adding new node group without name

        &{data}    Create Dictionary  Name=    Description=${group2_desc}
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
        ${status}    ${id}    Validate Group Desc    ${resp.json()}    ${group2_desc}
        Should Be Equal As Strings    ${status}    False    msg=Group Created without name successfuly...
        Set Suite Variable    ${create_group2_id}    ${id}
        Log    \n Group ${group2_name} ID = ${create_group2_id}   console=yes
        Sleep    2s


PCc Node group deletion
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Deleting a node group

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Edit node group

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Create a Duplicate Node

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Clear Node Group description

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Update node group name

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Update node group description

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
        Should Be Equal As Strings    ${status}    True    msg=Group ${update9_name} description is not updated...


Create Node Group with Special Characters Only
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Create Node Groups with Special Character Only

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Create Node Group with Numerics Characters Only

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Create Node Group with Space as Name Only

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Create Multiple Node Group

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
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Delete Multiple Node Group

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
        \   ${status}    ${id}    Validate Group    ${resp.json()}    ${group_name}${index}
        \   Should Be Equal As Strings    ${status}   False     msg=Group ${group_name}${index} is present in Groups list
	\   Sleep    1s


Update PCC Node Group Name with Existing Group Name
        [Tags]    NodeG Mgmt  Groups
        [Documentation]    Update Node With Existing One

        &{data}    Create Dictionary  Name=${group14_name}    Description=${group14_name}
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
        Should Be Equal As Strings    ${status}    False    msg=Group ${group14_name} Created Successfully....

        # Update Group Information
        &{data}    Create Dictionary  Name=${group1_name}  Description=${update14_desc}  Id=${${group_id}}
        ${resp}     Put Request   platina   ${get_group}${group_id}    json=${data}     headers=${headers}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Node Group Updated with Existing name...


Clear exist node group name
        [Tags]    NodeG Mgmt    Groups
        [Documentation]    Clear Node Group Name

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
        Should Be Equal As Strings    ${resp.status_code}    200    msg=Group Name updated with Empty
