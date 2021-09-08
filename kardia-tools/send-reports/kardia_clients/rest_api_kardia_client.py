from kardia_api import Kardia
from kardia_clients.kardia_client import KardiaClient, ScheduledReport, ScheduledReportDeliveryMethod


class RestAPIKardiaClient(KardiaClient):


    def __init__(self, kardia_url, user, pw):
        self.kardia = Kardia(kardia_url, user, pw)

    
    def get_scheduled_reports_to_be_sent(self):
        self.kardia.report.setParams(res_attrs="basic")
        # TODO: handle sad response
        schedReportJson = self.kardia.report.getSchedReportsToBeSent().json()
        for schedReportAttribute, schedReportValue in schedReportJson.items():
            if schedReportAttribute.startswith("@id"):
                continue
            report_file = schedReportValue["report_file"]
            delivery_method = ScheduledReportDeliveryMethod(schedReportValue["delivery_method"])
            year = schedReportValue["send_date"]["year"]
            month = schedReportValue["send_date"]["month"]
            day = schedReportValue["send_date"]["day"]
            hour = schedReportValue["send_date"]["hour"]
            minute = schedReportValue["send_date"]["minute"]
            second = schedReportValue["send_date"]["second"]

            params = {}
            self.kardia.report.setParams(res_attrs="basic")
            # TODO: handle sad response
            paramsJson = self.kardia.report.getSchedReportParams(schedReportAttribute).json()
            for paramAttribute, paramValue in paramsJson.items():
                if paramAttribute.startswith("@id"):
                    continue
                params[paramAttribute] = paramValue["value"]

            schedReport = ScheduledReport(report_file, delivery_method, year, month, day, hour, minute, second, "bewy",
                ["bewy@heemin.com"], params)
            print(schedReport)


    def call_report(self, report_file, params, generated_file_dir):
        pass