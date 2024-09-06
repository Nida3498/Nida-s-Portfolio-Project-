-- Limit & Aliasing

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_demographics
LIMIT 3;

# Order by the oldest
SELECT * 
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;


SELECT * 
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1; # Start at position 2 which is at the age column for Donna and end at Leslie.


-- Aliasing - Changing the name of the column

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;


SELECT gender, AVG(age) avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;