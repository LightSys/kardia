import toml
from kardia_api import Kardia
config = toml.load("config.toml")
kardia = Kardia(config["kardia_url"], config["user"], config["pw"])
kardia.partner.setParams(res_attrs="basic")
res = kardia.partner.getPartnerContactInfos(100002)
print(res.json())