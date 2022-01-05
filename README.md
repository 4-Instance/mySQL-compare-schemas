# mySQL-compare-schemas
A simple SQL script that you can tailor to compare two schemas on the same database. This is meant as a cross-check from a move from DEV to UAT. It does not create a difference script. This should be done as a part of ongoing best development practice. 

I recommend MySQLWorkbence to design the database and generate diffs files.

There are two main scripts database_diff that will do a simple compare to look for differences between a SOURCE and TARGET.

The second script is to see data differences within a reference tables. This can be modified to check your personal settings tables.
I have included a standard set of tables I use to store settings and domains.

A simple settings table:
CREATE TABLE `reference` (
  `ref_id` int(11) NOT NULL AUTO_INCREMENT,
  `ref_description` varchar(45) NOT NULL,
  `ref_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ref_id`));

ref_id  ref_description
5	      Country	


A more detailed table to allow multiple values to be stored against a settion
CREATE TABLE `reference_list` (
  `rfl_id` int(11) NOT NULL AUTO_INCREMENT,
  `rfl_ref_id` int(11) NOT NULL,
  `rfl_description` varchar(255) NOT NULL,
  `rfl_value` varchar(45) NOT NULL,
  PRIMARY KEY (`rfl_id`),
  KEY `FK_RFL_REF_IDX` (`rfl_ref_id`),
  CONSTRAINT `FK_FRL_REF_ID` FOREIGN KEY (`rfl_ref_id`) REFERENCES `reference` (`ref_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

rfl_id  rfl_ref_id  rfl_description rfl_value
27	    5         	UK	            UK
67	    5	          USA	            USA
68	    5	          GERMANY	        GERMANY
69	    5	          FRANCE	        FRANCE
70	    5	          JAPAN	          JAPAN
71	    5	          ITALY	          ITALY
