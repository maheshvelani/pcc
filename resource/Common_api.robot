*** Settings ***
Resource    Login_keywords.robot
Resource    Invader_keywords.robot
Resource    Server_keywords.robot
Resource    K8s_keywords.robot
Resource    Lldp_keywords.robot
Resource    MaaS_keywords.robot
Resource    PXE_boot_keywords.robot
Resource    Os_deployment_keywords.robot
Library     Collections


*** Keywords ***
Get Node Id
        [Arguments]    ${name}=${EMPTY}

        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \nStatus code = ${resp.status_code}    console=yes
        Log    \nResponse = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${name}
        [Return]    ${node_id}

Reboot Node
        [Arguments]    ${node_name}=${EMPTY}
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        ${host_ip}    get node host ip   ${resp.json()}    ${node_name}
        ${ip_addr}    get ip   ${host_ip}
        Log    /nRestarting the invader ${ip_addr}    console=yes
        Execute Commands  ${ip_addr}  ${reboot_command}
        sleep    120 seconds
        [Return]    True

Shutdown Node
        [Arguments]    ${node_name}=${EMPTY}
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        ${host_ip}    get node host ip   ${resp.json()}    ${node_name}
        ${ip_addr}    get ip   ${host_ip}
        Log    /nRestarting the invader ${ip_addr}    console=yes
        Execute Commands  ${ip_addr}  ${shutdown_command}
        sleep    120 seconds
        [Return]    True

Reboot Node Multiple Times
        [Arguments]    ${node_name}=${EMPTY}  ${iteration}=${EMPTY}

        Log    /nRestarting the invader ${ip_addr} for ${${iteration}} times  console=yes
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Reboot Node  ${node_name}
        \    Log    /n${iteration} rebooting invader ${node_name}
        [Return]    True

