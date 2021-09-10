import toml
from kardia_clients.rest_api_kardia_client import RestAPIKardiaClient

config = toml.load("config.toml")
kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
scheduled_reports = kardia_client.get_scheduled_reports_to_be_sent()
for scheduled_report in scheduled_reports:
    kardia_client.generate_report(
        scheduled_report.report_file,
        scheduled_report.params, 
        config["generated_pdf_path"]
    )