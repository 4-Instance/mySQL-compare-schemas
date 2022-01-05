/*
** Compare database schemas
*/
SET @source_db = 'DEV';
SET @target_db = 'UAT';

SELECT *
FROM
(SELECT 
	'COLUMNS' object_type,
  'Only in source' exist_type,
  c1.table_schema, c1.table_name, c1.column_name, c1.column_type, c1.ordinal_position, c1.column_default, c1.is_nullable, c1.numeric_precision, c1.numeric_scale, c1.character_set_name, c1.collation_name, c1.column_key, c1.extra, c1.column_comment
FROM
  (SELECT * 
FROM information_schema.columns WHERE TABLE_SCHEMA = @source_db) c1
  LEFT JOIN 
  (SELECT * FROM information_schema.columns WHERE TABLE_SCHEMA = @target_db) c2
    ON 	c1.TABLE_name = c2.TABLE_name 
    AND c1.column_name = c2.column_name    
    AND ( c1.column_default = c2.column_default or c2.column_default is null )
    AND c1.is_nullable = c2.is_nullable
    AND ( c1.numeric_precision = c2.numeric_precision or c2.numeric_precision is null)
    AND ( c1.numeric_scale = c2.numeric_scale or c2.numeric_scale is null)
    AND c1.column_type = c2.column_type
    AND c1.column_key = c2.column_key 
WHERE c2.column_name is null
UNION ALL
SELECT
	'COLUMNS' object_type,
  'Only in target' exist_type,
  c2.table_schema, c2.table_name, c2.column_name, c2.column_type, c2.ordinal_position, c2.column_default, c2.is_nullable, c2.numeric_precision, c2.numeric_scale, c2.character_set_name, c2.collation_name,c2.column_key, c2.extra, c2.column_comment
FROM
  (SELECT * FROM information_schema.columns WHERE TABLE_SCHEMA = @source_db) c1
  RIGHT JOIN 
  (SELECT * FROM information_schema.columns WHERE TABLE_SCHEMA = @target_db) c2
    ON 	c1.TABLE_name = c2.TABLE_name 
    AND c1.column_name = c2.column_name
    AND ( c1.column_default = c2.column_default or c2.column_default is null )
    AND c1.is_nullable = c2.is_nullable
    AND ( c1.numeric_precision = c2.numeric_precision or c2.numeric_precision is null)
    AND ( c1.numeric_scale = c2.numeric_scale or c2.numeric_scale is null)
    AND c1.column_type = c2.column_type
    AND c1.column_key = c2.column_key   
WHERE c1.column_name is null) RESULT where table_name not like 'v_%' order by table_name,column_name;  
/*
** Views check
*/
SELECT
	'VIEWS' object_type,
  'Only in target' exist_type,
  c1.table_name, c1.view_definition
FROM
  (SELECT * FROM information_schema.VIEWS WHERE TABLE_SCHEMA = @source_db) c1
  LEFT JOIN 
  (SELECT * FROM information_schema.VIEWS WHERE TABLE_SCHEMA = @target_db) c2
    ON  c1.TABLE_name = c2.TABLE_name 
    AND REPLACE(c1.view_definition,@source_db,'DATABASE') = REPLACE(c2.view_definition,@target_db,'DATABASE')
WHERE c2.table_name is null
UNION ALL
SELECT
	'VIEWS' object_type,
  'Only in source' exist_type,
  c2.table_name, c2.view_definition
FROM
  (SELECT * FROM information_schema.VIEWS WHERE TABLE_SCHEMA = @source_db) c1
  RIGHT JOIN 
  (SELECT * FROM information_schema.VIEWS WHERE TABLE_SCHEMA = @target_db) c2
    ON c1.TABLE_name = c2.TABLE_name AND REPLACE(c1.view_definition,@source_db,'DATABASE') = REPLACE(c2.view_definition,@target_db,'DATABASE')
WHERE c1.table_name is null;
/*
** Routines
*/
SELECT
	'ROUTINES' object_type,
  concat('Only in ',@source_db) exist_type,
  c1.ROUTINE_NAME, c1.ROUTINE_TYPE, c1.data_type, c1.routine_definition
FROM
  (SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @source_db) c1
  LEFT JOIN 
  (SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @target_db) c2
    ON 	c1.ROUTINE_NAME = c2.ROUTINE_NAME
    AND c1.ROUTINE_TYPE = c2.ROUTINE_TYPE
    AND c1.data_type = c2.data_type
    AND c1.ROUTINE_DEFINITION = c2.ROUTINE_DEFINITION
WHERE c2.ROUTINE_NAME is null
UNION ALL
SELECT
	'ROUTINES' object_type,
  concat('Only in ',@target_db) exist_type,
  c2.ROUTINE_NAME, c2.ROUTINE_TYPE,  c2.data_type, c2.routine_definition
FROM
  (SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @source_db) c1
  RIGHT JOIN 
  (SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @target_db) c2
    ON 	c1.ROUTINE_NAME = c2.ROUTINE_NAME
    AND c1.ROUTINE_TYPE = c2.ROUTINE_TYPE
    AND c1.data_type = c2.data_type
    AND c1.ROUTINE_DEFINITION = c2.ROUTINE_DEFINITION
WHERE c1.ROUTINE_NAME is null
order by ROUTINE_NAME, EXIST_TYPE;

