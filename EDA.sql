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
