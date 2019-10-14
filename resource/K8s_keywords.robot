*** Keywords ***

Install K8s Cluster
        [Arguments]    ${name}=${EMPTY}    ${version}=${EMPTY}    ${cni_plugin}=${EMPTY}    ${node_list}=${EMPTY}

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

        ${iteration}    devide num    ${timeout}    180
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \    sleep    180 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Should Be Equal As Strings  ${resp.status_code}  200
        \   ${status}    ${id}    Validate Cluster    ${resp.json()}    ${cluster_name}
        \   Exit For Loop If    '${status}'==True
        Return From Keyword If    '${status}'==False    False
        ${status}    Validate Cluster Deploy Status    ${resp.json()}
        Return From Keyword If    '${status}'==False    False
        ${status}    Validate Cluster Health Status    ${resp.json()}
        Return From Keyword If    '${status}'==False    False
        ${status}    Verify K8s Installed from backend    ${node_name}
        Return From Keyword If    '${status}'==False    False
        [Return]    True


Add an Application to K8s
        [Arguments]    ${cluster_name}=${EMPTY}    ${label}=${EMPTY}    ${app_name}=${EMPTY}    ${name_space}=${EMPTY}    ${git_url}=${EMPTY} ${git_repo_path}=${EMPTY}  ${git_branch}=${EMPTY}

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
        ${iteration}    device num    ${timeout}    60
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   sleep  60 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings  ${resp.status_code}  200
        \   ${status}    Verify App Present in Cluster    ${resp.json()}    ${app_name}
        \   Exit For Loop If    '${status}'==True
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
        ${iteration}    device num    ${timeout}    250
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   Sleep    250 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \   ${status}    Verify Cluster Version    ${resp.json()}    ${version}
        \   Exit For Loop If    '${status}'==True
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

        ${iteration}    device num    ${timeout}    150
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   Sleep    150 seconds
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
        \   Exit For Loop If    '${status}'==True
        [Return]    ${status}


Verify K8s Installed from backend
        [Arguments]    ${node_name}=${EMPTY}

        ${node_id}    Get Node Id    ${node_name}
        ${i_ip}    Get Ip    ${node_id}
        SSHLibrary.Open Connection     ${i_ip}    timeout=1 hour
        SSHLibrary.Login               ${invader_usr}  ${invader_pwd}
        Sleep    2s
        ${output}    SSHLibrary.Execute Command    sudo kubectl get nodes
        SSHLibrary.Close All Connections
        Log    \n\nK8S - DATA = ${output} \n\n    console=yes
        ${status_1}    Should Contain  ${output}    Ready
        ${status_2}    Should Contain  ${output}    master
        Return from Keyword If    "${status_1}"==True  and  "${status_2}"==True    True
        [Return]    False


Get Cluster Id
        [Arguments]    ${name}=${EMPTY}

        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200
        ${status}    ${id}    Validate Cluster    ${resp.json()}    ${name}
        Return from Keyword If    "${status}"==True  ${id}
        [Return]    None
