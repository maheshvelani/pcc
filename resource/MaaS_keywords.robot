*** Keywords ***
Install MaaS Role
        [Arguments]    ${node_name}=${EMPTY}

	Log    \nGetting MaaS Role Id...    console=yes
        ${id}    Get MaaS Id
	Log    \nGetting Node Id...    console=yes
        ${node_id}    Get Node Id    ${node_name}
	# Update role list
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        ${node_ip}    Get Node Host Ip    ${resp.json()}    ${node_name}
#        ${host_ip}    Get Ip    ${node_ip}
        &{data}    get existing roles detail    ${resp.json()}    ${node_name}    ${id}
        # Assign MaaS role to node
        # @{roles_group}    create list    ${id}
        #&{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}    Host=${host_ip}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Verify MaaS Installed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=900

	Log    \nGetting MaaS Role Id...    console=yes
        ${id}    Get MaaS Id
        ${iteration}    divide num    ${timeout}    60
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    60 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nVerifying MaaS is installed...    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"!="Continue"
        Return From Keyword If    "${status}"=="False"    False
        ${status}    Verify mass installation from backend    ${resp.json()}    ${node_name}
        [Return]    ${status}


Remove MaaS Role
        [Arguments]    ${node_name}=${EMPTY}

        ${id}    Get MaaS Id
        ${node_id}    Get Node Id    ${node_name}
#        # Delete LLDP Role
#        ${resp}  Delete Request    platina   ${add_role}${id}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200


Verify MaaS Role is Removed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=300

        ${id}    Get MaaS Id
        ${iteration}    divide num    ${timeout}    30
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    30 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nVerifying MaaS role is removed...    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"=="False"
        Return From Keyword If    "${status}"=="False"    True
        [Return]    False


Get MaaS Id
        # Get Id of MaaS role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get MaaS Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=MaaS Role Not Found in Roles
        [Return]    ${role_id}


Verify mass installation from backend
        [Arguments]    ${resp}=${EMPTY}    ${node}=${EMPTY}

        ${host_ip}    get node host ip    ${resp}    ${node}
        ${i_ip}    get ip   ${host_ip}
	SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}      ${invader_usr_pwd}
        Sleep    2s
        ${output}=         SSHLibrary.Execute Command    ps -aef | grep ROOT
        SSHLibrary.Close All Connections
        Log    \n\nINVADER DATA = ${output}    console=yes
        ${status}    run keyword and return status    Should Contain    ${output}    lighttpd.conf
        Run Keyword If    "${status}"=="False"    Log    \nLightHttpd Service is not running    console=yes
        Return From Keyword If    "${status}"=="False"    False
        ${status}    run keyword and return status    Should Contain    ${output}    tinyproxy.conf
        Run Keyword If    "${status}"=="False"    Log    \nTinyProxy Service is not running    console=yes
        Return From Keyword If    "${status}"=="False"    False
        ${status}    run keyword and return status    Should Contain    ${output}    dnsmasq
        Run Keyword If    "${status}"=="False"    Log    \ndnsmasq Service is not running    console=yes
        Return From Keyword If    "${status}"=="False"    False
        Log    \nAll MaaS services are running on back-end    console=yes
        [Return]    True
