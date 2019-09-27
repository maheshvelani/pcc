*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String
Library         SSHLibrary

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Library         ${CURDIR}/../lib/Entry_Criteria_Api.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Test Setup      Verify User Login
Test Teardown   Delete All Sessions


*** Test Cases ***
Install K8s Multiple time
        [Tags]    K8S test
        [Documentation]    Install and Delete k8s multiple time and check behaviour

        :FOR    ${id}    IN RANGE    0    ${run_cnt}
        \    Run Keyword And Continue On Failure	Install k8s
        \    Run Keyword And Continue On Failure	Verify Created K8s Cluster installation from back end
        \    Run Keyword And Continue On Failure        Delete k8s


*** keywords ***
Install k8s
        [Tags]    Entry Criteria
        [Documentation]    Create Kubernetes Cluster

        # Create Kubernetes cluster
        &{data1}    Create Dictionary  id=${${node1_id}}
        &{data2}    Create Dictionary  id=${${node2_id}}
        &{data3}    Create Dictionary  id=${${node3_id}}
        @{json}    Create List    ${data1}  ${data2}  ${data3}
        &{data}    Create Dictionary  name=${cluster_name}  k8sVersion=${cluster_version}  cniPlugin=${cni_plugin}
        ...    nodes=@{json}
        Log    \nCreating Cluster with data: ${data}\n    console=yes
        ${resp}  Post Request    platina   ${add_kubernetes_cluster}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n JSON RESP = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for few seconds
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  5 minutes
        Log To Console    \nK8s is installing.....
        Sleep  3 minutes

        # Verify cluster created
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    ${id}    Validate Cluster    ${resp.json()}    ${cluster_name}
        Should Be Equal As Strings    ${status}    True    msg=Created Cluster ${cluster_name} is not present in Cluster list
        Set Suite Variable    ${cluster_id}    ${id}
        ${status}    Validate Cluster Deploy Status    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=Cluster installation failed


Delete k8s
        # Delete K8s Cluster
        Log    \n\nDeleting Cluster...    console=yes
        ${resp}  Delete Request	   platina    ${add_kubernetes_cluster}/${cluster_id}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for few seconds
        Sleep    5 minutes

        # Verify Cluster Deleted
        ${resp}  Get Request    platina   ${add_kubernetes_cluster}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify Cluster Deleted    ${resp.json()}    ${cluster_name}
        Should Be Equal As Strings    ${status}    True    msg=Cluster ${cluster_name} not deleted


Verify Created K8s Cluster installation from back end
        Log To Console    \n\nVerifying K8S over ${invader1_node_host}\n\n
        ${invader_ip}    get ip   ${invader1_node_host}
        ${rc}  ${output}    Entry_Criteria_Api.Run And Return Rc And Output        ssh ${invader_ip} "sudo kubectl get nodes"
        Sleep    2s
        Log    \n\nInvader K8S Status = ${output}    console=yes
        Should Contain  ${output}    Ready
        Should Contain  ${output}    master
