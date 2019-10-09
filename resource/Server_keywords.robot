*** Keywords ***
Add Server
        [Arguments]  ${name}=${EMPTY}  ${host}=${EMPTY}  ${console}=${EMPTY}  ${bmc}=${EMPTY}  ${bmc_user}=${EMPTY}  ${bmc_password}=${EMPTY}  ${bmc_users}=${EMPTY}    ${ssh_key}=${EMPTY}  ${managed_by_pcc}=${EMPTY}

        @{server_bmc_users}    Create List    ${bmc_user}
        @{server_ssh_keys}    Create List    ${ssh_key}
        &{data}    Create Dictionary  	Name=${name}  Host=${host}
        ...    console=${console}  bmc=${bmc}  bmcUser=${bmc_user}
        ...    bmcPassword=${bmc_pwd}  bmcUsers=@{server_bmc_users}
        ...    sshKeys=@{server_ssh_keys}  managed=${${managed_by_pcc}}
        Log    \nAdding server : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Verify Server is present in Node List
        [Arguments]    ${name}=${EMPTY}    ${timeout}=120

        ${iteration}    devide num    ${timeout}    10
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    10 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nStatus code = ${resp.status_code}    console=yes
        \    Log    \nResponse = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node    ${resp.json()}    ${name}
        \    Exit For Loop IF    "${status}"==True
        [Return]    ${status}


Verify Server is Online
        [Arguments]    ${name}=${EMPTY}    ${timeout}=180

        ${iteration}    devide num    ${timeout}    20
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    20 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nStatus code = ${resp.status_code}    console=yes
        \    Log    \nResponse = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${sv_id}    Validate Node Online Status    ${resp.json()}    ${name}
        \    Exit For Loop IF    "${status}"==True
        Return From Keyword If    '${status}'==True    ${sv_id}
        [Return]    None


Delete Server
        [Arguments]    ${name}=${EMPTY}

        ${id}    Get Node Id    ${name}
        @{data}    Create List    ${id}
        Log    \nDeleting Server = ${name}    console=yes
        ${resp}    Post Request    platina    ${delete_node}    headers=${headers}    json=${data}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Log    \nResponse = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Verify Server is Deleted
        [Arguments]    ${name}=${EMPTY}    ${timeout}=180

        ${iteration}    devide num    ${timeout}    20
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    20 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nStatus code = ${resp.status_code}    console=yes
        \    Log    \nResponse = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${sv_id}    Validate Node    ${resp.json()}    ${name}
        \    Exit For Loop IF    "${status}"==False
        Return From Keyword If    '${status}'==False    True
        [Return]    False