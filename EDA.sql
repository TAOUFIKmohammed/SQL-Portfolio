-- EDA

-- Here we are jsut going to explore the data

ALTER TABLE layoffs_staging2
MODIFY total_laid_off INT;

SELECT MAX(total_laid_off)
FROM layoffs_staging2;
