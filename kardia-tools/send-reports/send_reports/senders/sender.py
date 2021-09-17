import abc
from datetime import datetime
from enum import Enum
from typing import Dict, List

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
        return (f'sent_status: {self.sent_status}\ntime_sent: {self.time_sent}\n'+ 
            f'error_message: {self.error_message}\n')

class ReportSender(abc.ABC):
    @abc.abstractmethod
    def send_report(self, report_path: str, contact_infos: List, replaceable_params: Dict[str, str]) -> SendingInfo:
        pass