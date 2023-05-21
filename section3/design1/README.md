# Database Access

- Database will be accessed by various employee teams.

- Role Based Access Control (RBAC) permissions will be used to allow access to individual employees in these teams.

- For each team, 2 roles will be created: `READ_ROLE` and `READ_WRITE_ROLE` .

- These 2 roles can be applied on a table level or 
column level.

- For instance, Sales team will have `READ` access to `orders` table, but can only `READ_WRITE` on certain columns.

- Please refer to [RBAC-Access.xlsx](https://github.com/msafiullah/Safi-GovTech-SeniorDETechAssessment-23/blob/main/section3/design1/RBAC-Access.xlsx) for detailed permission matrix.
