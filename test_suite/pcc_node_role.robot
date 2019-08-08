*** Settings ***
Library         OperatingSystem
Library         Collections
Library         String

Library         ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions

*** Test Cases ***

Verify the UI Node Role Information
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Verify the UI information on node role

        # Click on node role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Log    \nResponse = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        Sleep    2s


PCC Node Role Creation
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding new node role

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding new node role without name

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding new node role without description

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding new node role without Application

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding new node role without Tenant

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
        [Tags]    NodeR Mgmt  Roles
        [Documentation]    Adding new node role with empty fields

        &{data}    Create Dictionary  Name=    Description=     owners=  templateIDs=
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200
        Sleep    2s


PCC Edit Node Role
        [Tags]    NodeG Mgmt    Roles
        [Documentation]    Updating node roles

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
        [Tags]    NodeG Mgmt    Roles
        [Documentation]    Create Node Role with More Than one App

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Deleting a node role

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Create a Duplicate Node

        @{app}    Create List    ${3}
        &{data}    Create Dictionary  Name=${role1_name}  Description=${role1_desc}  owners=@{owner}  templateIDs=@{app}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Not Be Equal As Strings    ${resp.status_code}    200


Clear Exist Node Role Description
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Create Role Description

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
        [Tags]    NodeR Mgmt    Roles
        [Documentation]    Adding node role with space in name

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
        [Tags]    NodeG Mgmt  Roles  test
        [Documentation]    Changing tenant of node role

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


*** variables ***
@{owner}    ${1}
