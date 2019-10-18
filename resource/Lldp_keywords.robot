*** Keywords ***
Install LLDP Role
        [Arguments]    ${node_name}=${EMPTY}
        
	Log    \nGetting LLDP role ID...    console=yes
        ${id}    Get LLDP Id
	Log    \nGetting Node ID...    console=yes
        ${node_id}    Get Node Id    ${node_name}
	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
	${node_ip}    Get Node Host Ip    ${resp.json()}    ${node_name}
	${host_ip}    Get Ip    ${node_ip}
	@{roles_group}    get existing roles detail    ${resp.json()}    ${node_name}    ${id}
        # Assign LLDP role to node
        @{roles_group}    create list    ${id}
        &{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}    Host=${host_ip}
	Log    \nInstalling LLDP with parameters : ${data}    console=yes
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Install LLDP On Multiple Nodes
        [Arguments]     @{node_list}

        :FOR    ${node}    IN    @{node_list}
        \   Log     \nInstalling LLDP on ${node}
        \   ${status}    Install LLDP Role    node_name=${node}
        \   Exit For Loop IF    "${status}"=="False"
        [Return]    ${status}

Verify LLDP Installed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=900
	
	Log    \nGetting LLDP role ID...    console=yes
        ${id}    Get LLDP Id
        ${iteration}    divide num    ${timeout}    50
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    50 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nVerifying LLDP is installed...    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"!="Continue"
        Return From Keyword If    '${status}'=="False"    True
        Log    \nLLDP Installed successfully    console=yes
        Log    \nVerifying LLDP Events   console=yes
        ${event_status}    Verify LLDP Events    node_name=${node_name}
        [Return]    ${event_status}


Remove LLDP Role
        [Arguments]    ${node_name}=${EMPTY}

        ${id}    Get LLDP Id
        ${node_id}    Get Node Id    ${node_name}
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
	    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
	    @{roles_group}    get existing roles detail    ${resp.json()}    ${node_name}    ${id}
        Remove Values From List    @{roles_group}    ${id}
        &{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}
	    Log    \nUninstalling LLDP with parameters : ${data}    console=yes
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Remove LLDP From Multiple Node
        [Arguments]     @{node_list}

        :FOR    ${node}    IN    @{node_list}
        /   Log     \nRemoving LLDP on ${node}
        /   ${status}    Remove LLDP Role    node_name=${node}
        /   Exit For Loop IF    "${status}"=="False"
        [Return]    ${status}


Verify LLDP Role is Removed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=300

        ${id}    Get LLDP Id
        ${iteration}    divide num    ${timeout}    30
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    30 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nVerifying LLDP removed...    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"=="False"
        Return From Keyword If    '${status}'=="False"    True
        [Return]    False


Get LLDP Id
        # Get LLDP Role ID
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get LLDP Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=LLDP Role Not Found in Roles
        [Return]    ${role_id}

Verify LLDP Events
        [Arguments]    ${node_name}=${EMPTY}

        ${resp}  Get Request    platina   ${events}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    Validate Lldp Events    ${resp.json()}    ${node_name}
        Should Be Equal As Strings    ${status}    True    msg=LLDP Role Found in Events
        [Return]    ${status}
