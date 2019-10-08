*** Keywords ***
Install MaaS Role
        [Arguments]    ${node_name}=${EMPTY}

        ${id}    Get MaaS Role Id
        ${node_id}    Get Node Id    ${node_name}
        # Assign MaaS role to node
        @{roles_group}    create list    ${id}
        &{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        Return From Keyword If    '${status}'==False    False

        [Return]    True


Verify MaaS Installed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=600

        ${id}    Get MaaS role Id
        ${iteration}    devide num    ${timeout}    60
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    60 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nStatus code = ${resp.status_code}    console=yes
        \    Log    \nResponse = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"==True
        Return From Keyword If    '${status}'==False    False
        ${status}    Verify mass installation from backend    ${node_name}
        Return From Keyword If    '${status}'==False    False
        [Return]    True


Remove MaaS Role
        [Arguments]    ${node_name}=${EMPTY}

        ${id}    Get MaaS role Id
        ${node_id}    Get Node Id    ${node_name}
#        # Delete LLDP Role
#        ${resp}  Delete Request    platina   ${add_role}${id}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200


Verify MaaS Role is Removed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=300

        ${id}    Get MaaS role Id
        ${iteration}    devide num    ${timeout}    30
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    30 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nStatus code = ${resp.status_code}    console=yes
        \    Log    \nResponse = ${resp.json()}    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"==False
        Return From Keyword If    '${status}'==False    True
        [Return]    False


Get MaaS Role Id
        # Get Id of MaaS role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get MaaS Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=MaaS Role Not Found in Roles
        [Return]    ${role_id}


Verify mass installation from backend
        [Arguments]    ${node}=${EMPTY}

        ${host_ip}    get node host ip    ${node}
        ${i_ip}    get ip   ${invader_ip}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               pcc        cals0ft
        Sleep    2s
        ${output}=         SSHLibrary.Execute Command    ps -aef | grep ROOT
        SSHLibrary.Close All Connections
        Log    \n\nINVADER DATA = ${output}    console=yes
        ${status}    run keyword and return status    Should Contain    ${output}    lighttpd.conf
        Return From Keyword If    '${status}'==False    False
        ${status}    run keyword and return status    Should Contain    ${output}    tinyproxy.conf
        Return From Keyword If    '${status}'==False    False
        ${status}    run keyword and return status    Should Contain    ${output}    dnsmasq
        Return From Keyword If    '${status}'==False    False
        [Return]    True