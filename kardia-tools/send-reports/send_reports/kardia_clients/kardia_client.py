import abc
from datetime import datetime
from enum import Enum
from send_reports.senders.sender import SendingInfo
from typing import Dict, List


class ScheduledReport:
    def __init__(self, sched_report_id: str, sched_batch_id: str, report_file: str, year: int, month: int, day: int,
            hour: int, minute: int, second: int, recipient_name: str, recipient_contact_info, template: str,
            params: Dict[str, str]):
        self.sched_report_id = sched_report_id
        self.sched_batch_id = sched_batch_id
        self.report_file = report_file
        self.date_to_send = datetime(year, month, day, hour=hour, minute=minute, second=second)
        self.recipient_name = recipient_name
        self.recipient_contact_info = recipient_contact_info
        self.template = template
        self.params = params

    
    def __repr__(self) -> str:
        return str(self.__dict__)

class KardiaClient(abc.ABC):

    @abc.abstractmethod
    def get_scheduled_reports_to_be_sent(self) -> List[ScheduledReport]:
        pass

    @abc.abstractmethod
    def generate_report(self, report_file: str, params: Dict[str, str], generated_file_dir: str) -> str:
        pass
    
    @abc.abstractmethod
    def update_scheduled_report_status(self, sched_report_id: str, sending_info: SendingInfo, report_path: str):
        pass
    
    # @abc.abstractmethod
    # def update_scheduled_report_group_status(self):
    #     pass