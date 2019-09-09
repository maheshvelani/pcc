*** Settings ***

Library             OperatingSystem
Library             Collections
Library             String

Library             ${CURDIR}/../lib/Request.py
Variables           ${CURDIR}/../test_data/Url_Paths.py
Library             ${CURDIR}/../lib/Data_Parser.py
Resource            ${CURDIR}/../resource/Resource_Keywords.robot


*** Test Cases ***

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

        # Create Tenant
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
