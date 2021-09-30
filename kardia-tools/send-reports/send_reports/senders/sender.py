import abc
from send_reports.models import ScheduledReport, SendingInfo
from typing import Dict

class ReportSender(abc.ABC):
    @abc.abstractmethod
    def send_report(self, report_path: str, scheduled_report: ScheduledReport) -> SendingInfo:
        pass