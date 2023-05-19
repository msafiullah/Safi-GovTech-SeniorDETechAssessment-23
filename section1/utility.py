#!/usr/bin/env python3

import hashlib
import datefinder
import datetime
from datetime import datetime as pydt
import re


def calculate_hash (str):
    return hashlib.sha256(str.encode('utf-8')).hexdigest()


def convert_to_datetime (str):
    if not str:
        return None

    # DEPRICATED MONTH PATTERN: ([janfebmrpulgsoctvdJANFEBMRPULGSOCTVD]{3})

    # Change ddmmmyy to dd mmm yy
    if len(str) == 7:
        str = re.sub(r'([0-3][0-9])([jfmasondJFMASOND][aepucoAEPUCO][nbrylgptvcNBRYLGPTVC])([0-9]{2})', r'\1 \2 \3', str)

    # Change dmmmyy to d mmm yy
    elif len(str) == 6:
        str = re.sub(r'([1-9])([jfmasondJFMASOND][aepucoAEPUCO][nbrylgptvcNBRYLGPTVC])([0-9]{2})', r'\1 \2 \3', str)

    # Change ddmmmyyyy to dd mmm yyyy
    elif len(str) == 9:
        str = re.sub(r'([0-3][0-9])([jfmasondJFMASOND][aepucoAEPUCO][nbrylgptvcNBRYLGPTVC])([0-9]{4})', r'\1 \2 \3', str)
    
    # Change dmmmyyyy to d mmm yyyy
    elif len(str) == 8:
        str = re.sub(r'([1-9])([jfmasondJFMASOND][aepucoAEPUCO][nbrylgptvcNBRYLGPTVC])([0-9]{4})', r'\1 \2 \3', str)


    # Use datefinder package to convert string to date
    dates = datefinder.find_dates(str, strict=True)
    for d in dates:
        if isinstance(d, datetime.datetime):
            return d

    # Determine and convert yyyymmdd or ddmmyyyy
    if len(str) != 8 or not str.isdigit():
        return None

    d = None
    try:
        # print "Trying to convert", str, "from yyyymmdd..."
        d = pydt.strptime(str, '%Y%m%d')
    except ValueError:
        try:
            # print "Trying to convert", str, "from ddmmyyyy..."
            d = pydt.strptime(str, '%d%m%Y')
        except ValueError:
            print ("WARNING: Cannot convert", str, "to datetime.")
    return d



