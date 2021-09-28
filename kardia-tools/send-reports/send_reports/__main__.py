import toml
from send_reports.kardia_clients.rest_api_kardia_client import RestAPIKardiaClient
from send_reports.senders.email_report_sender import EmailReportSender
from send_reports.senders.sender import SentStatus

config = toml.load("config.toml")
kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
report_sender = EmailReportSender(config["email"]["smtp"])

scheduled_reports = kardia_client.get_scheduled_reports_to_be_sent()
num_reports = len(scheduled_reports)
# Sort by scheduled report batch, so reports in the same batch are guaranteed to all be next to each other
scheduled_reports.sort(key=lambda scheduled_report: scheduled_report.sched_batch_id)

current_batch_sent_status = SentStatus.SENT

for index, scheduled_report in enumerate(scheduled_reports):
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

    # TODO once errors besides FAILURE_OTHER_ERROR are being used:
    # the last type of error is what is set for the entire batch
    if sending_info.sent_status != SentStatus.SENT:
        current_batch_sent_status = sending_info.sent_status
    # If we're at the end of the list, or are about to start processing a new batch, then update the batch's sent status
    if ((index + 1) == num_reports) or \
            (scheduled_reports[index + 1].sched_batch_id != scheduled_report.sched_batch_id):
        kardia_client.update_sent_status_for_scheduled_batch(scheduled_report.sched_batch_id, current_batch_sent_status)
        current_batch_sent_status = SentStatus.SENT  # reset batch status