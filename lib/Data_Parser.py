#!/usr/bin/env python


############################################
#
# Request Response Parser and Validator lib
#
###########################################



class Data_Parser:
    
    def validate_node(self, resp_data, node_name, host=None):
        """ find added node from node list
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node_name):
                        if host:
                            if str(data['Host']) == str(host):
                                return True, str(data['Id'])
                            else:
                                return False, None
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def validate_node_manage_status(self, resp_data, node_name, status):
        """ find added node manage status
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
                    if str(data['managed']) == str(status):
                        return True
            return False
        except Exception:
            return False

    def validate_group(self, resp_data, expect_group):
        """ Get Expected Group from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(expect_group):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def validate_roles(self, resp_data, expect_role):
        """ Get Expected Role from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == str(expect_role):
                    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    def validate_sites(self, resp_data, expect_site):
        """ Get Expected Site from the site list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(expect_site):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def validate_sites_desc(self, resp_data, expect_desc):
        """ Get Expected Site Description from the site list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Description']) == str(expect_desc):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def validate_node_site(self, resp_data, node_name, site_id):
        """ validated updated site in node
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
                    if int(data['Site_Id']) == int(site_id):
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def get_tenant_id(self, response, tenant_name):
        """get tenant id from tenant list
        """
        try:
            for tenant in response:
                if str(tenant['name']) == str(tenant_name):
                    return True, str(tenant['id'])
            return False, None
        except Exception:
            return False, None

    def verify_parent_tenant(self, response, tenant_name, parent_id):
        """Verify Tenant Parent
        """
        try:
            for tenant in response:
                if str(tenant['name']) == str(tenant_name):
                    if int(parent_id) == int(tenant['owner']):  
                        return True, str(tenant['id'])
            return False, None
        except Exception:
            return False, None

    def validate_node_group(self, resp_data, node_name, group_id):
        """ validated Assigned Group in node
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
                    if int(data['ClusterId']) == int(group_id):
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def validate_node_roles(self, resp_data, node_name, role_id):
        """ validated Assigned Roles in node
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
                    if int(role_id) in list(data['roles']):
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    def get_maas_role_id(self, resp_data):
        """ Get MaaS role Id from response
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == "MaaS":
                    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    def validate_node_online_status(self, resp_data, node_name):
        """ Verify Node Online Status
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node_name):
                        if str(data['nodeAvailabilityStatus']['connectionStatus']) == "online":
                            return True
                        else:
                            return False
            return False
        except Exception:
            return False

    def get_centOS_image_id(self, resp_data):
        """ Get CENT OS image ID
        """
        try:
            for data in a['Data']:
                if "centos" in data['name']:
		    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None


    def validate_node_provision_status(self, resp_data, node_name):
        """ Verify Node Online Status
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node_name):
                        if str(data['provisionStatus']) == "Finished":
                            return True
                        else:
                            return False
            return False
        except Exception:
            return False

