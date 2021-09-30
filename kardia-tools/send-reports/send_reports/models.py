import pprint
from datetime import datetime
from enum import Enum
from typing import Dict

class ScheduledReportParam:
    def __init__(self, value: str, pass_to_report: bool, pass_to_template: bool):
        self.value = value
        self.pass_to_report = pass_to_report
        self.pass_to_template = pass_to_template

    def __repr__(self) -> str:
        return str(self.__dict__)

class ScheduledReport:
    def __init__(self, sched_report_id: str, sched_batch_id: str, report_file: str, year: int, month: int, day: int,
            hour: int, minute: int, second: int, recipient_name: str, recipient_contact_info, template: str,
            params: Dict[str, ScheduledReportParam]):
        self.sched_report_id = sched_report_id
        self.sched_batch_id = sched_batch_id
        self.report_file = report_file
        self.date_to_send = datetime(year, month, day, hour=hour, minute=minute, second=second)
        self.recipient_name = recipient_name
        self.recipient_contact_info = recipient_contact_info
        self.template = template
        self.params = params
    
    def __repr__(self) -> str:
        return pprint.pformat(self.__dict__, indent=2)

class SentStatus(Enum):
    NOT_SENT = "N"
    SENT = "S"
    TEMPORARY_ERROR = "T"
    INVALID_EMAIL_ERROR = "I"
    FAILURE_OTHER_ERROR = "F"

class SendingInfo:
    def __init__(self, sent_status: SentStatus, time_sent: datetime, error_message=""):
        self.sent_status = sent_status
        self.time_sent = time_sent
        self.error_message = error_message

    def __repr__(self) -> str:
        return str(self.__dict__)