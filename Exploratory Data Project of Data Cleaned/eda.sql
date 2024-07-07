-- exploratory data analysis


SELECT * 
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;


SELECT company, sum(total_laid_off) 
FROM layoffs_staging2
group by company
order by 2 desc;


SELECT min(`date`), max(`date`)
FROM layoffs_staging2;

SELECT industry, sum(total_laid_off) 
FROM layoffs_staging2
group by industry
order by 2 desc;

SELECT country, sum(total_laid_off) 
FROM layoffs_staging2
group by country
order by 2 desc;

SELECT month(`date`), sum(total_laid_off) 
FROM layoffs_staging2
group by month(`date`)
order by 2 desc;


SELECT stage, sum(total_laid_off) 
FROM layoffs_staging2
group by stage
order by 2 desc;

select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc;


with rolling_total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from rolling_total;

