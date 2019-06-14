
class Data_Parser:
    
    def validate_node(self, resp_data, node_name):
        """ find added node from node list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                return True, str(data['Id'])
        return False, None

    def validate_node_manage_status(self, resp_data, node_name, status):
        """ find added node manage status
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                if str(data['managed']) == str(status):
                    return True
        return False

    def validate_group(self, resp_data, expect_group):
        """ Get Expected Group from the group list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(expect_group):
                    return True, str(data['Id'])
        return False, None

    def validate_roles(self, resp_data, expect_role):
        """ Get Expected Role from the group list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['name']) == str(expect_role):
                    return True, str(data['id'])
        return False, None

    def validate_sites(self, resp_data, expect_site):
        """ Get Expected Site from the site list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(expect_site):
                return True, str(data['Id'])
        return False, None

    def validate_sites_desc(self, resp_data, expect_desc):
        """ Get Expected Site Description from the site list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Description']) == str(expect_desc):
                return True, str(data['Id'])
        return False, None

    def validate_node_site(self, resp_data, node_name, site_id):
        """ validated updated site in node
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                if int(data['Site_Id']) == int(site_id):
                    return True, str(data['Id'])
        return False, None

    def get_tenant_id(self, response, tenant_name):
        """get tenant id from tenant list
        """
        for tenant in response:
            if str(tenant['name']) == str(tenant_name):
                return str(tenant['id'])
        return None

