*** Keywords ***
PXE Boot the server
        [Arguments]     ${bmc_ip}=${Empty}

        ${status}    Server PXE boot    ${bmc_ip}
        ${status}=      Run Keyword And Return Status   Should Be Equal As Strings    ${status}    True    msg=PXE boot Failed Over Server ${bmc_ip}
        [Return]    ${status}


Verify Booted server reflected over PCC UI
        [Arguments]     ${bmc_ip}=${Empty}

        ${result}=	Wait Until Keyword Succeeds     10 minutes      1 minutes       Verify Booted server reflected over PCC UI with intervals      ${bmc_ip}
        [Return]    ${result}


Verify Booted server reflected over PCC UI with intervals
        [Arguments]     ${bmc_ip}

        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${node_id}    Get Server Id    ${resp.json()}    ${bmc_ip}
        ${result}=      Should Be Equal As Strings    ${status}    True    msg=Booted Server ${bmc_ip} is not present in node list
        [Return]    ${result}


Assign Management IP to PXE booted Server
        [Arguments]     ${name}=${pxe_booted_server}

        ${server_id}    Get Node Id    ${name}
        # Get server Interface from topology
        Log    \nGetting Topology Data...    console=yes
        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes

        ${i_interface}  Get_booted_server_interface  ${resp.json()}  ${server_id}
        Log    \n\nBooted server Interface = ${i_interface}  console=yes

        # Get Booted server details
        ${resp}  Get Request    platina   ${get_node_list}/${server_id}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes

        # Get valid server interface to set management IP
        ${mngmt_interface}    get management ip interface    ${resp.json()}  ${i_interface}
        Log    \nFound Suitable interface to assign management Ip = ${mngmt_interface}  console=yes

        # Set Management Ip
        @{mgt_ip}    Create List    ${server2_node_host}
        &{data}    Create Dictionary  nodeID=${${server_id}}    ipv4Addresses=@{mgt_ip}  ifName=${mngmt_interface}  gateway=172.17.2.1  management=${true}
        Log    \nAssigning management ip with params = ${data}    console=yes
        ${resp}  Post Request    platina    ${add_interface}    json=${data}     headers=${headers}
        Log    \n MGT IP Assign status Code = ${resp.status_code}    console=yes
        ${status}=      Run Keyword And Return Status   Should Be Equal As Strings  ${resp.status_code}    200
        [Return]    ${status}


Update Booted Server Information
        [Arguments]     ${id}=${Empty}      ${name}=${Empty}    ${host}=${Empty}    ${console}=${Empty}     ${bmc}=${Empty}     ${bmc_user}=${Empty}    ${bmc_password}=${Empty}    ${bmc_users}=${Empty}
        ...                ${ssh_key}=${Empty}     ${managed_by_pcc}=${Empty}

        # Update Server Node with proper information
        @{server2_bmc_users}    Create List    ${bmc_user}
        @{server2_ssh_keys}    Create List    ${ssh_key}

        &{data}    Create Dictionary    Id=${id}  Name=${name}  console=${console}
        ...    managed=${${managed_by_pcc}}  bmc=${bmc}/23  bmcUser=${bmc_user}
        ...    bmcPassword=${bmc_password}  bmcUsers=@{bmc_users}
        ...    sshKeys=@{ssh_key}  Host=${host}
        Log    \n Updating Server with Data : \n${data}\n    console=yes
        ${resp}  Put Request    platina    ${update_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        og    \n Response = ${resp.json()}    console=yes
        ${status}    Should Be Equal As Strings  ${resp.status_code}    200
        [Return]    ${status}