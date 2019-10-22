*** Settings ***
Library         SSHLibrary
Library    	    ${CURDIR}/../lib/Request.py
Variables       ${CURDIR}/../test_data/Url_Paths.py
Library         ${CURDIR}/../lib/Json_validator.py
Library         ${CURDIR}/../lib/Pcc_cli_api.py
Resource        ${CURDIR}/../resource/Common_api.robot

Test Setup      Login into PCC    host_url=${server_url}    user_name=${user_name}    password=${user_pwd}
Test Teardown   Logout from PCC


*** Test Cases ***

Uninstall LLDP and Verify on invader
        [Tags]    test
        [Documentation]    Uninstall LLDP and Verify on invader

        #${status}    Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${True}
        #Should Be Equal As Strings    ${status}    True
        #${status}    Verify Invader is present in Node List    name=${invader1_node_name}
        #Should Be Equal As Strings    ${status}    True
        #${id}    Verify Invader is Online    name=${invader1_node_name}
        #Should Not Be Equal As Strings    ${status}    None
        #${status}    Install LLDP Role    node_name=${invader1_node_name}
        #Should Be Equal As Strings    ${status}    True
        #${status}    Verify LLDP Installed    node_name=${invader1_node_name}
        #Should Be Equal As Strings    ${status}    True
        ${status}    Remove LLDP Role  node_name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        ${status}    Verify LLDP Role is Removed  node_name=${invader1_node_name}
        Should Be Equal As Strings    ${status}    True
        #Verify LLDP uninstalled from backend  node_name=${invader1_node_name}  #Need to create keyword
        #Events generated for LLDP is removed  node_name=${invader1_node_name}  #Need to create keyword
        #Verify topology and overall connectivity  node_name=${invader1_node_name}  #Need to create keyword

Clean up

        Delete Invader  name=${invader1_node_name}
        Verify Invader is Deleted  name=${invader1_node_name}

Uninstall LLDP and Verify on server
        [Tags]    test1
        [Documentation]    Uninstall LLDP and Verify on server
        
       ${status}    Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_ip}/23  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
       Should Be Equal As Strings    ${status}    True
       ${status}    Verify Server is present in Node List    name=${server1_node_name}
       Should Be Equal As Strings    ${status}    True
       ${id}    Verify Server is Online    name=${server1_node_name}
       Should Not Be Equal As Strings    ${status}    None
       ${status}    Install LLDP Role    node_name=${server1_node_name}
       Should Be Equal As Strings    ${status}    True
       ${status}    Verify LLDP Installed    node_name=${server1_node_name}
       Should Be Equal As Strings    ${status}    True
       $status}    Remove LLDP Role  node_name=${server1_node_name}
       Should Be Equal As Strings    ${status}    True
       ${status}    Verify LLDP Role is Removed  node_name=${server1_node_name}
       Should Be Equal As Strings    ${status}    False
       #Verify LLDP uninstalled from backend  node_name=${server1_node_name}  #Need to create keyword
       #Events generated for LLDP is removed  node_name=${server1_node_name}  #Need to create keyword
       #Verify topology and overall connectivity  node_name=${server1_node_name}  #Need to create keyword

Clean up

        Delete Server  name=${server1_node_name}
        Verify Server is Deleted  name=${server1_node_name}

Reboot PCC and verify LLDP status
        [Documentation]    Reboot PCC and verify LLDP status on invader and server

        Add Invader     name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is present in Node List      name=${invader1_node_name}
        Verify Invader is Online        name=${invader1_node_name}
       Install LLDP Role       node_name=${invader1_node_name}
       Verify LLDP Installed       node_name=${invader1_node_name}
       Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  bmc=${server1_bmc_host}/23  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
       Verify Server is present in Node List    name=${server1_node_name}
       Verify Server is Online    name=${server1_node_name}
       Install LLDP Role    node_name=${server1_node_name}
       Verify LLDP Installed    node_name=${server1_node_name}
       Topology formation      #need to create
       Verify LLDP Installed on CLI  node_name=${invader1_node_name} #need to create
       Reboot PCC name={PCC_name}      #need to create
       Verify Invader is Online    name=${invader1_node_name}
       Verify Server is Online    name=${server1_node_name}
       Verify LLDP Installed    node_name=${invader1_node_name}
       Verify LLDP Installed    node_name=${server1_node_name}

Clean up

        Remove LLDP Role    node_name=${invader1_node_name}
        Remove LLDP Role    node_name=${server1_node_name}
        Verify LLDP Role is Removed        node_name=${invader1_node_name}
        Verify LLDP Role is Removed        node_name=${server1_node_name}
        Delete Server       name=${server1_node_name}
        Verify Server is Deleted        name=${server1_node_name}
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}

Reboot Invader
        [Documentation]    Reboot Invader and check the behaviour
	[Tags]	ri
        #Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        #Verify Invader is present in Node List    name=${invader1_node_name}
        #Verify Invader is Online    name=${invader1_node_nam}
#        Install LLDP Role    node_name=${invader1_node_name}
#        Verify LLDP Installed    node_name=${invader1_node_name}
        Reboot Node    node_name=${invader1_node_name}
#        Verify Node is Rebooted    name=${invader1_node_name} # need to create keyword for 'Verify Node is Rebooted' multiple times
       	${id}    Verify Invader is Online    name=${invader1_node_name}
	Should Not Be Equal As Strings    ${id}    None
	${status}    Verify LLDP Installed    node_name=${invader1_node_name}
	Should Be Equal As Strings    ${status}    True
	

Clean up

        Remove LLDP Role    node_name=${invader1_node_name}
        Verify LLDP Role is Removed    node_name=${invader1_node_name}
        Delete Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is Deleted    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}


Reboot Invader Multiple Times
        [Documentation]    Reboot Invader and check the behaviour

        Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is present in Node List    name=${invader1_node_name}
        Verify Invader is Online    name=${invader1_node_nam}
        Install LLDP Role    node_name=${invader1_node_name}
       Verify LLDP Installed    node_name=${invader1_node_name}
        Reboot Node multiple times    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Node is Rebooted    name=${invader1_node_name}
        Verify Invader is Online    name=${invader1_node_name}

Clean up

        Remove LLDP Role    node_name=${invader1_node_name}
        Verify LLDP Role is Removed    node_name=${invader1_node_name}
        Delete Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is Deleted    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}

Reboot Server
        [Documentation]    Reboot Server and check the behaviour
	[Tags]		rs
        #${status}	Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}  
	...		bmc=${server1_bmc_ip}  bmc_user=${server1_bmc_user}  bmc_password=${server1_bmc_pwd}  
	...		bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
        #Should Be Equal As Strings    ${status}    True
	#${status}	Verify Server is present in Node List    name=${server1_node_name}
        #Should Be Equal As Strings    ${status}    True
	#${status}	Verify Server is Online    name=${server1_node_name}
        #Should Not Be Equal As Strings    ${status}    None
	
	#${status}	Install LLDP Role    node_name=${server1_node_name}
       	#${status}	Verify LLDP Installed    node_name=${server1_node_name}
        #Should Be Equal As Strings    ${status}    True
	
	Reboot Node    node_name=${server1_node_name}
	#Server reboot    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}
        #Verify Node is Rebooted    name=${server1_node_name}
        ${status}	Verify Server is Online    name=${server1_node_name}
	Should Not Be Equal As Strings    ${status}    None
	${status}    Verify LLDP Installed    node_name=${server1_node_name}
        Should Be Equal As Strings    ${status}    True
Clean up

        Remove LLDP Role    node_name=${server1_node_name}
        Verify LLDP Role is Removed    node_name=${server1_node_name}
        Delete Server    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}
        Verify Server is Deleted    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}

Reboot Server Multiple Times
        [Documentation]    Reboot Server multiple times and check the behaviour

        Add Server    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}
        Verify Server is present in Node List    name=${server1_node_name}
        Verify Server is Online    name=${server1_node_name}
        Install LLDP Role    node_name=${server1_node_name}
       Verify LLDP Installed    node_name=${server1_node_name}
       Reboot Node multiple times    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}
        Verify Node is Rebooted    name=${server1_node_name}
        Verify Server is Online    name=${server1_node_name}

Clean up

        Remove LLDP Role    node_name=${server1_node_name}
        Verify LLDP Role is Removed    node_name=${server1_node_name}
        Delete Server    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}
        Verify Server is Deleted    name=${server1_node_name}    host=${server1_node_host}    managed_by_pcc=${False}y_pcc=${False}


PCC_Topology_formation_with_LLDP
        [Documentation]    Add Invader as a Node and Verify Online Status


        Add Invader    name=${invader1_node_name}    host=${invader1_node_host}    managed_by_pcc=${False}
        Verify Invader is present in Node List    name=${invader1_node_name}
        Verify Invader is Online    name=${invader1_node_name}
        Add Server    name=${server1_node_name}  host=${server1_node_host}  console=${server1_console}
        ... bmc=${server1_bmc_host}/23  bmc_user=${server1_bmc_user}
        ... bmc_password=${server1_bmc_pwd}  bmc_users=${server1_bmc_user}    ssh_key=${server1_ssh_keys}  managed_by_pcc=${True}
       Verify Server is present in Node List    name=${server1_node_name}
       Verify Server is Online    name=${server1_node_name}
       Verify Topology

Clean up

        Remove LLDP Role    node_name=${invader1_node_name}
        Remove LLDP Role    node_name=${server1_node_name}
        Verify LLDP Role is Removed        node_name=${invader1_node_name}
        Verify LLDP Role is Removed        node_name=${server1_node_name}
        Delete Server       name=${server1_node_name}
        Verify Server is Deleted        name=${server1_node_name}
        Delete Invader    name=${invader1_node_name}
        Verify Invader is Deleted    name=${invader1_node_name}
