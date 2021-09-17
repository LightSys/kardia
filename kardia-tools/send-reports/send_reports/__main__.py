import toml
from send_reports.kardia_clients.rest_api_kardia_client import RestAPIKardiaClient
from send_reports.senders.email_report_sender import EmailReportSender

config = toml.load("config.toml")
kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
# TODO: Currently you can only set one email template for all reports to send out
report_sender = EmailReportSender(config["email"]["email_template_path"])

scheduled_reports = kardia_client.get_scheduled_reports_to_be_sent()
for scheduled_report in scheduled_reports:
    generated_filepath = kardia_client.generate_report(
        scheduled_report.report_file,
        scheduled_report.params, 
        config["generated_pdf_path"]
    )
    replaceable_params = {**scheduled_report.params, "name": scheduled_report.recipient_name}
    print(report_sender.send_report(generated_filepath, scheduled_report.recipient_emails, replaceable_params))