#!/usr/bin/env python


############################################
#
# Request Response Parser and Validator lib
#
###########################################


class Json_validator:

    @staticmethod
    def validate_node(resp_data, node_name, host=None):
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

    @staticmethod
    def validate_node_manage_status(resp_data, node_name, status):
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

    @staticmethod
    def validate_group(resp_data, expect_group):
        """ Get Expected Group from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(expect_group):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def get_node_group_count(resp_data, expect_group, desc=None):
        """ Validate Node group count
        """
        g_cnt = 0
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(expect_group):
                    g_cnt += 1
                    if desc:
                        if ((str(data['Description:']) == None)
                                or
                             (str(data['Description:']) == '')):
                            return True, str(data['Id'])
                        else:
                            return False, None
            return True, str(g_cnt)
        except Exception:
            return False, None

    @staticmethod
    def validate_group_desc(resp_data, expect_group_desc):
        """ Get Expected Group from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Description']) == str(expect_group_desc):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_role_desc(resp_data, expect_role, expect_role_desc=None):
        """ Get Expected Role from the role list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == str(expect_role):
                    if str(data['Description:']) == str(expect_role_desc)\
                        or \
                            str(data['Description:']) == '':
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_roles(resp_data, expect_role):
        """ Get Expected Role from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == str(expect_role):
                    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_role_tenant(resp_data, expect_role):
        """ Get Expected Role Tenant from the group list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == str(expect_role):
                    if int("1") not in list(data['owners']):
                        return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_sites(resp_data, expect_site):
        """ Get Expected Site from the site list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(expect_site):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_sites_desc(resp_data, expect_desc):
        """ Get Expected Site Description from the site list
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Description']) == str(expect_desc):
                    return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_node_site(resp_data, node_name, site_id):
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

    @staticmethod
    def get_tenant_id(response, tenant_name):
        """get tenant id from tenant list
        """
        try:
            for tenant in response:
                if str(tenant['name']) == str(tenant_name):
                    return True, str(tenant['id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def verify_parent_tenant(response, tenant_name, parent_id):
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

    @staticmethod
    def validate_node_group(resp_data, node_name, group_id):
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

    @staticmethod
    def validate_node_roles(resp_data, node_name, role_id):
        """ validated Assigned Roles in node
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
			if (str(data['provisionStatus']) == "Finished") or (str(data['provisionStatus']) == "Ready"):
                    		if int(role_id) in list(data['roles']):
                            		return True
                        elif str(data['provisionStatus']) == "In Progress":
                        	return "Continue"
                        else:
                            	return False
            return False
        except Exception:
            return False

    @staticmethod
    def validate_node_tenant(resp_data, node_name, tenant_id):
        """ validated Assigned Tenant in node
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['Name']) == str(node_name):
                    if int(tenant_id) == int(data['owner']):
                        return True, str(data['Id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def get_maas_role_id(resp_data):
        """ Get MaaS role Id from response
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == "MaaS":
                    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def get_lldp_role_id(resp_data):
        """ Get LLDP role Id from response
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['name']) == "LLDP":
                    return True, str(data['id'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_node_online_status(resp_data, node_name):
        """ Verify Node Online Status
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node_name):
                        if str(data['nodeAvailabilityStatus']['connectionStatus']) == "online":
                            return True, str(data['Id'])
                        else:
                            return False, None
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_node_provision_status(resp_data, node_name):
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

    @staticmethod
    def validate_os_provision_status(resp_data, node_name):
        """ Verify OS deploy Status
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
			 if str(data['Name']) == str(node_name):
                         	if (str(data['provisionStatus']) == "Finished") or (str(data['provisionStatus']) == "Ready"):
                            		return True
                        	elif str(data['provisionStatus']) == "In Progress":
                        		return "Continue"
                        	else:
                            		return False
            return False
        except Exception:
            return False

    @staticmethod
    def verify_server_up_time(uptime_data):
        """ validate Server Uptim
        """
        if "day" in str(uptime_data).lower():
            return False

        if "hours" in str(uptime_data).lower():
            return False

        return True

    @staticmethod
    def validate_cluster(resp_data, cluster_name):
        """ verify added cluster from cluster list
        """
        try:
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['name']) == str(cluster_name):
                        return True, str(data['ID'])
            return False, None
        except Exception:
            return False, None

    @staticmethod
    def validate_cluster_deploy_status(resp_data):
        """ Get Server ID added After PXE boot
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['deployStatus']) == "installed":
                    return True
            return False
        except Exception:
            return False

    @staticmethod
    def validate_cluster_health_status(resp_data):
        """ Get Server ID added After PXE boot
        """
        try:
            for data in eval(str(resp_data))['Data']:
                if str(data['healthStatus']).lower() == "good":
                    return True
            return False
        except Exception:
            return False

    @staticmethod
    def verify_app_present_in_cluster(resp_data, app_name):
        """Verify Installed App Present in cluster details"""
        try:
            #for data in eval(str(resp_data))['Data']:
            if str(app_name) in str(eval(str(resp_data))['Data']["apps"]):
                    return True
            return False
        except Exception:
            return False

    @staticmethod
    def verify_node_added_in_cluster(resp_data, node_id):
        """ Verify added Node Present in Cluster
        """
        try:
            for data in eval(str(resp_data))['Data']["nodes"]:
                if int(data['id']) == int(node_id):
                    return True
            return False
        except Exception:
            return False

    @staticmethod
    def verify_cluster_deleted(resp_data, cluster_name):
        """ verify Deleted Cluster
        """
        try:
            if cluster_name in str(eval(str(resp_data))['Data']):
                return False
            return True
        except Exception:
            return False

    @staticmethod
    def verify_cluster_version(resp_data, cluster_ver):
        """ verify Cluster Version
        """
        try:
            if cluster_ver in str(eval(str(resp_data))['Data']["k8sVersion"]):
                return True
            return False
        except Exception:
            return False

    @staticmethod
    def validate_node_2(resp_data, node_name, host=None):
        """ find added node from node list
        """
        try:
            node_cnt = 0
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node_name):
                        node_cnt += 1
            if node_cnt == 2:
                return True
            else:
                return False
        except Exception:
            return False

    @staticmethod
    def get_node_host_ip(resp_data, node):
        """ Get HOST IP of Node
        """
        try:
            if resp_data['Data'] != None:
		
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node):
                        return data["Host"]
            returnNone
        except Exception:
            return None

    @staticmethod
    def get_existing_roles_detail(resp_data, node, role):
        """ Get HOST IP of Node
        """
        try:
            role_list = []
            if resp_data['Data'] != None:
                for data in eval(str(resp_data))['Data']:
                    if str(data['Name']) == str(node):
                        try:
                            role_list = list(data["roles"])
                        except Exception:
                            role_list = data["roles"]
                        role_list.append(int(role))

                        return role_list
            return None
        except Exception:
            return None
