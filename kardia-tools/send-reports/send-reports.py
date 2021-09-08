import toml
# from kardia_api import Kardia
from kardia_clients.rest_api_kardia_client import RestAPIKardiaClient

config = toml.load("config.toml")
kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
kardia_client.get_scheduled_reports_to_be_sent()

# kardia = Kardia(config["kardia_url"], config["user"], config["pw"])
# kardia.report.setParams(res_attrs="basic")
# # res = kardia.partner.getPartnerContactInfos(100002)
# res = kardia.report.getSchedReportsToBeSent()
# json = res.json()
# for attribute, value in json.items():
#   if attribute.startswith('@id'):
#     continue
#   print(attribute)
#   print(value)
#   kardia.report.setParams(res_attrs="basic")
#   print(kardia.report.getSchedReportParams(attribute).json())