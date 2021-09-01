Email reports tool
==================

This is a tool for emailing out Kardia reports scheduled for sending in the table r_group_sched_report.

To run:

- Install Python 3.9. You may need to compile it from source, but this is pretty straighforward (see for example https://tecadmin.net/install-python-3-9-on-centos/)

- In the send-reports folder, create a virtual environment: `python3.9 -m venv venv`

- Activate the virtual environment: `source venv/bin/activate`

- Install the required pip packages: `pip install -r requirements.txt`

- Install your Kardia API .whl: `pip install kardia_api.whl`

- Now whenever you'd like to run the script, just call `./venv/bin/python send-reports.py`