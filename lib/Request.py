from RequestsLibrary import RequestsLibrary


class Request(RequestsLibrary):

    def post_request(
            self,
            alias,
            uri,
            data=None,
            json=None,
            params=None,
            headers=None,
            files=None,
            allow_redirects=None,
            timeout=None
            ):

        session = self._cache.switch(alias)
        if not files:
            data = self._format_data_according_to_header(session, data, headers)
        redir = True if allow_redirects is None else allow_redirects
        if data:
            import json; data = json.loads(data)

        if json:
            if type(json) == list:
                json = [ int(x) for x in json ]

        if str(uri) == "/maas/deployments/":
            json['nodes'] = eval(json['nodes'])
            json['sshKeys'] = eval(json['sshKeys'])

        if ("gitUrl" in json) and ("appNamespace" in json):
            json = eval(str(json))

        response = self._body_request(
                                "post",
                                session,
                                uri,
                                data,
                                json,
                                params,
                                files,
                                headers,
                                redir,
                                timeout
                                )
        dataStr = self._format_data_to_log_string_according_to_header(data, headers)
        return response

    def put_request(
            self,
            alias,
            uri,
            data=None,
            json=None,
            params=None,
            files=None,
            headers=None,
            allow_redirects=None,
            timeout=None
            ):

        session = self._cache.switch(alias)
        data = self._format_data_according_to_header(session, data, headers)
        redir = True if allow_redirects is None else allow_redirects

        if json:
            try:
                json = { str(key):int(val) for key, val in json.items()}
            except:
                json= json

        if json.has_key("Id"):
            json['Id'] = int(json['Id'])

        if json:
            if json.has_key("roles"):
                if type(json["roles"]) == list:
                    json["roles"] = [ int(val) for val in json["roles"] ]
                else:
                    json["roles"] = [json["roles"]]

        response = self._body_request(
                            "put",
                            session,
                            uri,
                            data,
                            json,
                            params,
                            files,
                            headers,
                            redir,
                            timeout
                            )
        if isinstance(data, bytes):
            data = data.decode('utf-8')
        print('Put Request using : alias=%s, uri=%s, data=%s, \
                headers=%s, allow_redirects=%s ' % (alias, uri, data, headers, redir))

        return response