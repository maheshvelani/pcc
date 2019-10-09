*** Settings ***
Library         ${CURDIR}/../lib/Data_Parser.py
Library         BuiltIn



*** Keywords ***
OS Deployment
        [Arguments]      ${node}=${EMPTY}     ${image}=${Empty}     ${locale}=${Empty}    ${time_zone}=${Empty}     ${admin_user}=${Empty}    ${ssh_key}=${Empty}

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${node}}]  image=${image}  locale=${locale}  timezone=${time_zone}  adminUser=${admin_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        ${status}=      Run Keyword And Return Status   Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}







Verify OS installed
        [Arguments]     ${node_name}=${EMPTY}       ${timeout}=20 minutes
        ${result}=	Wait Until Keyword Succeeds     20 minutes      2 minutes       Verify OS installed with intervals      ${node_name}
        ${result}=      Run Keyword If    '${result}' == 'True'     Verify OS installed in server machine
        [Return]    ${result}



Verify OS installed with intervals
        [Arguments]  ${node_name}
        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${node_name}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        ${result}=      Run Keyword And Return Status   Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished
        [Return]    ${result}


Verify OS installed in server machine


        # Get OS release data from server
        ${server_ip}    get ip   ${server1_node_host}
        SSHLibrary.Open Connection     ${server_ip}    timeout=1 hour
        SSHLibrary.Login               root        plat1na
        Sleep    2s
        ${output}=        SSHLibrary.Execute Command    cat /etc/os-release
        Log    \n\nSERVER RELEASE DATA = ${output}    console=yes
        Should Contain    ${output}    ${os_name}
        ${output}    SSHLibrary.Execute Command    uptime -p
        Log    \n\nSERVER UP Time Data DATA = ${output} \n\n    console=yes
        ${status}    Verify server up time     ${output}
        Should Be Equal As Strings    ${status}    True    msg=There are no new OS deployed in last few minutes
        SSHLibrary.Close All Connections
