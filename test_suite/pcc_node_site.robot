*** Settings ***

Library  	    OperatingSystem
Library  	    Collections
Library  	    String

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions


*** Test Cases ***
Verify the information on Sites
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    verify User Should Be able to access Sites

        # Click on node Site
    	${resp}  Get Request    platina   ${get_site}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}    200
    	Sleep    2s


PCC Add Site
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Adding new Site

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Adding new Site without description

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Adding new Site without name

        &{data}    Create Dictionary  Description=${site3_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully without name
    	Sleep    5s


PCC Add Site With Special Character Only
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only special characters

    	&{data}    Create Dictionary  Name=${site4_name}    Description=${site4_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Special character only
    	Sleep    5s


PCC Add Site With Numeric Value Only
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value

    	&{data}    Create Dictionary  Name=${site5_name}    Description=${site5_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with numeric value only
    	Sleep    5s


PCC Add Site With Blank Space Only
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value

    	&{data}    Create Dictionary  Name=${site6_name}    Description=${site6_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with blank space only
    	Sleep    5s


PCC Add Site with name contain mixture of special character, numerical value, alphabet
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Add Site in the PCC- name contain mixture of special character, numerical value, alphabet

    	&{data}    Create Dictionary  Name=${site7_name}    Description=${site7_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Mixture of special, alphabet and numeric character
    	Sleep    5s


PCC Edit Site Name
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Updating Sites

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Updating Sites

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Creating Duplicate Site

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Deleting Single Site

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Deleting Multiple Site

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Create Multiple Node Site

        : FOR    ${index}    IN RANGE    1    11
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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Delete Multiple Sites

        FOR    ${index}    IN RANGE    1    11
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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Clear Existing Site

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Clear Existing Site description

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
        [Tags]    NodeG Mgmt    Sites
        [Documentation]    Clear Existing Site description

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




