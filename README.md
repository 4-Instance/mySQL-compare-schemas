# mySQL-compare-schemas
A simple SQL script that you can tailor to compare two schemas on the same database. This is meant as a cross-check from a move from DEV to UAT. It does not create a difference script. This should be done as a part of ongoing best development practice. 

The script requires access to MySQL information schema to work and any database you need to compare.

I recommend MySQLWorkbence to design the database and generate diffs files.

There are two main scripts database_diff that will do a simple compare to look for differences between a SOURCE and TARGET.

The second script is to see data differences within a reference tables. This can be modified to check your personal settings tables.
