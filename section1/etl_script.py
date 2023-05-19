#!/usr/bin/env python3


"""
Python script to perform ETL for 2 datasets.
"""


import pandas as pd
import numpy as np
import re
import utility



"""
Transformation functions
"""



def is_valid_mobile_no (mobile_no):
    # Returns True/False
    # Validdates SG mobile number starts with 8 or 9 and has 8 digits
    return len(mobile_no) == 8 and (mobile_no[0] == '8' or mobile_no[0] == '9')



def clean_mobile_no (mobile_no):
    # Returns mobile number string after cleaning
    # Remove non-numeric chars and spaces
    mobile_no = mobile_no.replace(r'[^0-9]+', '')
    # Remove SG country code if any +65 or 0065
    if len(mobile_no) == 10 and mobile_no[0:2] == '65':
        mobile_no = mobile_no[2:]
    elif len(mobile_no) == 12 and mobile_no[0:4] == '0065':
        mobile_no = mobile_no[4:]
    return mobile_no



def is_valid_email (email):
    # Returns True/False
    # Checks if emai domain and suffix is valid

    # Regex to check valid email suffix according to requirement
    regex = "((?!-)[A-Za-z0-9-]" + "{1,63}(?<!-)\\.)" + "+(?:com|net)$"
    match = re.search(regex, email)
    if match != None:
        return True
    return False



def is_above_18 (dob):
    # Returns True/False
    # Checks if age is above 18 as of 1 Jan 2022 based on given DOB
    delta = np.datetime64('2022-01-01') - dob
    return ( delta / np.timedelta64(1, 'Y') ) > 18



def do_transformation (csv_path):
    # Returns a dataframe after transformation
    # Takes in the path to CSV dataset
   
   
    # Read all csv fields as string object 
    df  = pd.read_csv(csv_path, dtype=object)

    # Strip spaces in values of every field
    for column in df:
        df[column] = df[column].str.strip()

   
    # Clean mobile number
    df['mobile_no'] = df['mobile_no'].apply(lambda x: clean_mobile_no(x))

    # Validate mobile number
    df['is_valid_mobile_no'] = df['mobile_no'].apply(lambda x: is_valid_mobile_no(x))
   
   
    # Validate email
    df['is_valid_email'] = df['email'].apply(lambda x: is_valid_email(x))
    
    
    # Convert dob to numpy datetime64 data type
    df['dob_converted'] = df['date_of_birth'].apply( lambda x: utility.convert_to_datetime(x) )

    # Convert to string in YYYY-MM-DD format
    df['date_of_birth'] = np.datetime_as_string( df['dob_converted'], unit='D')
    # Remove hyphen (YYYYMMDD)
    df['date_of_birth'] = df['date_of_birth'].apply( lambda x: x.replace('-', '') )
    
    
    # Check if >18 years old as of 1 Jan 2022
    df['above_18'] = df['dob_converted'].apply( lambda x: is_above_18(x) )
    
    
    # Finally return dataframe
    return df




if __name__ == "__main__":
    
    df = do_transformation('~/Downloads/applications_dataset_1.csv')
    print(df)
