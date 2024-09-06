-- String Functions
-- These are built into MySQL 

SELECT LENGTH('skyfall');

SELECT *
FROM employee_demographics;

SELECT first_name, LENGTH(first_name)
FROM employee_demographics;

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT TRIM('       sky    ');
SELECT ('      sky    ');
SELECT LTRIM('            sky      ');
SELECT RTRIM('        sky   ');

SELECT *
FROM employee_demographics;

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4)
FROM employee_demographics;


SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2)
FROM employee_demographics;

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2),
birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

-- REPLACE 
SELECT *
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a','z')
FROM employee_demographics;

-- LOCATE

SELECT LOCATE('x','Alexander');

SELECT first_name, LOCATE('An',first_name)
FROM employee_demographics;

SELECT first_name, last_name
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_Name
FROM employee_demographics;



