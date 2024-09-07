-- Temporary Tables
-- These are tables that are only visible to the session that they are created in.
-- They are used for restoring intermediate results for complex queries.
-- Also used to manipulate Data before inserting into a more permanent table. 

CREATE TEMPORARY TABLE temp_table 
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freburg', 'Lord of the Rings: The Two Towers');

SELECT * 
FROM temp_table;


SELECT * 
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT * 
FROM salary_over_50k;

