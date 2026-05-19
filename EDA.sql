CREATE DATABASE World_layoffs;
USE World_layoffs;
SELECT * FROM layoffs;
-- Exploratory Data Analysis
SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1 ORDER BY total_laid_off DESC;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1 ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)  FROM layoffs_staging2;

SELECT industry,SUM(total_laid_off) FROM layoffs_staging2 GROUP BY industry ORDER BY 2 DESC;

SELECT country,SUM(total_laid_off) FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off) FROM layoffs_staging2 GROUP BY YEAR(`date`) ORDER BY 1 DESC;

SELECT stage,SUM(total_laid_off) FROM layoffs_staging2 GROUP BY stage ORDER BY 1 DESC;

SELECT company,SUM(percentage_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,6,2) AS `Month`,SUM(total_laid_off) FROM layoffs_staging2 GROUP BY SUBSTRING(`date`,6,2);

SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off) FROM layoffs_staging2
 where SUBSTRING(`date`,1,7)  GROUP BY `Month` ORDER BY 1 ASC;
 
WITH rolling_Total AS (
SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off) AS total_off FROM layoffs_staging2
 where SUBSTRING(`date`,1,7)  GROUP BY `Month` ORDER BY 1 ASC)
 SELECT `Month`,total_off,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total FROM rolling_Total;

