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
