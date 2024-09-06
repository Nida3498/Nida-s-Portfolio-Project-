-- JOINS
-- JOIN allow you to combine 2 tables together  they have a common column.
SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;

-- INNER JOINS will return the rows that are the same from both tables and column

SELECT * 
FROM employee_demographics
INNER JOIN employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id
;

# We are missing employee_id 2 from employee_salary, and will not be brought over.

SELECT *
FROM employee_demographics AS dem
INNER JOIN	employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- Outer Joins
-- We have a left outer join and a right outer join
-- The left join will take everything from the left table and only return the matches from the right table. 


SELECT * 
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;


SELECT * 
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;
    
    
 -- Self Join
 -- You tie the table to itself.
 
 SELECT * 
 FROM employee_salary;
 
 SELECT *
 FROM employee_salary emp1
 JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id
;

 SELECT *
 FROM employee_salary emp1
 JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;


-- How to join multiple tables together
-- Joining multiple tables together


SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

SELECT * 
FROM parks_departments;

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    INNER JOIN parks_departments pd
		ON sal.dept_id = pd.department_id
	;