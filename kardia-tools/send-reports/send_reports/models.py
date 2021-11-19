import pprint
from datetime import datetime
from enum import Enum
from typing import Dict

class OSMLPath:
    def __init__(self, path_to_rootnode: str, osml_path: str):
        self.path_to_rootnode = path_to_rootnode
        self.osml_path = osml_path

    def get_full_path(self):
        return f'{self.path_to_rootnode}{self.osml_path}'

    def __repr__(self) -> str:
        return str(self.__dict__)

class KardiaUserAgent:
    def __init__(self, app_name: str, app_version: str):
        self.app_name = app_name
        self.app_version = app_version

    def get_user_agent_string(self):
        return f"{self.app_name}/{self.app_version}"

class ScheduledReportFilters:
    def __init__(self, report_group_name: str, report_group_sched_id: str, delivery_method: str):
        # set to None if the filter shouldn't be applied
        self.report_group_name = report_group_name or None
        try:
            self.report_group_sched_id = int(report_group_sched_id)
        except:
            self.report_group_sched_id = None
        self.delivery_method = delivery_method or None

    def __repr__(self) -> str:
        return str(self.__dict__)

class ScheduledReportParam:
    def __init__(self, value: str, pass_to_report: bool, pass_to_template: bool):
        self.value = value
        self.pass_to_report = pass_to_report
        self.pass_to_template = pass_to_template

    def __repr__(self) -> str:
        return str(self.__dict__)

class ScheduledReport:
    def __init__(self, report_group_name: str, sched_report_id: str, sched_batch_id: str, report_file: str, year: int,
            month: int, day: int, hour: int, minute: int, second: int, recipient_name: str, recipient_contact_info,
            template: str, params: Dict[str, ScheduledReportParam]):
        self.report_group_name = report_group_name
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
