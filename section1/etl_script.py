#!/usr/bin/env python3


"""
Python script to perform ETL for 2 datasets.
"""


import pandas as pd
import numpy as np



"""
Transformation functions
"""



def do_transformation (csv_path):
    # Returns a dataframe after transformation
    # Takes in the path to CSV dataset
    
    df  = pd.read_csv(csv_path, dtype=object)

    # Strip spaces in values of every field
    for column in df:
        df[column] = df[column].str.strip()

    
    # Finally return dataframe
    return df




if __name__ == "__main__":
    
    df = do_transformation('~/Downloads/applications_dataset_1.csv')
    print(df)
