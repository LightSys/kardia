# Email reports tool

This is a tool for emailing out Kardia reports scheduled for sending in the table r_group_sched_report.

## Installation

- Make sure you have Python 3 installed. This has been tested on Python 3.6.8 and Python 3.9.6, though of course it may also work on newer/older versions of Python 3.

- In the `kardia-tools/send-reports` directory, copy `config.template` to a new file called `config.toml`. Follow the guidelines in the file to fill in the settings with the settings for your own Kardia install.

- You may want to change ownership and permissions on config.toml to help keep your password secure. Just make sure that whatever user runs the Python script has access to the file.

- Next, set up a Python environment. You can either set up a virtual environment or use system packages.

### Virtual environment

- In the send-reports folder, create a virtual environment: `python3 -m venv venv`

- Activate the virtual environment: `source venv/bin/activate`

- Install the required pip packages: `pip install -r requirements.txt`

- Install your Kardia Python API .whl: `pip install kardia_api.whl`

- To run the script, just call `/path/to/venv/bin/python -m send_reports`. There is no need to activate the virtual environment before doing this.

### System packages

- Install the packages your distribution offers for the Python `requests` and `toml` libraries. For example, on CentOS with Python 3.6, the packages are `python36-requests` and `python36-toml`.

- Install your Kardia Python API .whl: `pip install kardia_api.whl`

- To run the script, navigate to the `kardia-tools/send-reports` directory and run `python3 -m send_reports`.

## Did it work?

If the script runs into problems, it will exit with code 1 and log more information to syslog. (Note that if an individual report runs into issues, the script WILL try to continue with the next report.) If everything goes well, however, the script will execute silently and return code 0.
