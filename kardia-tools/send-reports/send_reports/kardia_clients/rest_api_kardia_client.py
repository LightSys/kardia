import re
import requests
from functools import partial
from kardia_api import Kardia
from kardia_api.objects.report_objects import SchedReportBatchStatus, SchedReportStatus, SchedStatusTypes
from send_reports.kardia_clients.kardia_client import KardiaClient, ScheduledReport
from send_reports.senders.sender import SendingInfo
from requests.models import Response
from typing import Callable, Dict, List


class RestAPIKardiaClient(KardiaClient):


    def __init__(self, kardia_url, user, pw):
        self.kardia = Kardia(kardia_url, user, pw)
        self.kardia_url = kardia_url
        self.auth = (user, pw)
        # If a scheduled report batch's ID is a key in this dictionary, it means that its "sent by" information has
        # already been updated and doesn't need to be updated again
        self.batch_sent_by_already_updated = {}


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
            # Don't include null parameters
            if paramInfo["param_value"] is None:
                continue
            params[paramInfo["param_name"]] = paramInfo["param_value"]
        return params


    def _get_contact_info_for_partner(self, partnerId: str) -> List[str]:
        # only handling email for now
        self.kardia.partner.setParams(res_attrs="basic")
        preferredEmailRequest = partial(self.kardia.partner.getPartnerPreferredEmail, partnerId)
        preferredEmailJson = self._make_api_request(preferredEmailRequest)
        return preferredEmailJson["response"]["email"]

    
    def _get_template(self, template_file: str) -> str:
        # Not using kardia_api for this, since it's trivial to just request a file manually
        template_url = f'{self.kardia_url}/files/{template_file}'
        response = requests.get(template_url, auth=self.auth)
        # Need to strip out HTML wrapping the response
        template = response.text.removeprefix("<HTML><PRE>").removesuffix("</HTML></PRE>")
        return template

    
    def get_scheduled_reports_to_be_sent(self):
        self.kardia.report.setParams(res_attrs="basic")
        schedReportJson = self._make_api_request(self.kardia.report.getSchedReportsToBeSent)
        schedReports = []

        for schedReportId, schedReportInfo in schedReportJson.items():
            if schedReportId.startswith("@id"):
                continue
            if schedReportInfo["delivery_method"] != "E":
                continue
            schedBatchId = schedReportInfo["sched_report_batch_name"]
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

            recipientContactInfo = self._get_contact_info_for_partner(schedReportInfo["recipient_partner_key"])
            params = self._get_params_for_sched_report(schedReportId)

            template = self._get_template(schedReportInfo["template_file"])

            schedReport = ScheduledReport(schedReportId, schedBatchId, reportFile, year, month, day, hour, minute,
                second, recipientName, recipientContactInfo, template, params)
            schedReports.append(schedReport)
        
        return schedReports


    def update_sent_by_for_scheduled_batch(self, sched_batch_id: str):
        if sched_batch_id in self.batch_sent_by_already_updated:
            return
        batch_status = SchedReportBatchStatus(sent_by = self.auth[0])
        update_request = partial(self.kardia.report.updateSchedReportBatchStatus, sched_batch_id, batch_status)
        self._make_api_request(update_request)
        self.batch_sent_by_already_updated[sched_batch_id] = True


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
        response = requests.get(report_url, auth=self.auth, params=params)
        with open(file_path, "wb") as file:
            file.write(response.content)

        return file_path

    
    def update_scheduled_report_status(self, sched_report_id: str, sending_info: SendingInfo, report_path: str):
        sent_status = SchedStatusTypes(sending_info.sent_status.value)
        report_status = SchedReportStatus(
            sent_status,
            sending_info.error_message,
            sending_info.time_sent,
            report_path)
        updateRequest = partial(self.kardia.report.updateSchedReportStatus, sched_report_id, report_status)
        self._make_api_request(updateRequest)