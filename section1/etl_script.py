#!/usr/bin/env python3


"""
Python script to perform ETL for 2 datasets.
"""


import pandas as pd
import numpy as np



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
   
   
    
    # Finally return dataframe
    return df




if __name__ == "__main__":
    
    df = do_transformation('~/Downloads/applications_dataset_1.csv')
    print(df)
