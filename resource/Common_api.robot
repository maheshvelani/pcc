*** Settings ***
Resource    Login_keywords.robot
Resource    Invader_keywords.robot
Resource    Server_keywords.robot
Resource    K8s_keywords.robot
Resource    Lldp_keywords.robot
Resource    MaaS_keywords.robot
Resource    PXE_boot_keywords.robot
Resource    Os_deployment_keywords.robot
Library    Collections

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



