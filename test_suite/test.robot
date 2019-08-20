*** Settings ***
Library         OperatingSystem
Library         SSHLibrary


*** test cases ***
login test 125
	Open Connection     172.17.2.125
	Login              root    plat1na

 	${output}=         Execute Command    ls -l
	Log To Console    \nO/P = ${output}

	Close All Connections


login 110
	Open Connection     172.17.2.110
        Login              root    plat1na

        ${output}=         Execute Command    ls -l
        Log To Console    \nO/P = ${output}

        Close All Connections


login 43
        Open Connection     172.17.2.43
        Login              pcc    cals0ft

        ${output}=         Execute Command    ls -l
        Log To Console    \nO/P = ${output}

        Close All Connections


login 61
        Open Connection     172.17.2.61
        Login              pcc    cals0ft

        ${output}=         Execute Command    ls -l
        Log To Console    \nO/P = ${output}

        Close All Connections
