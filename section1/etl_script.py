#!/usr/bin/env python3


"""
Python script to perform ETL for 2 datasets.
"""


import pandas as pd
import numpy as np
import re
import utility
import logging



execution_date_hour = np.datetime_as_string(np.datetime64('today', 'h'))


# Create a custom logger
logging.basicConfig(level = logging.DEBUG) # Change logging level to DEBUG, WARNING or INFO
logger = logging.getLogger(__name__)



"""
Transformation functions
"""



def is_valid_mobile_no (mobile_no):
    # Returns True/False
    # Validdates SG mobile number starts with 8 or 9 and has 8 digits
    res = len(mobile_no) == 8 and (mobile_no[0] == '8' or mobile_no[0] == '9')
    if res:
        logger.debug("[{}] is valid".format(mobile_no))
    else:
        logger.warning("[{}] is invalid".format(mobile_no))
    return res



def clean_mobile_no (mobile_no):
    # Returns mobile number string after cleaning
    # Remove non-numeric chars and spaces
    logger.debug("Original mobile number [{}]".format(mobile_no))
    mobile_no = mobile_no.replace(r'[^0-9]+', '')
    
    # Remove SG country code if any +65 or 0065
    if len(mobile_no) == 10 and mobile_no[0:2] == '65':
        logger.warning("Remove 65 from [{}]".format(mobile_no))
        mobile_no = mobile_no[2:]
        logger.warning("After removing 65, [{}]".format(mobile_no))
    elif len(mobile_no) == 12 and mobile_no[0:4] == '0065':
        logger.warning("Remove 0065 from [{}]".format(mobile_no))
        mobile_no = mobile_no[4:]
        logger.warning("After removing 0065, [{}]".format(mobile_no))
        
    logger.debug("Processed mobile number [{}]".format(mobile_no))
    return mobile_no



def is_valid_email (email):
    # Returns True/False
    # Checks if emai domain and suffix is valid

    # Regex to check valid email suffix according to requirement
    regex = "((?!-)[A-Za-z0-9-]" + "{1,63}(?<!-)\\.)" + "+(?:com|net)$"
    match = re.search(regex, email)
    if match != None:
        logger.debug("[{}] is valid email".format(email))
        return True
        
    logger.warning("[{}] is invalid email".format(email))
    return False



def is_above_18 (dob):
    # Returns True/False
    # Checks if age is above 18 as of 1 Jan 2022 based on given DOB
    delta = np.datetime64('2022-01-01') - dob
    age = ( delta / np.timedelta64(1, 'Y') )
    logger.debug("DOB [{}] is [{}] years as of 1 Jan 2022".format(dob, age))
    return age > 18



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
        if res:
            logger.warning("[{}] has non alphabet chars in first part [{}] of name: {}".format(name, first_part, matches))
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
        res = split_name_with_prefix(name)
        logger.debug("[{}] is to be split considering prefix in name into: {}".format(name, res))
        return res
    else:
        res = split_name_without_prefix(name)
        logger.debug("[{}] is to be split without considering prefix in name into: {}".format(name, res))
        return res



def do_transformation (csv_path):
    # Returns a dataframe after transformation
    # Takes in the path to CSV dataset
   
    logger.info("Processing CSV: {}".format(csv_path))
   
    # Read all csv fields as string object 
    df  = pd.read_csv(csv_path, dtype=object)

    # Strip spaces in values of every field
    logger.info("Strip spaces in all fields")
    for column in df:
        df[column] = df[column].str.strip()

   
    # Convert Null or NaN names to None
    logger.info("Convert Null or NaN names to None")
    df['name'].where(pd.notnull(df['name']), None)
    
    
    # Backup original mobile number column
    df['mobile_no_orig'] = df['mobile_no']
    
    # Clean mobile number
    logger.info("Clean mobile number")
    df['mobile_no'] = df['mobile_no'].apply(lambda x: clean_mobile_no(x))

    # Validate mobile number
    logger.info("Validate mobile number")
    df['is_valid_mobile_no'] = df['mobile_no'].apply(lambda x: is_valid_mobile_no(x))
   
   
    # Validate email
    logger.info("Validate email")
    df['is_valid_email'] = df['email'].apply(lambda x: is_valid_email(x))
    
    
    # Backup original dob column
    df['date_of_birth_orig'] = df['date_of_birth']
    
    # Convert dob to numpy datetime64 data type
    logger.info("Convert dob to numpy datetime64 data type")
    df['dob_converted'] = df['date_of_birth'].apply( lambda x: utility.convert_to_datetime(x) )

    logger.info("Convert dob to YYYYMMDD")
    # Convert to string in YYYY-MM-DD format
    df['date_of_birth'] = np.datetime_as_string( df['dob_converted'], unit='D')
    # Remove hyphen (YYYYMMDD)
    df['date_of_birth'] = df['date_of_birth'].apply( lambda x: x.replace('-', '') )
    
    
    # Check if >18 years old as of 1 Jan 2022
    logger.info("Check if >18 years old as of 1 Jan 2022")
    df['above_18'] = df['dob_converted'].apply( lambda x: is_above_18(x) )
    
    
    # Split name
    logger.info("Split name")
    df['split_name'] = df['name'].apply( lambda x: split_name(x) )
    df['first_name'], df['last_name'] = zip(*df.split_name)
    
    
    # Check if valid applicant
    logger.info("Check if valid applicant")
    df['is_valid_applicant'] = df.apply( 
        lambda row: row['is_valid_mobile_no'] and row['above_18'] and row['is_valid_email'] and row['last_name'] != None
        , axis=1 )
    
    
    # Construct member ID
    logger.info("Construct member ID")
    df['member_id'] = df.apply(
            lambda row: 
                row['last_name'] + '_' + utility.calculate_hash(row['date_of_birth'])[0:5] if row['is_valid_applicant'] == True 
                else None
            , axis=1)
    
    
    logger.info("Split dataset into successful and unsuccessful applications")
    
    df_successful = df[~df['member_id'].isnull()]
    # Select subset of columns for successful applications
    df_successful = df_successful[['first_name', 'last_name', 'email', 'date_of_birth', 'mobile_no', 'above_18', 'member_id']]
    
    df_unsuccessful = df[df['member_id'].isnull()]
    # Select original and new columns for unsuccessful applications
    df_unsuccessful = df_unsuccessful[['name', 'email', 'date_of_birth_orig', 'mobile_no_orig', 'first_name', 'last_name', 'date_of_birth', 'mobile_no', 'above_18']]
    
    logger.info("Done processing CSV: {}".format(csv_path))
    
    return df_successful, df_unsuccessful


def main (input_path_arr, successful_output_dir, unsuccessful_output_dir):
    # Takes in multiple paths for dataset CSVs
    # Returns consolidated and processed dataframes for successful and unsuccessful applications
    
    logger.info("Total of {} CSVs to be processed".format(len(input_path_arr)))
    
    # Store successful and unsuccessful application records for each dataset processed
    df_arr_successful = []
    df_arr_unsuccessful = []
    
    for each_dataset_path in input_path_arr:
        df_successful, df_unsuccessful = do_transformation(each_dataset_path)
        
        # Push processed results for this dataset to array
        df_arr_successful.append( df_successful )
        df_arr_unsuccessful.append( df_unsuccessful )

    
    # Merge dataframes
    df_merged_successful = pd.concat( df_arr_successful )
    df_merged_unsuccessful = pd.concat( df_arr_unsuccessful )
    
    
    # Write CSV outputs
    succ_output_path = successful_output_dir + "/applications_{}.csv".format(execution_date_hour)
    unsucc_output_path = unsuccessful_output_dir + "/applications_{}.csv".format(execution_date_hour)
    
    logger.info("Writing output CSVs to paths: [{}] and [{}]".format(succ_output_path, unsucc_output_path))
    
    df_merged_successful.to_csv( succ_output_path, index=False )
    df_merged_unsuccessful.to_csv( unsucc_output_path, index=False )



if __name__ == "__main__":

    input_csv_paths = ['~/Downloads/applications_dataset_1.csv', '~/Downloads/applications_dataset_2.csv']
    succ_output_dir = './applications_successful/'
    unsucc_output_dir = './applications_unsuccessful/'
    
    main(input_csv_paths, succ_output_dir, unsucc_output_dir)
    