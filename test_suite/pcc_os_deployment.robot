*** Settings ***
Library  	    OperatingSystem
Library  	    Collections
Library  	    String
Library         SSHLibrary

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot
Library         ${CURDIR}/../lib/Entry_Criteria_Api.py

Test Setup      Verify User Login
Test Teardown   Delete All Sessions


*** Test Cases ***
Deploy CentOS 7.6.1810(AMD64) in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy CentOS 7.6.1810(AMD64) in a node

        # Add Server-1 as a Node and Verify Online Status
        @{server1_bmc_users}    Create List    ${server1_bmc_user}
        @{server1_ssh_keys}    Create List    ${server1_ssh_keys}
        &{data}    Create Dictionary  	Name=${server1_node_name}  Host=${server1_node_host}
        ...    console=${server1_console}  bmc=${server1_bmc_host}  bmcUser=${server1_bmc_user}
        ...    bmcPassword=${server1_bmc_pwd}  bmcUsers=@{server1_bmc_users}
        ...    sshKeys=@{server1_ssh_keys}  managed=${${server1_managed_by_pcc}}

        Log    \nCreating Server node with parameters : \n${data}\n    console=yes
        ${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        # Should Be Equal As Strings    ${resp.status_code}    200

        # wait for few seconds to add Server into Node List
        Sleep    90s

        # Validate Added Node Present in Node List
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        # Hit get_node_list API for few times to refresh the node list
        # And verify Node availability from the latest fetched node data
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Sleep    3s
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200

        # Parse fetched node list and verify added Node availability from response data
        ${status}    ${node_id}    Validate Node    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server1_node_name} is not present in node list
        Log    \n Server ID = ${node_id}   console=yes
        Set Suite Variable    ${server1_id}    ${node_id}

        # Verify Online Status of Added Server
        ${status}    Validate Node Online Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Server ${server1_node_name} added successfully but it is offline


        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image1_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    CentOS Linux 7


Deploy Ubuntu 18.04 LTS (Bionic Beaver) in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy Ubuntu 18.04 LTS (Bionic Beaver) in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image2_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Bionic-Beaver


Deploy Ubuntu 19.04 (Disco Dingo) in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy Ubuntu 19.04 (Disco Dingo) in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image3_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Disco-Dingo


Deploy Ubuntu 18.10 ( Cosmic Cuttlefish) in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy Ubuntu 18.10 ( Cosmic Cuttlefish) in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image4_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Cosmic-Cuttlefish


Deploy Debian 9 (stretch) in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy Debian 9 (stretch) in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image5_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Debian-Stretch


Deploy rhel CentOS 7.5 X86_64 in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy rhel CentOS 7.5 X86_64 in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image6_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Linux centOS


Deploy Debian Xenial AMD-64 in a node
        [Tags]  OS Deployment
        [Documentation]   Deploy Debian Xenial AMD-64 in a node

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image7_name}  locale=${en_US}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Debial Xenial


OS deployment without filling mandatory field
        [Tags]  OS Deployment
        [Documentation]   OS deployment without filling mandatory field

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image1_name}  locale=${en_US}  timezone=${PDT}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Not Equal As Strings  ${resp.status_code}  200

#        # Wait for 20 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	7 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	7 minutes
#        Log To Console    \nOS Deployment Started...
#        Sleep	6 minutes
#
#        # Verify Provision Status over server
#        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
#        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished
#
#        # Verify CentOS installed in remote machine
#        Verify OS installed in server machine    Linux CentOS


OS deployment without locale
        [Tags]  OS Deployment
        [Documentation]   OS deployment without locale

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image1_name}  timezone=${PDT}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Not Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    CentOS Linux 7


OS deployment without timezone
        [Tags]  OS Deployment
        [Documentation]   OS deployment without timezone

        # Start OS Deployment
        &{data}    Create Dictionary  nodes=[${${server1_id}}]  image=${image2_name}  locale=${en_US}  adminUser=${mass_user}  sshKeys=${ssh_key}
        Log    \n Deploying OS with params = ${data}    console=yes
        ${resp}  Post Request    platina   ${os_deployment}    json=${data}    headers=${headers}
        Log    \n Status Code = ${resp.status_code}    console=yes
        Log    \n Response Data = ${resp.json()}    console=yes
    	Should Be Not Equal As Strings  ${resp.status_code}  200

        # Wait for 20 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	7 minutes
        Log To Console    \nOS Deployment Started...
        Sleep	6 minutes

        # Verify Provision Status over server
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Validate OS Provision Status    ${resp.json()}    ${server1_node_name}
        Should Be Equal As Strings    ${status}    True    msg=Provision Status of server ${server1_node_name} is not Finished

        # Verify CentOS installed in remote machine
        Verify OS installed in server machine    Bionic-Beaver


*** keywords ***
Verify OS installed in server machine
        [Arguments]    ${os_name}

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
