*** Keywords ***
Login into PCC
        [Arguments]    ${host_url}=${EMPTY}    ${user_name}=${EMPTY}    ${password}=${EMPTY}
        Create Session    platina    ${host_url}    verify=False
        &{data}    Create Dictionary   username=${user_name}    password=${password}
        ${resp}  Post Request    platina   ${login}    json=${data}
        ${status}    run keyword and return status    Should Be Equal As Strings  ${resp.status_code}  200
        Return From Keyword If    '${status}'==False    False
        Log    \nUser Logged in successfully...    console=yes
        ${bearer_token}    Catenate    Bearer    ${resp.json()['token']}
        Set Suite Variable    ${sec_token}    ${bearer_token}
        &{auth_header}    Create Dictionary   Authorization=${sec_token}
        Set Suite Variable    ${headers}    ${auth_header}
        [Return]    True


Logout from PCC
        ${status}    run keyword and return status    Request.Delete All Sessions
        [Return]    ${status}