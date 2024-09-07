-- Stored Procedures
-- They are a way to save your SQL code that you can reuse over an over again.
-- When you save it, you can call that store procedure and it's going to execute all the code that you wrote within your stored procedure.
-- Helpful for storing complex queries, simplifying repetitive code and enhancing performance.alter


SELECT *
FROM employee_salary;


SELECT * 
FROM employee_salary
WHERE salary >= 50000;


-- Create a stored procedure, refresh, and look under Stored Procedures

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();



-- Parameters are variables that are passed as an input into a stored procedure. 
-- They allow the stored procedure to accept an input value and place it into your code.

DELIMITER $$
CREATE PROCEDURE large_salaries4(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id
;
END $$
DELIMITER ;

CALL large_salaries4(1)