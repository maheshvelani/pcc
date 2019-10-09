*** Keywords ***

Install K8s Cluster
        [Arguments]    ${name}=${EMPTY}    ${version}=${EMPTY}    ${cni_plugin}=${EMPTY}    ${node_list}=${EMPTY}

        &{data}    Create Dictionary    name=${name}    k8sVersion=${versiion}    cniPlugin=${cni_plugin}
        ...    nodes=@{node_list}
        Log    \nCreating Cluster with data: ${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        [Return]    True


Verify K8s installed  # cluster createt verification
        [Arguments]    ${cluster_name}=${EMPTY}    ${timeout}=${EMPTY}

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
        [Return]    True


Add an Application to K8s
        [Arguments]    ${cluster_id}=${EMPTY}    ${label}=${EMPTY}    ${app_name}=${EMPTY}    ${name_space}=${EMPTY}    ${git_url}=${EMPTY} ${git_repo_path}=${EMPTY}  ${git_branch}=${EMPTY}

        &{data}    Create Dictionary  label=${label}  appName=${app_name}  appNamespace=${name_space}  gitUrl=${git_url}
        ...  gitRepoPath=${git_repo_path}  gitBranch=${git_branch}
        Log    \nAdding App with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/app    json=[${data}]    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status    Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        [Return]    True

Verify App installed over K8s Cluster
        [Arguments]    ${cluster_id}=${EMPTY}    ${app_name}=${EMPTY}    ${timeout}=${EMPTY}

        ${iteration}    device num    ${timeout}    120
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   sleep 120
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings  ${resp.status_code}  200
        \   ${status}    Verify App Present in Cluster    ${resp.json()}    ${app_name}
        \   Exit For Loop If    '${status}'==True

         Return From Keyword If    '${status}'==False    False
         [Return]    True


Upgrade K8s Cluster
        [Arguments]    ${cluster_id}=${EMPTY}    ${version}=${EMPTY}    ${timeout}=${EMPTY}

        &{data}    Create Dictionary  k8sVersion=${version}
        Log    \nUpgrading k8s with Data: ${data}\n  console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}${cluster_id}/upgrade  json=${data}  headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n RESP = ${resp.json()}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        [Return]    True


Verify k8s Upgraded
        [Arguments]    ${cluster_id}=${EMPTY}    ${version}=${EMPTY}    ${timeout}=${EMPTY}

        ${iteration}    device num    ${timeout}    180
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}/${${cluster_id}}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   Should Be Equal As Strings    ${resp.status_code}    200
        \  ${status}    Verify Cluster Version    ${resp.json()}    ${version}
        \   Exit For Loop If    '${status}'==True

        Return From Keyword If    '${status}'==False    False
        [Return]    True


Delete K8s Cluster
        [Arguments]    ${cluster_id}=${EMPTY}

        ${resp}    Delete Request    platina    ${add_kubernetes_cluster}/${cluster_id}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        [Return]    True


Verify K8s Cluster Deleted
        [Arguments]    ${cluster_id}=${EMPTY}    ${cluster_name}=${EMPTY}    ${timeout}=${EMPTY}

        ${iteration}    device num    ${timeout}    180
        :FOR    ${index}    IN RANGE    1    ${iteration}
        \   ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        \   Log    \n Status code = ${resp.status_code}    console=yes
        \   Log    \n Response = ${resp.json()}    console=yes
        \   ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
        \   Exit For Loop If    '${status}'==True

        ${status}    run keyword and return status     Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        [Return]    True











