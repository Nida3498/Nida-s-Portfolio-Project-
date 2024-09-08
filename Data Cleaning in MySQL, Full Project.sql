-- Data Cleaning

-- Import dataset named layoffs.csv

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns or Rows

-- Let's create a staging table from the raw data.

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Hit Refresh to view the layoffs_staging table that was created under Tables. 

SELECT * 
FROM layoffs_staging;

-- Now you will notice that you have all of the columns. 

INSERT layoffs_staging 
SELECT *
FROM layoffs;
 
-- The data has been inserted onto the layoffs_staging table. 

SELECT *
FROM layoffs_staging;

-- REMOVE DUPLICATES
-- Partition using every column

SELECT *
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging; 

-- Filter on the row_num column, if it has a 2 or above that means it has duplicates and that will be an issue. 

-- CREATE a CTE

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- This shows us the duplicates that we have since row_num = 2. We want to get rid of these duplicates. 

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- We have the company Casper that has one row that we want to keep and one row that is a duplicate. 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;


-- Go to layoffs_staging, right click-copy to clipboard, create statement, paste below,
-- create layofss_staging2 and add another column named `row_num` INT, copy and run

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;

-- Now we have a new column named row_num and now we can filter. 

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Now any row_num greater than 2 has been deleted. 

SELECT * 
FROM layoffs_staging2;

-- We will be removing row_num column at the end. 

-- STANDARDIZING DATA
-- Finding issues in your data and then fixing them.


-- Let's remove any spaces in the company column.

SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- TRIM removes whitespaces from a name

-- Let's take a look at the industry column.

SELECT industry
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- We have Crypto, Crypto Currency, and CryptoCurrency and we have to group them into one category. 
-- When we do EDA, if we did not group Crypto into one category they would be different categories. 

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2;

-- So far we have looked at company and industry. 
-- Let's take a look at location.

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- We found another issue, United States has another United States with a period after it, which we need to fix. 

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(country)
FROM layoffs_staging2
ORDER BY 1;

-- TRIM will not just fix this issue so we will use Trailing 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;


SELECT *
FROM layoffs_staging2;


-- If we want to do Timeseries or visualizations in exploratory data analysis, the date needs to be changed. 
-- Take a look at layoffs_staging2,columns, date. You will see that date is a text which is not good we need it to be a date column.

SELECT `date`
FROM layoffs_staging2;

-- We want to format date to month, date, year. We will use string to date.

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

-- Lets change the date column to date.

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Refresh the table, and now you will see that the date column has been changed to a date. 

SELECT * 
FROM layoffs_staging2;


-- Removing Null Values or Blank Values

-- Let's start off with the total_laid_off column

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- These rows that are NULL we may remove because they are useless to us. 

SELECT * 
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2;

-- The industry column had some missing values.
-- Lets find out which industry is Null or blank.

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Let's try to populate data that can be populated.

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Let's populate the company Airbnb where it has blank values for industry to Travel. 
-- We will try to do a join here.

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t1.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


-- We see travel, transportation, and consumer if we scroll right. This worked.

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Airbnb has the industry column populated to Travel.

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- We need to populate the industry for Bally's Interactive. 

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- There is only one Bally's Interactive company.

SELECT *
FROM layoffs_staging2;

-- We don't think it is possible to populate total_laid_off, percentage_laid_off, and funds_raised_millions columns.
-- If we had company totals we may have been able to populate them using calculations.

-- Removing Columns and Rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- Let's delete the row_num column.

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;
