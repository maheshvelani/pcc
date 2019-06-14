import requests
import json

test_data = {'username':'admin', 'password':'admin'}

# Login
resp = requests.post('https://172.17.2.46:9999/security/auth/', json=test_data, verify = False)
print(resp.status_code)
token = 'Bearer ' + resp.json()['token']
print(token)
headers = {'Authorization': token,}


#data = {"Id":1, "Site_Id":29}

#resp = requests.put('https://172.17.2.46:9999/pccserver/node/update', json=data, verify = False, headers = headers)
#print(resp.status_code)
#print(resp.json())


## Get node roles
#headers = {
#    'Authorization': token,
#}
#resp = requests.get('https://172.17.2.46:9999/pccserver/roles/', headers = headers, verify = False)
#print(resp.status_code)
#print(resp.json())
#
#
# add Node
#data = {"Name":"i30","Host":"172.17.2.29", }
data = {"Name":"test", "Host":"172.17.2.29", "bmc":"172.17.3.29", "bmcUser":"ADMIN", "bmcUsers":["ADMIN"], "bmcPassword":"ADMIN"}
resp = requests.post('https://172.17.2.46:9999/pccserver/node/add', headers = headers, json=data, verify = False)
print(resp.status_code)
print(resp.json())

## Get Added Node 
#
#params = {'page':0, 'limit':50, 'sortBy':'name', 'sortDir':'asc', 'search':''}
#resp = requests.get('https://172.17.2.46:9999/pccserver/node', headers = headers, verify = False, params=params)
#print(resp.status_code)
#print(resp.json())
#
#
#params = {"Id":0,"Name":"site_1","Description":"site_1"}
