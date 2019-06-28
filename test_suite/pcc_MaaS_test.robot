*** Settings ***
Library  	OperatingSystem
Library  	Collections
Library  	String
Library         SSHLibrary
   

Library    	${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/MaaS_Test_Data.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions


*** test cases ***

pcc_MaaS_Enable_Bare_Metal_Services
	[Tags]    MaaS    Scalability_test
        # Get Id of MaaS role
        ${resp}  Get Request    platina   ${add_role}    headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        ${status}    ${role_id}    Get MaaS Role Id    ${resp.json()}
        Should Be Equal As Strings    ${status}    True    msg=MaaS Role Not Found in Roles
        Set Suite Variable    ${maas_role_id}    ${role_id}
        Log    \n MaaS Role ID = ${maas_role_id}    console=yes

        # Get Node Id and online status
	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['status']}    200
        ${status}    ${id}    Validate Node    ${resp.json()}    ${node_name}
        Log    \n Node ${node_name} ID = ${id}   console=yes
        Set Suite Variable    ${node_id}    ${id}
        Should Be Equal As Strings    ${status}    True    msg=node ${node_name} is not present in node list
        ${status}    Validate Node Online Status    ${resp.json()}    ${node_name}
        Should Be Equal As Strings    ${status}    True    msg=node ${node_name} added successfully but it is offline

        # Assign MaaS role to node
	@{roles_group}    create list    2    ${maas_role_id}
        &{data}    Create Dictionary  Id=${node_id}    roles=${roles_group}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200

	Sleep    60s

	# SSH into node host and verify MasS installation process started
        Ssh into node HOST
	Run Keyword And Ignore Error	Verify mass installation process started

	# Wait for 10 minutes
	Sleep	10 minutes 10 seconds

	# Verify Maas Installation Complete status
       	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
       	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
       	Log    \n Status code = ${resp.status_code}    console=yes
       	Log    \n Response = ${resp.json()}    console=yes
       	Should Be Equal As Strings    ${resp.status_code}    200
       	Should Be Equal As Strings    ${resp.json()['status']}    200
       	#${status}    ${node_id}    Validate Node Roles    ${resp.json()}    ${node_name}    ${maas_role_id}
       	#Should Be Equal As Strings    ${status}    True    msg=Node ${node_name} is not updated with the MaaS Roles

	Run Keyword And Ignore Error	Verify mass installation process completed
	
	# Install Cent OS from PCC
#	# Get MaaS image ID
#        ${resp}    Get Request    platina    ${get_maas_images}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings    ${resp.status_code}    200
#     	${status}    ${image_id}    Get CentOS image ID    ${resp.json()}
#        Should Be Equal As Strings    ${status}    True    msg=CENT OS image not found
#        Log    \n CentOS Image ID = ${image_id}   console=yes
#        Set Suite Variable    ${centOS_image_id}    ${image_id}
#
#	# Verify provision finished status in pcc
#
#	# Verify CentOS installed in remote machine


*** keywords ***
ssh into node HOST
       	Open Connection     ${SSH_HOST}    timeout=1 hour
	Login               ${SSH_USERNAME}        ${SSH_PASSWORD}
        Sleep    2s

Verify mass installation process started
        ${output}=         Execute Command    ps -aef | grep ROOT
        Log    \n\n DATA = ${output}    console=yes
	Should Contain    ${output}    tinyproxy.conf

Verify mass installation process completed
        ${output}=         Execute Command    ps -aef | grep ROOT
        Log    \n\n DATA = ${output}    console=yes
	Should Not Contain    ${output}     tinyproxy.conf
