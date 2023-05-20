#!/usr/bin/env python3


"""
Python script to perform ETL for 2 datasets.
"""


import pandas as pd
import numpy as np
import re
import utility



execution_date_hour = np.datetime_as_string(np.datetime64('today', 'h'))



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



def split_name (name):
    # Returns spli name tuple (first_name, last_name)
    
    if name == None:
        return (None, None)
    
    # Checks if first part of name has non-alphabet char suggesting name prefix
    # Like Mr., Dr., etc
    def has_non_alpha_in_first_part (name):
        first_part = name.split(' ')[0]
        matches = re.findall("[^A-Za-z ]",first_part)
        res = len(matches) > 0
        return res

    def split_name_with_prefix (name):
        # Split and get everything within first 2 spaces for first name, rest is last name
        split_name = name.split(" ", 2)
        # To remove prefix like Mr. Mrs. Dr. etc, use split_name[1] for first name
        return ( ' '.join(split_name[:-1]), split_name[-1] )

    def split_name_without_prefix (name):
        # Split and get everything within first 1 space for first name, rest is last name
        split_name = name.split(" ", 1)
        return ( split_name[0], split_name[-1] )

    if has_non_alpha_in_first_part(name) == True:
        return split_name_with_prefix(name) 
    else:
        return split_name_without_prefix(name)



def do_transformation (csv_path):
    # Returns a dataframe after transformation
    # Takes in the path to CSV dataset
   
   
    # Read all csv fields as string object 
    df  = pd.read_csv(csv_path, dtype=object)

    # Strip spaces in values of every field
    for column in df:
        df[column] = df[column].str.strip()

   
    # Convert Null or NaN names to None
    df['name'].where(pd.notnull(df['name']), None)
    
    
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
    
    
    # Split name
    df['split_name'] = df['name'].apply( lambda x: split_name(x) )
    df['first_name'], df['last_name'] = zip(*df.split_name)
    
    
    # Check if valid applicant
    df['is_valid_applicant'] = df.apply( 
        lambda row: row['is_valid_mobile_no'] and row['above_18'] and row['is_valid_email'] and row['last_name'] != None
        , axis=1 )
    
    
    # Construct member ID
    df['member_id'] = df.apply(
            lambda row: 
                row['last_name'] + '_' + utility.calculate_hash(row['date_of_birth'])[0:5] if row['is_valid_applicant'] == True 
                else None
            , axis=1)
    
    
    df_successful = df[~df['member_id'].isnull()]
    # Select subset of columns for successful applications
    df_successful = df_successful[['first_name', 'last_name', 'email', 'date_of_birth', 'mobile_no', 'above_18', 'member_id']]
    
    df_unsuccessful = df[df['member_id'].isnull()]
    
    return df_successful, df_unsuccessful



if __name__ == "__main__":
    
    df1_successful, df1_unsuccessful = do_transformation('~/Downloads/applications_dataset_1.csv')
    df2_successful, df2_unsuccessful = do_transformation('~/Downloads/applications_dataset_2.csv')
    
    df_successful = pd.concat([df1_successful, df2_successful])
    df_unsuccessful = pd.concat([df1_unsuccessful, df2_unsuccessful])
    
    df_successful.to_csv("./applications_successful/applications_{}.csv".format(execution_date_hour), index=False)
    df_unsuccessful.to_csv("./applications_unsuccessful/applications_{}.csv".format(execution_date_hour), index=False)
