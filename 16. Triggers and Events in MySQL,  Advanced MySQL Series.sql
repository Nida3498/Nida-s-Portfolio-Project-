-- Triggers and Events
-- A trigger is a block of code that executes automatically when an event takes place on a specific table. 
-- For instance, if someone is put into the salary table we want it to automatically update within the demographics table.
-- The delimiter will help us have multiple queries within our create trigger statement.

SELECT *
FROM employee_demographics;

SELECT * 
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

-- REFRESH, Look under employee_salary table and you will find TRIGGERS.employee_insert

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation,
salary, dept_id)
VALUES(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

SELECT * 
FROM employee_salary;

SELECT *
FROM employee_demographics;

-- A trigger happens when an event takes place.
-- An event takes place when it is scheduled.
-- EVENTS
-- A scheduled automator.
-- USE CASE - when you are importing data you can pull data from a specific file path on a schedule, 
-- you can build reports that are exported to a file on a schedule. 
-- USEFUL for automation


-- A company wants to retire employees over the age of 60 and give them lifetime pay.
-- Create an event that checks it every day and if they are over a certain age they will be deleted from the table and they will be retired. 


SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ; 


SELECT *
FROM employee_demographics;

SHOW VARIABLES LIKE 'event%';

-- EDIT, PREFERENCES, SQL EDITOR, SAFE UPDATES should be unchecked.
