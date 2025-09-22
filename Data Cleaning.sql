-- The purpuse of this project is CLEANING the data "layoffs"

-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens

-- The columns of the new table will be defined using this:
  
CREATE TABLE layoffs_staging
LIKE layoffs;

-- now to celan data, we had to follow these few steps :
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- Now we need to insert data into the new table

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Now we have all the data in the table layoffs_staging

SELECT *
FROM layoffs_staging;

-- 1. check for duplicates and remove any

--We create cte in order to use WHERE clause after the creating the row_num to identify duplicate values

WITH cte AS (
SELECT *, ROW_NUMBER() OVER( PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM cte
WHERE row_num > 1;

-- Now, let's create another staging table, layoffs_staging2, which includes the row_num column. This will allow us to remove duplicate records where row_num is greater than 1

CREATE TABLE layoffs_staging2 AS
SELECT *, ROW_NUMBER() OVER( PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- To delete all rows where row_num is greater than 1:
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- This gonna display no result
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

--So now we have the data without duplicate rows

-- 2. Standardize Data

--Remove spaces from both end of string company

SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

-- now let's see the industry column

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- we have two same industry 'Crypto' end 'CryptoCurrency' but they are the same
-- we had to standardize this

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 3. Look at null values and see what 
-- replace both empty strings and strings that are just spaces with NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '';

-- We recognize that we have some country that have a point at the end, so let's delete it like 'unitedstates' and 'unitedstates.'

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- now let's change the format of the date from string to date
-- But first we have to convert date = 'NULL' with the real NULL

UPDATE layoffs_staging2
SET date = NULL
WHERE date = 'NULL';

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

--We now recognize that some companies are assigned to an industry, while the same companies have blank or NULL values in the industry column

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

-- 4. remove any columns and rows that are not necessary
-- last thing to do is to delete the column wh had created row_num

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;











