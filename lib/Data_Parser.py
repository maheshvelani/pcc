
class Data_Parser:
    
    def Validate_Node(self, resp_data, node_name):
        """ find added node from node list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                return True
        return False

    def validate_node_manage_status(self, resp_data, node_name, status):
        """ find added node manage status
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                if str(data['managed']) == str(status):
                    return True
        return False


