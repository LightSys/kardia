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

    def _add_replaceable_params(self, replaceable_params: Dict[str, str]):
        now = datetime.now()
        replaceable_params["month"] = now.strftime("%B")

    def send_report(self, report_path, contact_infos: List[str], replaceable_params):
        smtp = smtplib.SMTP("localhost")
        for contact_info in contact_infos:

            # Gather replaceable parameters and replace them in the template
            replaceable_params_for_contact = {**replaceable_params}
            replaceable_params_for_contact["email"] = contact_info
            self._add_replaceable_params(replaceable_params_for_contact)
            email_for_contact = self.email_template
            for param_name, param_value in replaceable_params_for_contact.items():
                email_for_contact = email_for_contact.replace(f'{{{{{param_name}}}}}', param_value)

            # Create an email message and attach the report file
            msg = email.message_from_string(email_for_contact, policy=email.policy.EmailPolicy())
            (_, filename) = os.path.split(report_path)
            with open(report_path, 'rb') as fp:
                msg.add_attachment(fp.read(), maintype="application", subtype="pdf", filename=filename)

            try:
                smtp.send_message(msg)
            except smtplib.SMTPResponseException as se:
                return SendingInfo(
                    SentStatus.FAILURE_OTHER_ERROR,
                    None,
                    error_message=f'{se.smtp_code} {se.smtp_error}')
        smtp.quit()
        return SendingInfo(SentStatus.SENT, datetime.now())