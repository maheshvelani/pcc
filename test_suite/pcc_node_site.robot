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
        [Tags]    Sites
        [Documentation]    verify User Should Be able to access Sites

    	# Click on node group
    	${resp}  Get Request    platina   ${get_site}    headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}    200
    	Sleep    2s


PCC Add Site
        [Tags]    Sites
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
        [Tags]    Sites
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
        Log    \n Group ${site2_name} ID = ${create_site2_id}   console=yes
        Sleep    2s


PCC Add Site Without Name
        [Tags]    Sites
        [Documentation]    Adding new Site without name

    	&{data}    Create Dictionary  Name=    Description=${site3_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully without name
    	Sleep    5s


PCC Add Site With Special Character Only
        [Tags]    Sites
        [Documentation]    Add Site in the PCC - name contain only special characters

    	&{data}    Create Dictionary  Name=${site4_name}    Description=${site4_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Special character only
    	Sleep    5s


PCC Add Site With Numeric Value Only
        [Tags]    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value

    	&{data}    Create Dictionary  Name=${site5_name}    Description=${site5_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with numeric value only
    	Sleep    5s


PCC Add Site With Blank Space Only
        [Tags]    Sites
        [Documentation]    Add Site in the PCC - name contain only numeric value

    	&{data}    Create Dictionary  Name=${site6_name}    Description=${site6_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with blank space only
    	Sleep    5s


PCC Add Site with name contain mixture of special character, numerical value, alphabet
        [Tags]    Sites
        [Documentation]    Add Site in the PCC- name contain mixture of special character, numerical value, alphabet

    	&{data}    Create Dictionary  Name=${site7_name}    Description=${site7_desc}
    	Log    \nCreating Site with parameters: \n${data}\n    console=yes
    	${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
    	Log    \n Status code = ${resp.status_code}    console=yes
    	Log    \n Response = ${resp.json()}    console=yes
    	Should Not Be Equal As Strings    ${resp.status_code}    200    msg=Site Created successfully with Mixture of special, alphabet and numeric character
    	Sleep    5s


PCC Edit Site Name
        [Tags]    Sites
        [Documentation]    Updating Sites

        &{data}    Create Dictionary  Name=${site8_name}    Description=${site8_desc}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        sleep      5s

        # Validate Added Node Roles
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site8_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site8_name} is not present in site list

        &{data}    Create Dictionary  Name=${site8_name_update}
        ${resp}     Put Request   platina   ${add_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Sleep    10s

        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site8_name_update}
        Should Be Equal As Strings    ${status}    True    msg=Site Name Not Updated......


PCC Edit Site Name
        [Tags]    Sites
        [Documentation]    Updating Sites

        &{data}    Create Dictionary  Name=${site9_name}    Description=${site9_desc}
        Log    \nCreating Role with parameters: \n${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_site}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Wait for few seconds to verify role reflect over UI
        sleep      5s

        # Validate Added Node Roles
        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site9_name}
        Should Be Equal As Strings    ${status}    True    msg=Site ${site9_name} is not present in site list

        &{data}    Create Dictionary  Description=${site9_desc_update}
        ${resp}     Put Request   platina   ${add_site}${site_id}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Sleep    10s

        ${resp}  Get Request    platina    ${get_site}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site9_name_update}
        Should Be Equal As Strings    ${status}    True    msg=Site Desc Not Updated......





