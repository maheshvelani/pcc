#!/usr/bin/env python

################################################
#
# Entry Criteria data parsing and validation API
#
################################################

from robot.api import logger


def robot_logger(msg):
    """Custom logger
    """
    logger.info(str(msg), html=True, also_console = True)

class Entry_Criteria_Api:

    def get_available_node_data(self, resp_data):
        """Check any Invader or Server is available in node list
           if yes then return node with attached IP
        """
        node_data = {}
        node_id_lst = []

        try:
            if resp_data['Data'] == None:
                return False, None
            else:
                for index, data in enumerate(eval(str(resp_data))['Data']):
                    node_data.update({index:{"name":data['Name'], "ID" : str(data["Id"]), \
                                             "HOST" : str(data["Host"])}})
                    node_id_lst.append(int(data['Id']))
                return True, node_id_lst, node_data

            return False, None
        except Exception:
            return False, None


