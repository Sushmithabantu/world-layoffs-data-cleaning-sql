#  World Layoffs Data Cleaning Project (SQL)

## Project Overview
This project focuses on cleaning and preparing the **World Layoffs Dataset** using **MySQL**. The raw dataset contained duplicate records, inconsistent formatting, null values, and unnecessary columns. Using SQL, the data was cleaned and transformed into an analysis-ready dataset.

---

##  Tools & Technologies
- MySQL
- SQL
- Window Functions
- Common Table Expressions (CTEs)

---

##  Dataset Features
The dataset contains:
- Company Name
- Industry
- Total Employees Laid Off
- Percentage Laid Off
- Country
- Funding Raised
- Company Stage
- Date

---

#  Data Cleaning Process

## Removing Duplicate Records
Created staging tables to avoid modifying the original dataset directly.

Used `ROW_NUMBER()` with `PARTITION BY` to identify duplicate records.

```sql
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off,
percentage_laid_off, date, stage,
country, funds_raised_millions
) AS row_num
```

Deleted rows where `row_num > 1`.

---

##  Standardizing Data

###  Removed Extra Spaces
```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

###  Standardized Industry Names
```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

### Standardized Country Names
```sql
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';
```

###  Converted Date Format
```sql
UPDATE layoffs_staging2
SET date = STR_TO_DATE(date,'%m/%d/%Y');
```

Changed column datatype from TEXT to DATE.

---

##  Handling Null & Blank Values

###  Replaced Blank Values with NULL
```sql
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
```

### Filled Missing Industry Values Using Self Join
```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
```

###  Removed Unnecessary Null Records
Deleted rows where both:
- `total_laid_off`
- `percentage_laid_off`

were NULL.

---

##  Removing Unnecessary Columns

```sql
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
```

---

# SQL Concepts Used
- ROW_NUMBER()
- CTEs
- JOINS
- UPDATE
- DELETE
- ALTER TABLE
- WINDOW FUNCTIONS
- Data Standardization

---

#  Project Outcome
After cleaning:
- Duplicate records were removed
- Data became standardized and consistent
- Null values were handled properly
- Dataset became ready for analysis and visualization

---

#  Future Scope
- Exploratory Data Analysis (EDA)
- Power BI Dashboard Creation
- Layoff Trend Analysis
- Industry-wise Insights
- Country-wise Comparisons

---
#  Exploratory Data Analysis (EDA)

After cleaning the dataset, exploratory data analysis was performed using SQL to identify trends, patterns, and insights related to layoffs across companies, industries, countries, and years.

---

##  Key Analysis Performed

###  Maximum Layoffs & Layoff Percentage
```sql
SELECT MAX(total_laid_off),
MAX(percentage_laid_off)
FROM layoffs_staging2;
```

---

###  Companies with 100% Layoffs
```sql
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
```

---

###  Companies by Funds Raised
```sql
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
```

---

###  Total Layoffs by Company
```sql
SELECT company,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
```

---

###  Date Range of Dataset
```sql
SELECT MIN(date),
MAX(date)
FROM layoffs_staging2;
```

---

###  Total Layoffs by Industry
```sql
SELECT industry,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
```

---

###  Total Layoffs by Country
```sql
SELECT country,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
```

---

###  Year-wise Layoffs
```sql
SELECT YEAR(date),
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;
```

---

###  Layoffs by Company Stage
```sql
SELECT stage,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;
```

---

###  Monthly Layoff Trends
```sql
SELECT SUBSTRING(date,1,7) AS Month,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY Month
ORDER BY 1 ASC;
```

---

###  Rolling Total of Layoffs
```sql
WITH rolling_total AS (
SELECT SUBSTRING(date,1,7) AS Month,
SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY Month
ORDER BY 1 ASC
)

SELECT Month,
total_off,
SUM(total_off) OVER(ORDER BY Month) AS rolling_total
FROM rolling_total;
```

---

#  Insights Generated
- Identified companies with the highest layoffs
- Analyzed layoff trends across industries and countries
- Examined yearly and monthly layoff patterns
- Tracked cumulative layoffs over time using rolling totals
- Compared layoffs based on company stages and funding

---
