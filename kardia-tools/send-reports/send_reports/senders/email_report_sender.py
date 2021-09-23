import email
import email.policy
import os
import smtplib
from datetime import datetime
from send_reports.senders.sender import ReportSender, SendingInfo, SentStatus
from typing import Dict, List

class EmailReportSender(ReportSender):

    def __init__(self, email_template_path: str):
        with open(email_template_path) as fp:
            self.email_template = fp.read()

    def _add_replaceable_params(self, replaceable_params: Dict[str, str], contact_info):
        replaceable_params["email"] = contact_info
        now = datetime.now()
        replaceable_params["month"] = now.strftime("%B")

    # contact_info is assumed to be a string email
    def send_report(self, report_path, contact_info: str, replaceable_params):
        # Gather replaceable parameters and replace them in the template
        self._add_replaceable_params(replaceable_params, contact_info)
        email_text = self.email_template
        for param_name, param_value in replaceable_params.items():
            email_text = email_text.replace(f'[:{param_name}]', param_value)

        # Create an email message and attach the report file
        msg = email.message_from_string(email_text, policy=email.policy.EmailPolicy())
        # These headers necessary for add_attachment to notice there's an existing email body and not just overwrite it
        msg["Content-Type"] = 'text/plain; charset="utf-8"'
        msg["Content-Transfer-Encoding"] = "7bit"
        (_, filename) = os.path.split(report_path)
        with open(report_path, 'rb') as fp:
            msg.add_attachment(fp.read(), maintype="application", subtype="pdf", filename=filename)

        try:
            smtp = smtplib.SMTP("localhost")
            smtp.send_message(msg)
            smtp.quit()
        except smtplib.SMTPResponseException as se:
            return SendingInfo(
                SentStatus.FAILURE_OTHER_ERROR,
                None,
                error_message=f'{se.smtp_code} {se.smtp_error}')

        return SendingInfo(SentStatus.SENT, datetime.now())