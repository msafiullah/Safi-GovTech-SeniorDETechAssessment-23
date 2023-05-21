# Database Access

- Database will be accessed by various employee teams.

- Role Based Access Control (RBAC) permissions will be used to allow access to individual employees in these teams.

- For each team, 2 roles will be created: `READ_ROLE` and `READ_WRITE_ROLE` .

- These 2 roles can be applied on a table level or 
column level.

- For instance, Sales team will have `READ` access to `orders` table, but can only `READ_WRITE` on certain columns.

- Please refer to [RBAC-Access.xlsx](http://google.com) for detailed permission matrix.