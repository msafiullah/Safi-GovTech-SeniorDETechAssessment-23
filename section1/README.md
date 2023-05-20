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
