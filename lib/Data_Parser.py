
class Data_Parser:
    
    def Validate_Node(self, resp_data, node_name):
        """ find added node from node list
        """
        for data in eval(str(resp_data))['Data']:
            if str(data['Name']) == str(node_name):
                return True
        return False


