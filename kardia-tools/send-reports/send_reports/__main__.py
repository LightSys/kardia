import sys
import syslog
import toml
import traceback
from collections import defaultdict
from send_reports.kardia_clients.kardia_client import KardiaClient
from send_reports.kardia_clients.rest_api_kardia_client import RestAPIKardiaClient
from send_reports.models import ScheduledReport, SentStatus
from send_reports.senders.email_report_sender import EmailReportSender
from send_reports.senders.sender import ReportSender
from typing import List


def _handle_error(message, should_exit):
    syslog.syslog(syslog.LOG_ERR, f'{message} {traceback.format_exc()}')
    if should_exit:
        sys.exit(1)


def _process_batch(batch_id: str, batch_reports: List[ScheduledReport], generated_report_path: str,
    kardia_client: KardiaClient, report_sender: ReportSender):
    try:
        kardia_client.update_sent_by_for_scheduled_batch(batch_id)
    except Exception:
        _handle_error(f"Error updating sent by for scheduled batch {batch_id}, continuing on to process batch's " + 
            "scheduled reports...", False)

    one_report_succeeded = False
    for scheduled_report in batch_reports:
        succeeded = _process_scheduled_report(scheduled_report, generated_report_path, kardia_client, report_sender)
        if succeeded:
            one_report_succeeded = True

    try:
        # PLEASE NOTE the logic here. If ANY report sent successfully, the whole batch is marked as sent. If ALL reports
        # failed, the whole batch is simply marked with FAILURE_OTHER_ERROR, not any more fine-grained errors that might
        # have come up.
        if one_report_succeeded:
            kardia_client.update_sent_status_for_scheduled_batch(batch_id, SentStatus.SENT)
        else:
            kardia_client.update_sent_status_for_scheduled_batch(batch_id, SentStatus.FAILURE_OTHER_ERROR)
    except Exception:
        _handle_error(f"Error updating sent status for scheduled batch {batch_id}, continuing on to next batch...",
            False)


def _process_scheduled_report(scheduled_report: ScheduledReport, generated_report_path: str,
    kardia_client: KardiaClient, report_sender: ReportSender) -> bool:
    try:
        generated_filepath = kardia_client.generate_report(scheduled_report, generated_report_path)
        sending_info = report_sender.send_report(generated_filepath, scheduled_report)
        kardia_client.update_scheduled_report_status(scheduled_report, sending_info, generated_filepath)
        return sending_info.sent_status == SentStatus.SENT
    except Exception:
        _handle_error(f"Error handling scheduled report {scheduled_report.sched_report_id}, " +
            "continuing on to next scheduled report...", False)


config = None
try:
    syslog.openlog(ident="kardia_python_send_reports")
    config = toml.load("config.toml")
except Exception:
    _handle_error("Error opening log or configuration", True)

kardia_client = None
report_sender = None
batches = None

try:
    kardia_client = RestAPIKardiaClient(config["kardia_url"], config["user"], config["pw"])
    report_sender = EmailReportSender(config["email"]["smtp"])
    scheduled_reports = kardia_client.get_scheduled_reports_to_be_sent()
    batches = defaultdict(list)
    for scheduled_report in scheduled_reports:
        batches[scheduled_report.sched_batch_id].append(scheduled_report)
except Exception:
    _handle_error("Error initializing Kardia + email clients and getting scheduled reports", True)

for batch_id, batch_reports in batches.items():
    _process_batch(batch_id, batch_reports, config["generated_report_path"], kardia_client, report_sender)