# Pre-processing analysis

### `name`
- Name may have prefix and suffix such as Dr., Mr., Mrs., JD., MD, PhD, etc.
- First name should be prefix + actual first name if prefix exists
- Otherwise, First name should be actual first part of name when prefix doesn't exists
- Everything after first name will be last name including suffix

### `email`
- Email is valid only if domain name is valid according to RFC 1035.
  - Must follow the rules for ARPANET host names.
  - They must start with a letter, end with a letter or digit, and have as interior characters only letters, digits, and hyphen.
  - Length must be 63 characters or less.
- For this requirement valid emails must have `.com` or `.net` domain suffix.

### `date_of_birth`
- Data of birth (DOB) value is in many date formats and is represented by string in CSV file.
- Will be loaded and converted to proper `numpy.datetime64` data type for ease of use.
- Will be converted to YYYYMMDD format and stored as string.

### `mobile_no`
- Will be read in string format.
- First digit must be 8 or 9 according to Singapore telco rules.
- Must be 8 digits in total.
- +65 or 0065 country code prefix will be removed.

# Folder Structure

| File | Description |
|--|--|
| README.md | Documentation |
| requirements.txt | Python module requirements to be installed with pip3. |
| etl_dag.py | Airflow DAG is defined here. |
| etl_script.py | Main ETL code that processes the input datasets and writes out result CSVs. |
| utility.py | Helper functions used by main `etl_script.py` python code. |
| input | CSV datafiles to be processed are placed here. File pattern is assumed to be `applications_dataset_*.csv` |
| applications_successful | Output CSV of **successful** applicants will be written here as `applications_YYYYMMDD_HH.csv` |
| applications_unsuccessful | Output CSV of **unsuccessful** applicants will be written here as `applications_YYYYMMDD_HH.csv` |


# Running Locally
You can execute the ETL on your MacOS or Linux machine.

1. Clone this repo

2. Execute below commands
```
cd section1
pip3 install --user -r requirements.txt
python3 etl_script.py
```

3. Check CSV outputs
Look for the `applications_YYYYMMDD_HH.csv` files in `applications_successful` and `applications_unsuccessful` folders.

# Airflow DAG
- ETL workflow is scheduled at the 5th minute of every hour. It assumes that input datafiles are made available by then. 

- The `etl_dag.py` DAG file defines following variables at the beginnin of the script.

| Variable | Description |
|--|--|
| `input_dir` | Path of input CSV files. |
| `input_file_pattern` | File pattern of input CSV files. Example, `applications_dataset_*.csv` |
| `successful_output_dir` | Folder to write output CSV files for **successful** applicants. |
| `unsuccessful_output_dir` | Folder to write output CSV files for **unsuccessful** applicants. |
| `archive_dir` | Folder to move successfully processed input CSV files. |

- The airflow DAG has three tasks that are run in sequence.

![Screenshot of Airflow DAG - ss-airflow-dag.png](https://raw.githubusercontent.com/msafiullah/Safi-GovTech-SeniorDETechAssessment-23/main/section1/ss-airflow-dag.png?token=GHSAT0AAAAAACC3L4CAHYFMMTDNJSCI2YUWZDIOSYA)

| Task S/N | Task ID | Description
|--|--|--|
| 1 | check_input_csvs | Verify if `applications_dataset_*.csv` files exist in INPUT_DIR. |
| 2 | execute_python_etl_code | Take in list of input CSV file paths, process each CSV file, consolidate data, and, output result CSV files. |
| 3 | archive_input_csvs | Move successfully processed `applications_dataset_*.csv` files to archive folder `input_YYYYMMDD_HH`. |

# ETL Log
- Log is ouput to STDOUT (i.e. console) if you are running the ETL script on your local machine.
- Log is capured and accessible via Airflow's logs page if you deploy the ETL DAG to Airflow.
![Screenshot of ETL logs in Airflow - ss-airflow-etl-log.png](https://raw.githubusercontent.com/msafiullah/Safi-GovTech-SeniorDETechAssessment-23/main/section1/ss-airflow-etl-log.png?token=GHSAT0AAAAAACC3L4CAOQWQVLMHHZAMEEMUZDIOM7A)
- Logs are also accessible on Airflow Worker nodes at `$AIRFLOW_HOME/logs/dag_id=safi_ecommerce_membership_processing_etl/`
- You can find sample log file here: `Safi-GovTech-SeniorDETechAssessment-23/section1/sample_log_file.log`
