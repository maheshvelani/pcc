*** Settings ***
Library    ${CURDIR}/Request.py
Library  OperatingSystem
Library  Collections
Library  String


*** test cases ***
Verify User should not be able to login with invalid credentials
	[Tags]    Login_Test    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
        &{data}=    Create Dictionary   username=dummy    password=dummy
	${resp}  Post Request    platina   /security/auth/    json=${data}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200


Verify User should be able to login into Platina Server with valid
	[Tags]    Login_Test    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
        &{data}=    Create Dictionary   username=admin    password=admin
	${resp}  Post Request    platina   /security/auth/    json=${data}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}  200
        ${bearer_token} =   Catenate    Bearer    ${resp.json()['token']}   
	Set Suite Variable    ${sec_token}    ${bearer_token}


Verify User should be able to get available Node roles from platina Server
        [Tags]    Node    smoke_test
        Create Session    platina    https://172.17.2.46:9999    verify=False
	&{headers}=    Create Dictionary   Authorization=${sec_token}
	${resp}  Get Request    platina   /pccserver/roles/    headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings  ${resp.status_code}  200
	
	
Verify User Should be able to add Node to Platina server
	[Tags]    Node    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
	&{headers}=    Create Dictionary   Authorization=${sec_token}
	&{data}=    Create Dictionary  	Name=i30    Host=172.17.2.29
	${resp}  Post Request    platina   /pccserver/node/add/    json=${data}     headers=${headers}
	Log    \n Status code = ${resp.status_code}    console=yes
	Log    \n Response = ${resp.json()}    console=yes
	Should Be Equal As Strings  ${resp.status_code}    200
	Should Be Equal As Strings  ${resp.json()['status']}    200


Verify Added Node present in Node List
	[Tags]    Node    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
	&{headers}=    Create Dictionary   Authorization=${sec_token}
	&{data}    Create Dictionary  page=0  limit=50  sortBy=name  sortDir=asc  search=
	${resp}  Get Request    platina   /pccserver/node/    params=${data}     headers=${headers}
        Log    \n Status code = ${resp.status_code}    console=yes
        Log    \n Response = ${resp.json()}    console=yes
        Should Be Equal As Strings  ${resp.status_code}    200
        Should Be Equal As Strings  ${resp.json()['status']}    200
 	${status}    Validate Node    ${resp.json()}    i30
	Should Be Equal As Strings  ${status}    True


Create 10 sites over platina server
	[Tags]    Node    smoke_test
	Create Session    platina    https://172.17.2.46:9999    verify=False
	&{headers}=    Create Dictionary   Authorization=${sec_token}
	:FOR    ${index}    IN RANGE    1  11
	\    &{data}    Create Dictionary  Name=Site_${Index}    Description=Site_${Index}
	\    ${resp}  Post Request    platina   /pccserver/site/add/    json=${data}     headers=${headers}
	\    Log    \n Status code = ${resp.status_code}    console=yes
	\    Log    \n Response = ${resp.json()}    console=yes
	\    Should Be Equal As Strings  ${resp.status_code}    200
