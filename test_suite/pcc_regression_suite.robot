*** Settings ***
Library  	OperatingSystem
Library  	Collections
Library  	String

Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Test_Data.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Data_Parser.py
Resource        ${CURDIR}/../resource/Resource_Keywords.robot

Suite Setup    Verify User Login
Suite Teardown    Delete All Sessions


*** test cases ***

#Pcc-node-summary-add-node
#	[Tags]    Node Management    regression_test
#	[Documentation]    Add node in the PCC
#
#	# Add Node
#	&{data}    Create Dictionary  	Name=${node1_name}  Host=${node1_host_addr}  
#	...	bmc=${node1_bmc}  bmcUser=${node1_bmc_user}  bmcPassword=${node1_bmc_pwd}  bmcUsers=@{bmc_users}
#	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings    ${resp.status_code}    200
#	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#	Sleep    40s
#
#	# Validate Added Node
#	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${node1_id}    Validate Node    ${resp.json()}    ${node1_name}
# 	Log    \n Node ${node1_name} ID = ${node1_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=node ${node1_name} is not present in node list
#
#
#Pcc-node-summary-add-node-without-BMC-password
#	[Tags]    Node Management    regression_test
#	[Documentation]    Add node in the PCC without BMC pass
#
#	# Add Node
#	&{data}    Create Dictionary  	Name=${node2_name}  Host=${node2_host_addr}  
#	...	bmc=${node2_bmc}  bmcUser=${node2_bmc_user}  bmcUsers=@{bmc_users}
#	# bmc=${node2_bmc}  bmcUser=${node2_bmc_user}
#	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings    ${resp.status_code}    200
#	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#	Sleep    40s
#
#	# Validate Added Node
#	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#	${resp}  Get Request    platina   ${get_node_list}    params=${data}     headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#   	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${node_id}    Validate Node    ${resp.json()}    ${node2_name}
# 	Set Suite Variable    ${node2_id}    ${node_id}
# 	Log    \n Node ${node2_name} ID = ${node2_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=node ${node2_name} is not present in node list
#
#
#Pcc-node-summary-add-node-managed-by-pcc
#	[Tags]    Node Management    regression_test
#	[Documentation]    Add node – managed-by-pcc check box should be not be checked by default
#
#	# Validate Added Node
#    	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#    	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#    	${status}    Validate Node Manage Status    ${resp.json()}    ${node1_name}    False
#    	Should Be Equal As Strings    ${status}    True    msg=node manage status of ${node1_name} is false by default
#
#
#Pcc-Node-summary-DeleteNode
#	[Tags]    Node Management    regression_test
#	[Documentation]    We can delete the Node
#
#    	@{data}    Create List    ${node2_id}
#	${resp}    Post Request    platina    ${delete_node}    headers=${headers}    json=${data}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#	Sleep    40s
#
#	# Validate Deleted Node
#	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#	${resp}  Get Request    platina   ${get_node_list}    params=${data}     headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#   	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${node_id}    Validate Node    ${resp.json()}    ${node2_name}
#	Should Be Equal As Strings    ${status}    False    msg=node ${node2_name} is present in node list
#
#
#Pcc-node-summary-add-node-with-some-features
#	[Tags]    Node Management    regression_test
#	[Documentation]    Adding a node in PCC with all details except "BMC users" field
#
#	# Add Node
#	&{data}    Create Dictionary  	Name=${node3_name}  Host=${node3_host_addr}  
#	...    bmc=${node3_bmc}  bmcPassword=${node3_bmc_pwd}
#	${resp}    Post Request    platina    ${add_node}    json=${data}   headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings    ${resp.status_code}    200
#	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#	Sleep    40s
#
#	# Validate Added Node
#	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#	${resp}  Get Request    platina   ${get_node_list}    params=${data}     headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#	${status}    ${node_id}    Validate Node    ${resp.json()}    ${node3_name}
#	Should Be Equal As Strings    ${status}    True    msg=node ${node3_name} is not present in node list
#
#
#Pcc-Node-Group-Create
#    	[Tags]    Node Attributes    regression_test
#    	[Documentation]    Node Group Creation
#
#    	# Add Group
#	&{data}    Create Dictionary  Name=${group1_name}    Description=${group1_desc}
#	${resp}  Post Request    platina   ${add_group}    json=${data}     headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#    	# Validate added group
#	${resp}  Get Request    platina   ${get_group}    headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group1_name}
# 	Set Suite Variable    ${group1_id}    ${group_id}
# 	Log    \n Group ${group1_name} ID = ${group1_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=Group ${group1_name} is not present in Groups list
#
#
#Pcc-Node-Group-Delete
#    	[Tags]    Node Attributes    regression_test
#    	[Documentation]    Node Group Deletion
#	
#	Sleep    5s 
#    	# Delete Group
#	${resp}  Delete Request    platina   ${get_group}${group1_id}    headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#    	# Validate Deleted Group
#	${resp}  Get Request    platina   ${get_group}    headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${group_id}    Validate Group    ${resp.json()}    ${group1_name}
#	Should Be Equal As Strings    ${status}    False    msg=Group ${group1_name} is not present in Groups list
#
#
#Pcc-Node-Role-create
#    	[Tags]    Node Attributes    regression_test
#    	[Documentation]    Node Role Creation
#
#	# Add Role
#	&{data}    Create Dictionary  name=${role1_name}    description=${role1_desc}
#	${resp}  Post Request    platina   ${add_role}    json=${data}     headers=${headers}
#   	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#    	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
#
#    	# Validate Added Role
#	${resp}  Get Request    platina   ${add_role}    headers=${headers}
#    	Log    \n Status code = ${resp.status_code}    console=yes
#    	Log    \n Response = ${resp.json()}    console=yes
#   	Should Be Equal As Strings    ${resp.status_code}    200
#    	Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role1_name}
# 	Set Suite Variable    ${role1_id}    ${role_id}
# 	Log    \n Roles ${role1_name} ID = ${role1_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=Role ${role1_name} is not present in Groups list
#
#
#Pcc-Node-Role-Delete
#       [Tags]    Node Attributes    regression_test
#       [Documentation]    Node Role Deletion
#
#	# Delete Roles
#	${resp}  Delete Request    platina   ${add_role}${role1_id}    headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
#
#       # Validate Deleted Roles
#       ${resp}  Get Request    platina   ${add_role}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${role_id}    Validate Roles    ${resp.json()}    ${role1_name}
#	Should Be Equal As Strings    ${status}    False    msg=Role ${role1_name} is not present in Roles list
#
#
#Pcc-sites-add-site
#       [Tags]    Sites    regression_test
#       [Documentation]    Add Site in the PCC
#
#       # Add Site
#       &{data}    Create Dictionary  Name=${site1_name}    Description=${site1_desc}
#       ${resp}  Post Request    platina    ${add_site}    json=${data}     headers=${headers}
# 	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	# Validate Added Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site1_name}
# 	Set Suite Variable    ${site1_id}    ${site_id}
# 	Log    \n Site ${site1_name} ID = ${site1_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=Site ${site1_name} is not present in Site list
#
#
#Pcc-Node-Site-Assignment
#        [Tags]    Sites    regression_test
#        [Documentation]    Assign a particular site to a Node
#
#        # Update Site With Node
#	&{data}    Create Dictionary  Id=${node1_id}    Site_Id=${site1_id}
#	${resp}  Put Request    platina    ${add_site_to_node}    json=${data}     headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	Sleep    30s
#
#	# Validated Updated Site
#	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
#	${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings    ${resp.status_code}    200
#	Should Be Equal As Strings    ${resp.json()['status']}    200
#	${status}    ${node1_id}    Validate Node Site    ${resp.json()}    ${node1_name}    ${site1_id}
#	Should Be Equal As Strings    ${status}    True    msg=Node ${node1_name} is not updated with the site ${site1_name}
#
#
#PCC-Node-Tenant-Assignment
#	[Tags]   Node Management    regression_test
#	[Documentation]    Assign a particular Node to a Tenant.
#	
#	# Add Tenant
#	# Create Tenant
#	&{data}    Create Dictionary    name=${tenant1_name}   description=${tenant1_desc}
# 	${resp}    Post Request    platina    ${add_tenant}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        # Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200 
#        Sleep    10s
#	
#	# Get Tenant Id	
#	${resp}  Get Request    platina   ${tenant_list}    params=${data}  headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#	${tenant1_id}    Get Tenant Id    ${resp.json()}    ${tenant1_name}
#        Log    \n tenant ID = ${tenant1_id}    console=yes
#	
#	# Update Node With Tenants
#        @{node_id_list}    Create List    ${node1_id}
#        &{data}    Create Dictionary    tenant=${tenant1_id}    ids=@{node_id_list}
#	${resp}    Post Request    platina    ${node_tenant_assignment}    json=${data}     headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        # Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings  ${resp.status_code}    200
#        Sleep    10s
#
#
#Pcc-sites-add-site-without-description
#   	[Tags]    Sites    regression_test
#       [Documentation]    Add Site in the PCC without description
#
#       # Add Site
#       &{data}    Create Dictionary  Name=${site2_name}
#       ${resp}  Post Request    platina    ${add_site}    json=${data}     headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	# Validate Added Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site2_name}
# 	Set Suite Variable    ${site2_id}    ${site_id}
# 	Log    \n Site ${site2_name} ID = ${site2_id}   console=yes
#	Should Be Equal As Strings    ${status}    True    msg=Site ${site2_name} is not present in Site list
#
#
#Pcc-sites-add-site-with-invalid-name
#       [Tags]    Sites    regression_test
#       [Documentation]    Add Site in the PCC with invalid name
#
#       # Add Site
#       &{data}    Create Dictionary  Name=${site3_name}    Description=${site3_desc}
#       ${resp}  Post Request    platina    ${add_site}    json=${data}     headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	# Validate Added Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site3_name}
#	Should Be Equal As Strings    ${status}    False    msg=Site ${site3_name} is present in Site list
#
#
#Pcc-sites-edit-site-name
#       [Tags]    Sites    regression_test
#       [Documentation]    Edit Site Name in the PCC
#
#       # Edit Site Name
#       &{data}    Create Dictionary  Name=${site4_name}    Description=${site1_desc}
#       ${resp}  Put Request    platina    ${get_site}${site1_id}    json=${data}    headers=${headers}
# 	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	# Validate Updated Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site4_name}
#	Should Be Equal As Strings    ${status}    True    msg=Site name updated_site is present in Site list
#
#
#Pcc-sites-edit-site-description
#       [Tags]    Sites    regression_test
#       [Documentation]    Edit Site Description in the PCC
#
#       # Edit Site Name
#       &{data}    Create Dictionary  Name=${site4_name}    Description=${site4_desc}
#       ${resp}  Put Request    platina    ${get_site}${site1_id}    json=${data}    headers=${headers}
#	Log    \n Status code = ${resp.status_code}    console=yes
#	Log    \n Response = ${resp.json()}    console=yes
#	Should Be Equal As Strings  ${resp.status_code}    200
#
#	# Validate Updated Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#       Log    \n Status code = ${resp.status_code}    console=yes
#       Log    \n Response = ${resp.json()}    console=yes
#       Should Be Equal As Strings    ${resp.status_code}    200
#       Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites Desc    ${resp.json()}    ${site4_desc}
#	Should Be Equal As Strings    ${status}    True    msg=Site name updated_site is present in Site list
#
#
#Pcc-sites-delete-site
#        [Tags]    Sites    regression_test
#        [Documentation]    Delete Single Site
#
#        # Delete Site
#        @{data}    Create List  ${site2_id}
#	${resp}  Post Request    platina   ${delete_site}    headers=${headers}    json=${data}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        Should Be Equal As Strings    ${resp.json()['status']}    200
#
#        # Validate Deleted Site
#	${resp}  Get Request    platina   ${get_site}    headers=${headers}
#        Log    \n Status code = ${resp.status_code}    console=yes
#        Log    \n Response = ${resp.json()}    console=yes
#        Should Be Equal As Strings    ${resp.status_code}    200
#        Should Be Equal As Strings    ${resp.json()['status']}    200
# 	${status}    ${site_id}    Validate Sites    ${resp.json()}    ${site2_name}
#	Should Be Equal As Strings    ${status}    False    msg=Deleted Site ${site2_name} is present in Site list


*** Variables ***
@{bmc_users}    Create List    ADMIN
