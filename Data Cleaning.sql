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



