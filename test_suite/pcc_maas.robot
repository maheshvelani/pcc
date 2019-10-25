*** Settings ***
Library         SSHLibrary
Variables       ${CURDIR}/../test_data/Url_Paths.py
Resource        ${CURDIR}/../resource/Common_api.robot

Test Setup      Login into PCC    host_url=${server_url}    user_name=${user_name}    password=${user_pwd}
Test Teardown   Logout from PCC


*** Test Cases ***

PCC_Enable_Maas_Bare_Metal_Services_Root
        [Tags]    MaaS

        # Add an Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Assign MaaS role to invader
        ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}


pcc_MaaS_Enable_Bare_Metal_Services_Tenant_User
        [Tags]    MaaS

        # Login with tenatn User
        # Login with Tenant User    name=${tenant_user_name}    pwd=${tenant_user_pwd}

        # Add an Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Assign MaaS role to invader
        ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}


Installation_Uninstallation_MaaS_multiple times
        [Tags]    MaaS

        # Add an Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        :FOR  ${index}  IN RANGE    1    11
        \  # Assign MaaS role to invader
        \  ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    \  Should Be Equal As Strings    ${status}    True
	    \  ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    \  Should Be Equal As Strings    ${status}    True
	    \  ${status}  Remove MaaS Role    node_name=${invader1_node_name}
	    \  Should Be Equal As Strings    ${status}    True
	    \  ${status}    Verify MaaS Role is Removed
	    \  Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}


No_MaaS_Present/Available_For_Server
        [Tags]    MaaS

        # Add Server
        ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Not Be Equal As Strings    ${status}    None

	    # Assign MaaS role to invader
        ${status}    Install MaaS Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    False
	    ${status}    Verify MaaS Installed    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    False

Clean up
        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}


pcc_Remove_MaaS_Role_from_Invader_no_Residue
        [Tags]    MaaS

        # Add an Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Remove MaaS role from invader
        ${status}    Remove MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Role is Removed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}


Installation of MaaS application along with other apps on invader
        [Tags]    MaaS

        # Add an Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        ${id1}    Get LLDP Id
        ${id2}    Get MaaS Id
        &{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
        ${resp}  Get Request    platina   ${get_node_list}    params=${data}  headers=${headers}
        &{data}    get existing roles detail    ${resp.json()}    ${node_name}    ${id1}
        &{data}    get existing roles detail    ${resp.json()}    ${node_name}    ${id2}
        ${resp}  Put Request    platina    ${add_group_to_node}    json=${data}     headers=${headers}
        Should Be Equal As Strings    ${resp.status_code}    200
        ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}


Perform operating system deployment as a sub-tenant user
        [Tags]    MaaS

        # Assume User is looged in as a sub-tenent user
        # Logout from PCC
        # Login into PCC    host_url=${server_url}    user_name=${tenant_user_name}    password=${tenant_user_pwd}

        # Add Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Install LLDP and MaaS role
        ${status}    Install LLDP Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

	    ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

        # Add server Node
	    ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Not Be Equal As Strings    ${status}    None

	    # Assign LLDP role
	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True

        # Deploy OS
        ${status}    OS Deployment    node=${server1_node_name}     image=${image1_name}     locale=${locale}    time_zone=${PDT}
         ...  admin_user=${admin_user}    ssh_key=${ssh_key}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify OS installed  node_name=${server1_node_name}       os_name=${image1_name}
        Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}


Perform operating system deployment as a tenant user
        [Tags]    MaaS

        # Assume User is looged in as a tenent user
        # Logout from PCC
        # Login into PCC    host_url=${server_url}    user_name=${tenant_user_name}    password=${tenant_user_pwd}

        # Add Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Install LLDP and MaaS role
        ${status}    Install LLDP Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

	    ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

        # Add server Node
	    ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Not Be Equal As Strings    ${status}    None

	    # Assign LLDP role
	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True

        # Deploy OS
        ${status}    OS Deployment    node=${server1_node_name}     image=${image1_name}     locale=${locale}    time_zone=${PDT}
         ...  admin_user=${admin_user}    ssh_key=${ssh_key}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify OS installed  node_name=${server1_node_name}       os_name=${image1_name}
        Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}


PXE_Boot_should_not _work for_pre-existing_nodes in PCC
        [Tags]    MaaS

        # Add Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Install LLDP and MaaS role
        ${status}    Install LLDP Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

        # Add an Server
	    ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Not Be Equal As Strings    ${status}    None

        # Assign LLDP role
	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True

        # PXE boot the Server
        ${status}    PXE Boot the server    bmc_ip=${server1_bmc_ip}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Booted server reflected over PCC UI   bmc_ip=${server1_bmc_ip}
        Should Be Equal As Strings    ${status}    False

Clean up
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}


Invalid_node_PXE_Booted
        [Tags]    MaaS

        # Add Invader
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Install LLDP and MaaS role
        ${status}    Install LLDP Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

        # Add an Server
	    ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is present in Node List    name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify Server is Online    name=${server1_node_name}
	    Should Not Be Equal As Strings    ${status}    None

        # Assign LLDP role
	    ${status}    Install LLDP Role    node_name=${server1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True

        # PXE boot the Server
        ${status}    PXE Boot the server    bmc_ip=${server1_bmc_ip}
        Should Be Equal As Strings    ${status}    False

Clean up
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}


MaaS deployment on multiple invaders simultaneously /parallelly
        [Tags]    MaaS

        # Add Invader - 1
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Add Invader - 2
        ${status}    Add Invader    name=${invader2_node_name}    host=${invader2_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader2_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader2_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Assign MaaS role to both server
        ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Install MaaS Role    node_name=${invader2_node_name}
	    Should Be Equal As Strings    ${status}    True
        ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader2_node_name}
	    Should Be Equal As Strings    ${status}    True

Clean up
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
        Delete Invader    name=${invader2_node_name}
        Verify Invader is Deleted    name=${invader2_node_name}


Reboot PCC & verify MaaS status
        [Tags]    MaaS

        # Add Invader - 1
        ${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${id}    Verify Invader is Online    name=${invader1_node_name}
        Should Not Be Equal As Strings    ${id}    None

        # Assign MaaS role to invader
        ${status}    Install MaaS Role    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True
	    ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True

        # Reboot PCC node
        Reboot Node    node_name=${invader1_node_name}

        # Verify MaaS installed
        ${status}    Verify MaaS Installed    node_name=${invader1_node_name}
	    Should Be Equal As Strings    ${status}    True











