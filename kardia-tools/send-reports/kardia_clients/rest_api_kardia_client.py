from functools import partial
from kardia_api import Kardia
from kardia_clients.kardia_client import KardiaClient, ScheduledReport
from requests.models import Response
from typing import Callable, Dict, List


class RestAPIKardiaClient(KardiaClient):


    def __init__(self, kardia_url, user, pw):
        self.kardia = Kardia(kardia_url, user, pw)


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
            year = schedReportInfo["send_date"]["year"]
            month = schedReportInfo["send_date"]["month"]
            day = schedReportInfo["send_date"]["day"]
            hour = schedReportInfo["send_date"]["hour"]
            minute = schedReportInfo["send_date"]["minute"]
            second = schedReportInfo["send_date"]["second"]

            partnerRequest = partial(self.kardia.partner.getPartner, schedReportInfo["recipient_partner_key"])
            partnerJson = self._make_api_request(partnerRequest)
            recipientName = partnerJson["partner_name"]

            recipientEmails = self._get_emails_for_partner(schedReportInfo["recipient_partner_key"])
            params = self._get_params_for_sched_report(schedReportId)

            schedReport = ScheduledReport(reportFile, year, month, day, hour, minute, second, recipientName,
                recipientEmails, params)
            print(schedReport)
            schedReports.append(schedReport)
        
        return schedReports


    def call_report(self, report_file, params, generated_file_dir):
        pass