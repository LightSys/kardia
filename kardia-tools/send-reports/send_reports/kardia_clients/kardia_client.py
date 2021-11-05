import abc
from send_reports.models import KardiaUserAgent, OSMLPath, ScheduledReport, ScheduledReportFilters, \
    ScheduledReportParam, SendingInfo, SentStatus
from typing import Dict, List

class KardiaClient(abc.ABC):

    @abc.abstractmethod
    def get_user_agent(self) -> KardiaUserAgent:
        pass

    @abc.abstractmethod
    def get_scheduled_reports_to_be_sent(self, filters: ScheduledReportFilters) -> List[ScheduledReport]:
        pass

    @abc.abstractmethod
    def update_sent_by_for_scheduled_batch(self, sched_batch_id: str):
        pass

    @abc.abstractmethod
    def generate_report(self, scheduled_report: ScheduledReport, generated_file_dir: OSMLPath) -> OSMLPath:
        pass
    
    @abc.abstractmethod
    def update_scheduled_report_status(self, scheduled_report: ScheduledReport, sending_info: SendingInfo,
        report_path: OSMLPath):
        pass

    @abc.abstractmethod
    def update_sent_status_for_scheduled_batch(self, sched_batch_id: str, sent_status: SentStatus):
        pass
