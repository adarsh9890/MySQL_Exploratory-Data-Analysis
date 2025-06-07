-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
From layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company,sum(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 desc;     -- instead of using the column name we can also use its index for sorting in this it sort by total_laid_of,because it is the second column

SELECT industry,sum(total_laid_off)
FROM layoffs_staging2
group by industry
order by 2 desc;

SELECT country,sum(total_laid_off)
FROM layoffs_staging2
group by country
order by 2 desc;

select min(date),max(date)
from layoffs_staging2;

SELECT year(`date`),(total_laid_off)
FROM layoffs_staging2
group by year(`date`)
order by 2 desc;

select substring(`date`,1,7) as `year`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `year`
order by 1 asc;

WITH Rolling_Total as
(
select substring(`date`,1,7) as `year`,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `year`
order by 1 asc
)
select `year`,total_off,sum(total_off) over (order by `year`) as rolling_total
from Rolling_Total;

select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`);

with company_year(company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),
company_year_rank as
(
select*,dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select*
from company_year_rank
where Ranking <=5;









