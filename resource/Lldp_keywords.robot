*** Keywords ***
Install LLDP Role
        [Arguments]    ${node_name}=${EMPTY}
        
	Log    \nGetting LLDP role ID...    console=yes
        ${id}    Get LLDP Id
	Log    \nGetting Node ID...    console=yes
        ${node_id}    Get Node Id    ${node_name}
        # Assign LLDP role to node
        @{roles_group}    create list    ${id}
        &{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}
	Log    \nInstalling LLDP with parameters : ${data}    console=yes
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings    ${resp.status_code}    200
        [Return]    ${status}


Verify LLDP Installed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=500
	
	Log    \nGetting LLDP role ID...    console=yes
        ${id}    Get LLDP Id
        ${iteration}    devide num    ${timeout}    50
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    Sleep    50 seconds
        \    &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \    ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \    Log    \nVerifying LLDP is installed...    console=yes
        \    Should Be Equal As Strings    ${resp.status_code}    200
        \    ${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${id}
        \    Exit For Loop IF    "${status}"=="True"
        [Return]    ${status}


Remove LLDP Role
        [Arguments]    ${node_name}=${EMPTY}

        ${id}    Get LLDP Id
        ${node_id}    Get Node Id    ${node_name}

#        # Delete LLDP Role
#        ${resp}  Delete Request    platina   ${add_role}${id}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#


Verify LLDP Role is Removed
        [Arguments]    ${node_name}=${EMPTY}    ${timeout}=300

        ${id}    Get LLDP Id
        ${iteration}    devide num    ${timeout}    30
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
