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
            timeout=None):
	    """ Send a POST request on the session object found using the
	        given `alias`
	        ``alias`` that will be used to identify the Session object in the cache
	        ``uri`` to send the POST request to
	        ``data`` a dictionary of key-value pairs that will be urlencoded
	               and sent as POST data
	               or binary data that is sent as the raw body content
	               or passed as such for multipart form data if ``files`` is also
	                  defined
	        ``json`` a value that will be json encoded
	               and sent as POST data if files or data is not specified
	        ``params`` url parameters to append to the uri
	        ``headers`` a dictionary of headers to use with the request
	        ``files`` a dictionary of file names containing file data to POST to the server
	        ``allow_redirects`` Boolean. Set to True if POST/PUT/DELETE redirect following is allowed.
	        ``timeout`` connection timeout
	    """
	    session = self._cache.switch(alias)
	    if not files:
	        data = self._format_data_according_to_header(session, data, headers)
	    redir = True if allow_redirects is None else allow_redirects
            if data:
        	import json; data = json.loads(data)

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
	            timeout)
            dataStr = self._format_data_to_log_string_according_to_header(data, headers)
            return response
	
        def validate_node(self, resp, node_name):
            for data in eval(str(resp))['Data']:
               if str(data['Name']) == str(node_name):
                   return True
            return False

