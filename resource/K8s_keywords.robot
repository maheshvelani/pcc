*** Keywords ***

Install K8s Cluster
        [Arguments]    ${name}=${EMPTY}    ${version}=${EMPTY}    ${cni_plugin}=${EMPTY}     ${node1_name}=${EMPTY}  ${node2_name}=${EMPTY}  ${node3_name}=${EMPTY}

        ${node1_id}    Get Node Id    ${node1_name}
        ${node2_id}    Get Node Id    ${node2_name}
        ${node3_id}    Get Node Id    ${node3_name}
        &{data1}    Create Dictionary    Id=${${node1_id}}
        &{data2}    Create Dictionary    Id=${${node2_id}}
        &{data3}    Create Dictionary    Id=${${node3_id}}
        @{node_list}    Create List  ${data1}  ${data2}  ${data3}
	&{data}    Create Dictionary    name=${name}    k8sVersion=${version}    cniPlugin=${cni_plugin}
        ...    nodes=@{node_list}
        Log    \nCreating Cluster with data: ${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}


Verify K8s installed
        [Arguments]    ${cluster_name}=${EMPTY}    ${node_name}=${EMPTY}    ${timeout}=1800

	${iteration}    divide num    ${timeout}    180
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    sleep    180 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Should Be Equal As Strings  ${resp.status_code}  200
        \   ${status}    ${id}    Validate Cluster    ${resp.json()}    ${cluster_name}
        \   Exit For Loop If    "${status}"=="True"
        Return From Keyword If    "${status}"=="False"    False
        : FOR     ${index}    IN RANGE    1    ${iteration}
        \    sleep    180 seconds
        \    ${status}    Validate Cluster Deploy Status    ${resp.json()}
	\    Log    \nVerifying Cluster Deploy Status    console=yes
        \    Exit For Loop If    "${status}"!="Continue"   
        Return From Keyword If    "${status}"=="False"    False
        ${status}    Validate Cluster Health Status    ${resp.json()}
        Return From Keyword If    "${status}"=="False"    False
        ${status}    Verify K8s Installed from backend    ${node_name}
        Return From Keyword If    "${status}"=="False"    False
        [Return]    True

Add an Application to K8s
        [Arguments]    ${cluster_name}=${EMPTY}    ${label}=${EMPTY}    ${app_name}=${EMPTY}    ${name_space}=${EMPTY}    ${git_url}=${EMPTY}    ${git_repo_path}=${EMPTY}    ${git_branch}=${EMPTY}

        # Get Cluster Id
        ${cluster_id}    Get Cluster Id    ${cluster_name}

        &{data}    Create Dictionary  label=${label}  appName=${app_name}  appNamespace=${name_space}  gitUrl=${git_url}
        ...  gitRepoPath=${git_repo_path}  gitBranch=${git_branch}
        Log    \nAdding App with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}


Verify App installed over K8s Cluster
        [Arguments]    ${cluster_name}=${EMPTY}    ${app_name}=${EMPTY}    ${timeout}=240

        # Get Cluster Id
        ${cluster_id}    Get Cluster Id    ${cluster_name}
        ${iteration}    divide num    ${timeout}    60
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   sleep  60 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings  ${resp.status_code}  200
        \   ${status}    Verify App Present in Cluster    ${resp.json()}    ${app_name}
        \   Exit For Loop If    "${status}"!="Continue"
        [Return]    ${status}


Upgrade K8s Cluster
        [Arguments]    ${cluster_name}=${EMPTY}    ${version}=${EMPTY}    ${timeout}=${EMPTY}

        # Get Cluster Id
        ${cluster_id}    Get Cluster Id    ${cluster_name}
        &{data}    Create Dictionary  k8sVersion=${version}
        Log    \nUpgrading k8s with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/upgrade  json=${data}  headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}


Verify k8s Upgraded
        [Arguments]    ${cluster_name}=${EMPTY}    ${version}=${EMPTY}    ${timeout}=2500

        # Get Cluster Id
        ${cluster_id}    Get Cluster Id    ${cluster_name}
        ${iteration}    divide num    ${timeout}    250
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   Sleep    250 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    Verify Cluster Version    ${resp.json()}    ${version}
        \   Exit For Loop If    "${status}"=="True"
        [Return]    ${status}


Delete K8s Cluster
        [Arguments]    ${cluster_name}=${EMPTY}

        # Get Cluster Id
        ${cluster_id}    Get Cluster Id    ${cluster_name}
        ${resp}    Delete Request    platina    ${add_kubernetes_cluster}/${cluster_id}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        [Return]    ${status}


Verify K8s Cluster Deleted
        [Arguments]    ${cluster_name}=${EMPTY}    ${timeout}=900

        ${iteration}    divide num    ${timeout}    150
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   Sleep    150 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
        \   Exit For Loop If    "${status}"=="True"
        [Return]    ${status}


Verify K8s Installed from backend
        [Arguments]    ${node_name}=${EMPTY}
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        ${host_ip}    get node host ip   ${resp.json()}    ${node_name}
        ${i_ip}    get ip   ${host_ip}

	SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr_name}    ${invader_usr_pwd}
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo kubectl get nodes
        SSHLibrary.Close All Connections
        Log    \n\nK8S - DATA = ${output} \n\n    console=yes
        ${status_1}    Should Contain  ${output}    Ready
        ${status_2}    Should Contain  ${output}    master
        Return from Keyword If    "${status_1}"==True  and  "${status_2}"==True    True
        [Return]    False


Assign Interface Ip to node to form Topology
        [Arguments]    ${node1}=${EMPTY}    ${node2}=${EMPTY}    ${node3}=${EMPTY}

        Log    \nGetting Topology Data...    console=yes
        ${resp}    Get request    platina    ${get_topology}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Topology Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        ${interface_sv1}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server1_node_name}
        ${interface_sv2}    Get Interface Name    ${resp.json()}  ${invader1_node_name}  ${server2_node_name}
        ${interface1_name}  Get Interface Name    ${resp.json()}  ${server1_node_name}  ${invader1_node_name}
        ${interface2_name}  Get Interface Name    ${resp.json()}  ${server2_node_name}  ${invader1_node_name}

        Log  \n\nInterface Between ${invader1_node_name} and ${server1_node_name} = ${interface_sv1}  console=yes
        Log  \n\nInterface Between ${invader1_node_name} and ${server2_node_name} = ${interface_sv2}  console=yes
        Log  \n\nInterface Between ${server1_node_name} and ${invader1_node_name} = ${interface1_name}  console=yes
        Log  \n\nInterface Between ${server2_node_name} and ${invader1_node_name} = ${interface2_name}  console=yes

        # Get Invader Topology
        ${status}    ${sv1_topology}    Prepare Invader Topology  ${resp.json()}  ${invader1_id}  ${interface_sv1}  192.0.2.102/31
        ${status}    ${sv2_topology}    Prepare Invader Topology  ${resp.json()}  ${invader1_id}  ${interface_sv2}  192.0.2.100/31
        ${status}    ${i1_topology}    Prepare Invader Topology  ${resp.json()}  ${server1_id}  ${interface1_name}  192.0.2.103/31
        ${status}    ${i2_topology}    Prepare Invader Topology  ${resp.json()}  ${server2_id}  ${interface2_name}  192.0.2.101/31


        # Update Invader interfaces
        Log    \n Updating invader topology with data = ${sv1_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${sv1_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating invader topology with data = ${sv2_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${sv2_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating Server topology with data = ${i1_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${i1_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        Sleep    5s

        Log    \n Updating Server topology with data = ${i2_topology} \n    console=yes
#        ${resp}  Post Request    platina   ${add_interface}    json=${i2_topology}    headers=${headers}
#        Log    \n Status Code = ${resp.status_code}    console=yes
#        Log    \n JSON RESP = ${resp.json()}    console=yes
        #Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for few minutes to reflect assign IP into topology
        #Sleep  5 minutes


Get Cluster Id
        [Arguments]    ${name}=${EMPTY}

        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Status code = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200
        ${status}    ${id}    Validate Cluster    ${resp.json()}    ${name}
        Return from Keyword If    "${status}"=="True"  ${id}
        [Return]    None
