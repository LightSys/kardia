import abc
from datetime import datetime
from enum import Enum
from send_reports.senders.sender import SendingInfo
from typing import Dict, List


class ScheduledReport:
    def __init__(self, report_file: str, year: int, month: int, day: int, hour: int, minute: int, second: int,
            recipient_name: str, recipient_emails: List[str], params: Dict[str, str]):
        self.report_file = report_file
        self.send_date = datetime(year, month, day, hour=hour, minute=minute, second=second)
        self.recipient_name = recipient_name
        # This could be changed to be just general recipient contact infos (inc email)
        self.recipient_emails = recipient_emails
        self.params = params

    
    def __repr__(self) -> str:
        return (f'report_file: {self.report_file}\n' +
            f'send_date: {str(self.send_date)}\nrecipient_name: {self.recipient_name}\n' +
            f'recipient_emails: {str(self.recipient_emails)}\nparams: {str(self.params)}\n')


class KardiaClient(abc.ABC):

    @abc.abstractmethod
    def get_scheduled_reports_to_be_sent(self) -> List[ScheduledReport]:
        pass

    @abc.abstractmethod
    def generate_report(self, report_file: str, params: Dict[str, str], generated_file_dir: str) -> str:
        pass
    
    # @abc.abstractmethod
    # def update_scheduled_report_status(self):
    #     pass
    
    # @abc.abstractmethod
    # def update_scheduled_report_group_status(self):
    #     pass