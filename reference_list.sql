/* 
** Reference table
*/
SELECT
	'REFERENCE' object_type,
   concat('Only in ',@source_db) exist_type,
  c1.ref_id, c1.ref_description, c1.ref_value
FROM
  (SELECT * FROM DEV.reference) c1
  LEFT JOIN 
  (SELECT * FROM UAT.reference) c2
    ON 	c1.ref_id = c2.ref_id
    AND c1.ref_description = c2.ref_description
    AND (c1.ref_value = c2.ref_value or c2.ref_value is null)
where c2.ref_id is null
UNION ALL
select
	'REFERENCE' object_type,
  concat('Only in ',@target_db) exist_type,
  c1.ref_id, c1.ref_description, c1.ref_value
FROM
  (SELECT * FROM UAT.reference) c1
  LEFT JOIN 
  (SELECT * FROM DEV.reference) c2
    ON 	c1.ref_id = c2.ref_id
    AND c1.ref_description = c2.ref_description
    AND (c1.ref_value = c2.ref_value or c2.ref_value is null)
where c2.ref_id is null
    order by ref_id,ref_description;
    
    SELECT
	'REFERENCE_LIST' object_type,
   concat('Only in ',@source_db) exist_type,
  c1.rfl_id, c1.rfl_ref_id, c1.rfl_description, c1.rfl_value
FROM
  (SELECT * FROM DEV.reference_list) c1
  LEFT JOIN 
  (SELECT * FROM UAT.reference_list) c2
    ON 	c1.rfl_id = c2.rfl_id
    AND c1.rfl_ref_id = c2.rfl_ref_id
    AND c1.rfl_description = c2.rfl_description
    AND (c1.rfl_value = c2.rfl_value or c2.rfl_value is null)
where c2.rfl_id is null
UNION ALL
select
	'REFERENCE_LIST' object_type,
  concat('Only in ',@target_db) exist_type,
  c1.rfl_id, c1.rfl_ref_id, c1.rfl_description, c1.rfl_value
FROM
  (SELECT * FROM UAT.reference_list) c1
  LEFT JOIN 
  (SELECT * FROM DEV.reference_list) c2
    ON 	c1.rfl_id = c2.rfl_id
    AND c1.rfl_ref_id = c2.rfl_ref_id
    AND c1.rfl_description = c2.rfl_description
    AND (c1.rfl_value = c2.rfl_value or c2.rfl_value is null)
where c2.rfl_id is null
    order by rfl_id,rfl_ref_id,rfl_description;