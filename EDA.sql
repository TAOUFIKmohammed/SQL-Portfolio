-- EDA (Exploratory Data Analysis)

-- Here we are jsut going to explore the data

-- total_laid_off is a string, so to calculate MAX we had firstly change it to INT

ALTER TABLE layoffs_staging2
MODIFY total_laid_off INT;

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

--Now for let's check how much the total of total_laid_off in each company or the company wich had so much total_laid_off

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

--the industry wich had teh biggest total_laid_off

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Now to have the year that we can find the most total_laid off

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;

-- to know the cumulate of the total laid off over the years we have to create a CTE and use a window function

WITH base_data AS (
  SELECT YEAR(date) AS year_1, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE YEAR(date) IS NOT NULL
  GROUP BY year_1
  ORDER BY 1 DESC
)

SELECT year_1, total_off, SUM(total_off) OVER (ORDER BY year_1) AS rolling_total
FROM base_data;

-- Now let's see the ranking of companies that laid off the most people in each year

WITH company_year AS(
  SELECT company, YEAR(date) AS year_1, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE YEAR(date) IS NOT NULL
  GROUP BY company, YEAR(date)
  ORDER BY 3 DESC
), Ranking_company AS (
  SELECT *, DENSE_RANK() OVER(PARTITION BY year_1 ORDER BY total_off DESC) AS Ranking
  FROM company_year
  /*WHERE year_1 = 2023*/
  )
SELECT *
FROM Ranking_company

