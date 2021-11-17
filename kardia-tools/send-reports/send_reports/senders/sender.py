import abc
from send_reports.models import KardiaUserAgent, OSMLPath, ScheduledReport, SendingInfo
from typing import Dict

class ReportSender(abc.ABC):
    @abc.abstractmethod
    def send_report(self, report_path: OSMLPath, scheduled_report: ScheduledReport,
        kardia_user_agent: KardiaUserAgent, dry_run: bool) -> SendingInfo:
        pass
