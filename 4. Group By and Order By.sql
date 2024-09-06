-- GROUP By

SELECT * 
FROM employee_demographics;

SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT first_name # This has to have gender or an aggregate function if we are grouping by gender.
FROM employee_demographics
GROUP BY gender; # This will not work


SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_demographics;

# We want to select the average age by gender
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_salary;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;


SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;


-- ORDER BY 
-- This will sort your data in ascending order or descending order.

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_demographics
ORDER BY first_name ASC; # This will sort the first_name column in ascending order a-z or smallest to largest


SELECT * 
FROM employee_demographics
ORDER BY first_name DESC; # This will sort the first_name column in descending order from z-a or largest to smallest.


SELECT * 
FROM employee_demographics
ORDER BY gender;

SELECT * 
FROM employee_demographics
ORDER BY gender DESC;

SELECT * 
FROM employee_demographics
ORDER BY gender, age;

SELECT * 
FROM employee_demographics
ORDER BY age, gender;

SELECT * 
FROM employee_demographics
ORDER BY gender, age DESC;

SELECT * 
FROM employee_demographics
ORDER BY birth_date;

SELECT * 
FROM employee_demographics
ORDER BY 5,4;

SELECT * 
FROM employee_demographics
ORDER BY employee_id;

SELECT * 
FROM employee_demographics;

