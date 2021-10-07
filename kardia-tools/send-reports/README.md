Email reports tool
==================

This is a tool for emailing out Kardia reports scheduled for sending in the table r_group_sched_report.

To run:

- Make sure you have Python 3 installed. This has been tested on Python 3.6.8 and Python 3.9.6, though of course it may also work on newer/older versions of Python 3.

- In the send-reports folder, create a virtual environment: `python3 -m venv venv`

- Activate the virtual environment: `source venv/bin/activate`

- Install the required pip packages: `pip install -r requirements.txt`

- Install your Kardia Python API .whl: `pip install kardia_api.whl`

- Now whenever you'd like to run the script, just call `./venv/bin/python -m send_reports`. There is no need to activate the virtual environment before doing this.