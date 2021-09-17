import re
import requests
from functools import partial
from kardia_api import Kardia
from kardia_api.objects.report_objects import SchedReportStatus
from send_reports.kardia_clients.kardia_client import KardiaClient, ScheduledReport
from send_reports.senders.sender import SendingInfo
from requests.models import Response
from typing import Callable, Dict, List


class RestAPIKardiaClient(KardiaClient):


    def __init__(self, kardia_url, user, pw):
        self.kardia = Kardia(kardia_url, user, pw)
        self.kardia_url = kardia_url
        self.auth = (user, pw)


    def _make_api_request(self, request_func: Callable[[], Response]) -> Dict[str, str]:
        # other error handling can go here if needed in the future
        response = request_func()
        response.raise_for_status()
        return response.json()


    def _get_params_for_sched_report(self, schedReportId: str) -> Dict[str, str]:
        params = {}
        self.kardia.report.setParams(res_attrs="basic")
        paramsRequest = partial(self.kardia.report.getSchedReportParams, schedReportId)
        paramsJson = self._make_api_request(paramsRequest)
        for paramName, paramInfo in paramsJson.items():
            if paramName.startswith("@id"):
                continue
            params[paramName] = paramInfo["value"]
        return params


    def _get_emails_for_partner(self, partnerId: str) -> List[str]:
        recipientEmails = []
        self.kardia.partner.setParams(res_attrs="basic")
        partnerContactsRequest = partial(self.kardia.partner.getPartnerContactInfos, partnerId)
        partnerContactsJson = self._make_api_request(partnerContactsRequest)
        for contactId, contactInfo in partnerContactsJson.items():
            if contactId.startswith("@id"):
                continue
            if contactInfo["contact_type"] != "Email":
                continue
            recipientEmails.append(contactInfo["contact"])
        return recipientEmails

    
    def get_scheduled_reports_to_be_sent(self):
        self.kardia.report.setParams(res_attrs="basic")
        schedReportJson = self._make_api_request(self.kardia.report.getSchedReportsToBeSent)
        schedReports = []

        for schedReportId, schedReportInfo in schedReportJson.items():
            if schedReportId.startswith("@id"):
                continue
            if schedReportInfo["delivery_method"] != "E":
                continue
            reportFile = schedReportInfo["report_file"]
            year = schedReportInfo["date_to_send"]["year"]
            month = schedReportInfo["date_to_send"]["month"]
            day = schedReportInfo["date_to_send"]["day"]
            hour = schedReportInfo["date_to_send"]["hour"]
            minute = schedReportInfo["date_to_send"]["minute"]
            second = schedReportInfo["date_to_send"]["second"]

            partnerRequest = partial(self.kardia.partner.getPartner, schedReportInfo["recipient_partner_key"])
            partnerJson = self._make_api_request(partnerRequest)
            recipientName = partnerJson["partner_name"]

            recipientEmails = self._get_emails_for_partner(schedReportInfo["recipient_partner_key"])
            params = self._get_params_for_sched_report(schedReportId)

            schedReport = ScheduledReport(schedReportId, reportFile, year, month, day, hour, minute, second,
                recipientName, recipientEmails, params)
            schedReports.append(schedReport)
        
        return schedReports


    def _generate_report_filename(self, report_file: str, params: Dict[str, str]) -> str:
        # Prefix with report path minus / and .rpt
        filename = report_file.replace("/", "_").replace(".rpt", "")
        for key, value in params.items():
            filename += f'_{key}_{value}'
        # Strip out any non-alphanumeric characters
        filename = re.sub(r'[^\w\s]', '', filename)
        filename += ".pdf"
        return filename


    def generate_report(self, report_file, params, generated_file_dir):
        filename = self._generate_report_filename(report_file, params)
        file_path = f'{generated_file_dir}/{filename}'

        # Not using kardia_api for this, since it's not really set up for getting arbitrary .rpts and a manual request
        # is pretty simple
        report_url = f'{self.kardia_url}/modules/{report_file}'
        request_params = {**params, "document_format": requests.utils.quote("application/pdf")}
        response = requests.get(report_url, auth=self.auth, params=request_params)
        with open(file_path, "wb") as file:
            file.write(response.content)

        return file_path

    
    def update_scheduled_report_status(self, sched_report_id: str, sending_info: SendingInfo, report_path: str):
        sent_status = SchedReportStatus.SchedStatusTypes(sending_info.sent_status.value)
        report_status = SchedReportStatus(
            sent_status,
            sending_info.error_message,
            sending_info.time_sent,
            report_path)
        updateRequest = partial(self.kardia.report.updateSchedReportStatus, sched_report_id, report_status)
        self._make_api_request(updateRequest)