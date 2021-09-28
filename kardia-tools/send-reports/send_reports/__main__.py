import toml
from send_reports.kardia_clients.rest_api_kardia_client import RestAPIKardiaClient
from send_reports.senders.email_report_sender import EmailReportSender

config = toml.load("config.toml")
kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
report_sender = EmailReportSender(config["email"]["smtp"])

scheduled_reports = kardia_client.get_scheduled_reports_to_be_sent()
for scheduled_report in scheduled_reports:
    kardia_client.update_sent_by_for_scheduled_batch(scheduled_report.sched_batch_id)
    generated_filepath = kardia_client.generate_report(
        scheduled_report.report_file,
        scheduled_report.params,
        config["generated_pdf_path"]
    )
    replaceable_params = {**scheduled_report.params, "name": scheduled_report.recipient_name}
    sending_info = report_sender.send_report(generated_filepath, scheduled_report.recipient_contact_info,
        scheduled_report.template, replaceable_params)
    kardia_client.update_scheduled_report_status(scheduled_report.sched_report_id, sending_info, generated_filepath)