*** Keywords ***
OS Deployment
        [Arguments]      ${node}=${EMPTY}     ${image}=${Empty}     ${locale}=${Empty}    ${time_zone}=${Empty}     ${admin_user}=${Empty}    ${ssh_key}=${Empty}

	# Get Node Id
	${id}    Get Node Id    ${node}
        # Start OS Deployment
	@{node_list}    Create List    ${${id}}
	@{ssh_key_list}     Create List    ${ssh_key}
        &{data}    Create Dictionary  nodes=@{node_list}  image=${image}  locale=${locale}  timezone=${time_zone}  adminUser=${admin_user}  sshKeys=@{ssh_key_list}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
        ${status}    Run Keyword And Return Status   Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}


Verify OS installed
        [Arguments]     ${node_name}=${EMPTY}       ${os_name}=${EMPTY}    ${timeout}=1200
         ${iteration}    divide num    ${timeout}    120
        :FOR    ${index}    IN RANGE    1    ${iteration}
	\   Sleep 	120 seconds
        \   &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        \   ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        \   Log    \nVerifying OS deployment status...   console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    Validate OS Provision Status    ${resp.json()}    ${node_name}
        \    Exit For Loop IF    "${status}"!="Continue"
	Return From Keyword If    "${status}"=="False"    False
        ${result}    Verify OS installed in server machine    ${node_name}    ${os_name}
        [Return]    ${result}


Verify OS installed with intervals
        [Arguments]    ${node_name}

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \nVerifying OS deployment status...   console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${node_name}
        ${result}=      Run Keyword And Return Status   Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished
        [Return]    ${result}


Verify OS installed in server machine
        [Arguments]    ${node_name}    ${os_name}

        # Get OS release data from server
        ${host_ip}    get node host ip    ${node_name}
        ${server_ip}    get ip   ${host_ip}
        SSHLibrary.Open Connection     ${server_ip}    timeout=1 hour
        SSHLibrary.Login               ${server_usr}        ${server_pwd}
        Sleep    2s
        ${output}=        SSHLibrary.Execute Command    cat /etc/os-release
        Log    \n\nSERVER RELEASE DATA = ${output}    console=yes
        ${status_1}    Should Contain    ${output}    ${os_name}
        ${output}    SSHLibrary.Execute Command    uptime -p
        Log    \n\nSERVER UP Time Data DATA = ${output} \n\n    console=yes
        ${status}    Verify server up time     ${output}
        ${status_2}    Should Be Equal As Strings    ${status}    True    msg=There are no new OS deployed in last few minutes
        SSHLibrary.Close All Connections
        Return from Keyword If    "${status_1}"=="True"  and  "${status_2}"=="True"    True
        [Return]    False
