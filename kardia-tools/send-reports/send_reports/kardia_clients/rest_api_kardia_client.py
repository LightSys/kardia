import base64
import mimetypes
import os
import re
import requests
from datetime import datetime
from functools import partial
from kardia_api import Kardia
from kardia_api.objects.report_objects import SchedReportBatchStatus, SchedReportStatus, SchedStatusTypes
from send_reports.kardia_clients.kardia_client import KardiaClient
from send_reports.models import InvalidPathElementException, KardiaUserAgent, OSMLPath, ScheduledReport, \
    ScheduledReportParam, SendingInfo, SentStatus
from requests.models import Response
from typing import Callable, Dict, List


class RestAPIKardiaClient(KardiaClient):


    def __init__(self, kardia_url, user, pw):
        self.kardia = Kardia(kardia_url, user, pw)
        self.kardia_url = kardia_url
        self.auth = (user, pw)
        # If a scheduled report batch's ID is a key in this dictionary, it means that its "sent by" information has
        # already been updated and doesn't need to be updated again
        self.batch_sent_by_already_updated = {}


    def _make_api_request(self, request_func: Callable[[], Response]):
        # other error handling can go here if needed in the future
        response = request_func()
        response.raise_for_status()
        return response.json()


    def _get_centrallix_bool(self, value) -> bool:
        # Centrallix JSON just uses 0 for false, 1 for true, None for null
        if value is None:
            return None
        elif value == 0 or value == "0":
            return False
        else:
            return True


    def _get_params_for_sched_report(self, schedReportId: str) -> Dict[str, str]:
        params = {}
        self.kardia.report.setParams(res_attrs="basic")
        paramsRequest = partial(self.kardia.report.getSchedReportParams, schedReportId)
        paramsJson = self._make_api_request(paramsRequest)
        for paramId, paramInfo in paramsJson.items():
            if paramId.startswith("@id"):
                continue
            # Don't include null parameters
            if paramInfo["param_value"] is None:
                continue
            pass_to_report = self._get_centrallix_bool(paramInfo["pass_to_report"])
            pass_to_template = self._get_centrallix_bool(paramInfo["pass_to_template"])
            param = ScheduledReportParam(paramInfo["param_value"], pass_to_report, pass_to_template)

            params[paramInfo["param_name"]] = param
        return params


    def _get_template(self, template_file: str) -> str:
        template_url = ""
        if template_file.startswith("/"):  # absolute path
            base_url = self.kardia_url.partition("/apps/kardia")[0]  # get the bit of the kardia_url before /apps/kardia
            template_url = f"{base_url}{template_file}"
        else:  # relative path
            template_url = f"{self.kardia_url}/files/{template_file}"

        response = self.kardia.report.session.get(template_url, auth=self.auth, params={"cx__mode": "rest"})
        template = response.text
        return template


    def get_user_agent(self):
        app_info_json = self._make_api_request(self.kardia.app_info.getAppInfo)
        return KardiaUserAgent(app_info_json["app_name"], app_info_json["app_version"])


    def get_config(self):
        self.kardia.config.setParams(res_attrs="basic")
        config_json = self._make_api_request(self.kardia.config.getConfig)
        config = {
            "email": {}
        }

        if "ReportsDryRun" in config_json:
            config["dry_run"] = self._get_centrallix_bool(config_json["ReportsDryRun"]["s_config_value"])
        if "ReportsDir" in config_json:
            config["generated_report_osml_dir"] = config_json["ReportsDir"]["s_config_value"]
        if "ReportsHost" in config_json:
            config["email"]["host"] = config_json["ReportsHost"]["s_config_value"]
        if "ReportsPort" in config_json:
            config["email"]["port"] = int(config_json["ReportsPort"]["s_config_value"])
        if ("ReportsHostname" in config_json) and (config_json["ReportsHostname"]["s_config_value"] != ""):
            config["email"]["local_hostname"] = config_json["ReportsHostname"]["s_config_value"]
        if ("ReportsTimeout" in config_json) and (config_json["ReportsTimeout"]["s_config_value"] != ""):
            config["email"]["timeout"] = int(config_json["ReportsTimeout"]["s_config_value"])

        return config



    def get_scheduled_reports_to_be_sent(self, filters, on_individual_report_error):
        self.kardia.report.setParams(res_attrs="basic")
        sched_report_json = self._make_api_request(self.kardia.report.getSchedReportsToBeSent)
        sched_reports = []

        for sched_report_id, sched_report_info in sched_report_json.items():
            try:
                if sched_report_id.startswith("@id"):
                    continue
                if (filters.report_group_name is not None) and \
                    (sched_report_info["report_group_name"] != filters.report_group_name):
                    continue
                if (filters.report_group_sched_id is not None) and \
                    (sched_report_info["report_group_sched_id"] != filters.report_group_sched_id):
                    continue
                if (filters.delivery_method is not None) and \
                    (sched_report_info["delivery_method"] != filters.delivery_method):
                    continue

                report_group_name = sched_report_info["report_group_name"]
                sched_batch_id = sched_report_info["sched_report_batch_name"]
                report_file = sched_report_info["report_file"]
                email = sched_report_info["recipient_email"]

                year = sched_report_info["date_to_send"]["year"]
                month = sched_report_info["date_to_send"]["month"]
                day = sched_report_info["date_to_send"]["day"]
                hour = sched_report_info["date_to_send"]["hour"]
                minute = sched_report_info["date_to_send"]["minute"]
                second = sched_report_info["date_to_send"]["second"]
                date_to_send = datetime(year, month, day, hour=hour, minute=minute, second=second)

                send_if_empty = self._get_centrallix_bool(sched_report_info["send_if_empty"])
                # If send_empty isn't defined, then the report can just be sent without checking if it's empty
                if send_if_empty is None:
                    send_if_empty = True

                partner_request = partial(self.kardia.partner.getPartner, sched_report_info["recipient_partner_key"])
                partner_json = self._make_api_request(partner_request)
                recipient_name = partner_json["partner_name"]

                params = self._get_params_for_sched_report(sched_report_id)
                template = self._get_template(sched_report_info["template_file"])

                sched_report = ScheduledReport(
                    report_group_name=report_group_name,
                    sched_report_id=sched_report_id,
                    sched_batch_id=sched_batch_id,
                    report_file=report_file,
                    send_if_empty=send_if_empty,
                    date_to_send=date_to_send,
                    recipient_name=recipient_name,
                    recipient_contact_info=email,
                    template=template,
                    params=params
                )
                sched_reports.append(sched_report)
            except Exception:
                # if there was a problem, raise an error but move on to processing the next report
                on_individual_report_error(sched_report_id)
        
        return sched_reports


    def update_sent_by_for_scheduled_batch(self, sched_batch_id: str):
        if sched_batch_id in self.batch_sent_by_already_updated:
            return
        batch_status = SchedReportBatchStatus(sent_by = self.auth[0])
        update_request = partial(self.kardia.report.updateSchedReportBatchStatus, sched_batch_id, batch_status)
        self._make_api_request(update_request)
        self.batch_sent_by_already_updated[sched_batch_id] = True


    def _validate_path_element(self, path_element: str):
        if path_element == "." or path_element == ".." or "/" in path_element or "\0" in path_element:
            raise InvalidPathElementException(f"Path element contains invalid metacharacter")

        return path_element

    
    def _get_report_filepath(self, json: Dict[str, str], scheduled_report: ScheduledReport,
        params: Dict[str, str]) -> str:
        path_prefix = f"{scheduled_report.report_group_name}/{scheduled_report.sched_report_id}"

        # First try to get filename from cx__download_as metadata
        filename = json.get("cx__download_as")
        if not filename:
            # If one isn't found, generate a filename from params
            # Prefix with report path minus / and .rpt
            filename = scheduled_report.report_file.replace("/", "_").replace(".rpt", "")
            for key, value in params.items():
                filename += f'_{key}_{value}'
            # Strip out any non-alphanumeric characters
            filename = re.sub(r'[^\w\s]', '', filename)
            # Try to guess the correct extension based on the response metadata, but if there isn't one, default to pdf
            extension = ".pdf"
            content_type = json.get("inner_type")
            if content_type is not None:
                guessed_extension = mimetypes.guess_extension(content_type)
                extension = guessed_extension or extension
            filename += extension

        path = (f"{self._validate_path_element(scheduled_report.report_group_name)}/"
            f"{self._validate_path_element(scheduled_report.sched_report_id)}/"
            f"{self._validate_path_element(filename)}")
        return path


    def generate_report(self, scheduled_report, generated_file_dir):
        report_params = {
            param_name: param.value 
            for param_name, param in scheduled_report.params.items() 
            if param.pass_to_report
        }

        reportRequest = partial(self.kardia.report.getReport, scheduled_report.report_file, report_params)
        json = self._make_api_request(reportRequest)

        # If we're skipping empty reports and this report is empty...
        if (not scheduled_report.send_if_empty
            and "is_empty" in json
            and self._get_centrallix_bool(json["is_empty"])):
            return None

        content = base64.b64decode(json["cx__objcontent"])
        filepath = self._get_report_filepath(json, scheduled_report, report_params)
        osml_filepath = OSMLPath(generated_file_dir.path_to_rootnode, f'{generated_file_dir.osml_path}/{filepath}')
        # Create directories for report file if they don't already exist
        os.makedirs(os.path.dirname(osml_filepath.get_full_path()), exist_ok=True)
        with open(osml_filepath.get_full_path(), "wb") as file:
            file.write(content)

        return osml_filepath

    
    def update_scheduled_report_status(self, scheduled_report, sending_info, report_path):
        sent_status = SchedStatusTypes(sending_info.sent_status.value)
        osml_path = report_path.osml_path if report_path else None
        report_status = SchedReportStatus(
            sent_status,
            sending_info.error_message,
            sending_info.time_sent,
            osml_path)
        updateRequest = partial(self.kardia.report.updateSchedReportStatus, scheduled_report.sched_report_id,
            report_status)
        self._make_api_request(updateRequest)


    def update_sent_status_for_scheduled_batch(self, sched_batch_id: str, sent_status: SentStatus):
        batch_status = SchedReportBatchStatus(sent_status = SchedStatusTypes(sent_status.value))
        update_request = partial(self.kardia.report.updateSchedReportBatchStatus, sched_batch_id, batch_status)
        self._make_api_request(update_request)
