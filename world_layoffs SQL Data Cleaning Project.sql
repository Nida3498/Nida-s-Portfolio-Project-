-- Data Cleaning


-- 1. Remove Duplicates
-- 2. Standardize the data (Spelling Issues)
-- 3. Null Values or blank values (See if we can poplulate the data)
-- 4. Remove any Columns (unnecessary rows or columns)

SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE world_layoffs.layoff_staging
LIKE world_layoffs.layoffs;

SELECT *
FROM world_layoffs.layoff_staging;

SELECT * FROM world_layoffs.layoffs;

INSERT world_layoffs.layoff_staging
SELECT * 
FROM world_layoffs.layoffs;

SELECT * 
FROM world_layoffs.layoff_staging;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoff_staging;



WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoff_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM world_layoffs.layoff_staging
WHERE company = 'Oda';


SELECT * 
FROM world_layoffs.layoff_staging
WHERE company = 'Casper'; 
-- Casper has 2 duplicates so we need to remove one row

-- Create another table and delete the row_num that has a value of 2

-- Go to layoffs_staging- Copy to Clipboard and then Create Statement

CREATE TABLE `world_layoffs`.`layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM world_layoffs.layoff_staging2;

INSERT INTO world_layoffs.layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,
industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoff_staging;

SELECT *
FROM world_layoffs.layoff_staging2;

SELECT *
FROM world_layoffs.layoff_staging2
WHERE row_num > 1;
-- This statement is displaying how to delete the row_num column that has a value of 2. 
DELETE 
FROM world_layoffs.layoff_staging2
WHERE row_num > 1;
-- THis will show you the data that was deleted from row_num that had the values 2.
SELECT *
FROM world_layoffs.layoff_staging2
WHERE row_num > 1;


SELECT *
FROM world_layoffs.layoff_staging2;

-- Standardizing Data - Finding issues in your data and fixing it.
-- Take a look at Company and do a trim. 

-- This displays the unique companies from the layoff_staging2 dataset. 
SELECT DISTINCT(company)
FROM world_layoffs.layoff_staging2;
-- This will trim the companies in the dataset.

SELECT company,TRIM(company)
FROM world_layoffs.layoff_staging2;

-- Make sure you go to Edit-> Preferences-> SQL Editor-> Make sure the field safe updates is untoggled.

UPDATE world_layoffs.layoff_staging2
SET company = TRIM(company); 

SELECT company,TRIM(company)
FROM world_layoffs.layoff_staging2;

-- Take a look at the Industry column
SELECT industry
FROM world_layoffs.layoff_staging2;

-- There are a ton of industries
-- Do a Distinct to find all of the UNIQUE industries
SELECT DISTINCT industry
FROM world_layoffs.layoff_staging2
ORDER BY 1;

-- Crypto and Cyrpto Currency are the same industries so we will need to fix that. 

SELECT *
FROM world_layoffs.layoff_staging2
WHERE industry LIKE 'Crypto%';

-- Update Crypto% to Crypto
UPDATE world_layoffs.layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; 


SELECT DISTINCT industry
FROM world_layoffs.layoff_staging2
ORDER BY 1;

-- Take a look at location
SELECT *
FROM world_layoffs.layoff_staging2;

SELECT DISTINCT location
FROM world_layoffs.layoff_staging2
ORDER BY 1;

-- Take a look at Country (United States has a period at the end.) update
SELECT *
FROM world_layoffs.layoff_staging2;

SELECT DISTINCT country
FROM world_layoffs.layoff_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM world_layoffs.layoff_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT *
FROM world_layoffs.layoff_staging2
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoff_staging2
ORDER BY 1;

UPDATE world_layoffs.layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoff_staging2
ORDER BY 1;

-- The date needs to be updated, right now it is text column.

SELECT *
FROM world_layoffs.layoff_staging2;


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoff_staging2;

UPDATE world_layoffs.layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `Date`
FROM world_layoffs.layoff_staging2;

-- Change the Date to a Date
ALTER TABLE world_layoffs.layoff_staging2
MODIFY COLUMN `Date` DATE; 

SELECT *
FROM world_layoffs.layoff_staging2;

-- REMOVE Null and blank values

-- Take a look at the Total_Laid_off column

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE total_laid_off IS NULL; 

-- IF they have two nulls then we should remove those rows.

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 


SELECT *
FROM world_layoffs.layoff_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM world_layoffs.layoff_staging2
WHERE company = 'Airbnb';

-- So Airbnb has an industry of Travel so we can update that. Let's update it. 
-- We have to do a join.

SELECT * 
FROM world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 

-- Take a look at the industry
SELECT t1.industry, t2.industry
FROM world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 

-- Do an update and set
UPDATE world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- So we need to set the industry blanks to NULL to see if that works
UPDATE world_layoffs.layoff_staging2
SET INDUSTRY = NULL
WHERE INDUSTRY = '';

SELECT t1.industry, t2.industry
FROM world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 

UPDATE world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM world_layoffs.layoff_staging2 t1
JOIN world_layoffs.layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE company = 'Airbnb'; 

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE company LIKE 'Bally%'; 

SELECT * 
FROM world_layoffs.layoff_staging2;

-- How to remove columns and rows

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- How to delete this data where Total_laid_off and Percentage_laid_off is NULL

DELETE
FROM world_layoffs.layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- The Total Laid Off and Percentage Laid Off columns that had Null values have been deleted. 

SELECT * 
FROM world_layoffs.layoff_staging2;

-- We can delete the row_num column. 
-- We need to use Alter Table to remove row_num.alter

ALTER TABLE world_layoffs.layoff_staging2
DROP COLUMN row_num;


SELECT * 
FROM world_layoffs.layoff_staging2;


-- Just a recap. 
-- We removed duplicates, standardized the data, removed a few null values or blanks, and removed the Row_num column. 
-- The end. 9-1-2025 


-- Exploratory Data Analysis

SELECT * 
FROM world_layoffs.layoff_staging2;

-- We will be working with Total_laid_off columns and Percentage_laid_off

-- This displays the companies maximum total laid off people.
SELECT MAX(total_laid_off) 
FROM world_layoffs.layoff_staging2;
-- The maximum number of people to be laid off in Jan-23 was 12,000 people. 


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoff_staging2;

SELECT *
FROM world_layoffs.layoff_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM world_layoffs.layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; 


SELECT *
FROM world_layoffs.layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company
ORDER BY 2;


SELECT MIN(`date`), MAX(`date`)
FROM world_layoffs.layoff_staging2;


SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY industry
ORDER BY 2;
-- Which industry got impacted the most during the date range of 3/20 thru 3/23. Consumer and Retail got impacted the most.

SELECT *
FROM world_layoffs.layoff_staging2;

-- Take a look at the country that had the most laid off.
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY country
ORDER BY 2;
-- It looks like United States had most lay offs. 

SELECT `date`, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY `date`
ORDER BY 2;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
-- In 2020, 80,998 people were laid off from their jobs. 


SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Let's take a look at percentages
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company
ORDER BY 2 DESC;


-- You can take a look at the progression of a rolling sum
-- Rolling total based off the month
SELECT SUBSTRING(`date`,6,2) AS 'MONTH', SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY SUBSTRING(`date`,6,2);

SELECT SUBSTRING(`date`,6,2) AS 'MONTH', SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY MONTH;
-- This displays the rolling totals by month.

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC; 
-- All of the layoffs of 3/202 which is a totla 0f 9,628.
-- We will do a rolling sum. 


With Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM world_layoffs.layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total; 

-- We would add the totals to each row, and we added the total_off column so we can visually see what is occurring with the rolling total.alter
-- We have the month and as we go down we have more lay offs.
-- This shows a month by month progression.


SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- How much were the companies laying off by year. 

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

-- We want to rank which year companies laid off the most people

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years,total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
)
SELECT * 
FROM 
Company_Year;

-- Let's partition it based on by Years and rank it by how many they laid off that year. 
-- We can see who laid off the most people that year. 

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years,total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM 
Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


-- Lets filter it where ranking is limited to 5
WITH Company_Year (company, years,total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM 
Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank;


WITH Company_Year (company, years,total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoff_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM 
Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;


-- This displays the top 5 companies by year that laid off people.
-- We created the query and looked at company by year and total laid off people.
-- Next, we created our first CTE, and then gave it a rank as another CTE, and then we queried off the final CTE. 
-- We performed exploratory data analysis and looked at how many people were laid off by month, rolling totals, and CTEs. 


