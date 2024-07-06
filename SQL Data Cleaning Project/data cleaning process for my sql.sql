-- data cleaning

-- 1. 	remove duplicates
-- 2.	standardize the data
-- 3.	check the null values
-- 4.	remove rows of columns that are not necessary


-- removing duplicates
 Select *
 from layoffs;
 
 Create Table layoffs_Staging
 like layoffs;

Select *
 from layoffs_staging;
 
 Insert layoffs_staging
 Select *
 from layoffs;
 
 Select *, 
 row_number() over( 
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
 with duplicate_cte as
 (
 Select *, 
 row_number() over( 
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging
 )
 
 select * 
 from duplicate_cte 
 where row_num > 1;
 
 Select *
 from layoffs_staging
 where company = 'Oda';
 
 with duplicate_cte as
 (
 Select *, 
 row_number() over( 
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging
 )
 
 delete 
 from duplicate_cte 
 where row_num > 1;
 
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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 select *
 from layoffs_staging2;
 
 insert into layoffs_staging2
 Select *, 
 row_number() over( 
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
  select *
 from layoffs_staging2
 where row_num > 1;
 
 
delete 
 from layoffs_staging2
 where row_num > 1;
 
   select *
 from layoffs_staging2;
 
 -- standardizing data
 
 select company, trim(company)
 from layoffs_staging2;
 
 update layoff_staging2
 set company = trim(company);
 
select distinct industry 
from layoffs_staging2
order by 1; 

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoff_staging2
 set industry = 'Crypto'
 where industry like 'Crypto%';
 
 select distinct industry 
from layoffs_staging2;

 select *
from layoffs_staging2
where country like 'United State%'
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoff_staging2
 set country = trim(trailing '.' from country)
 where country like 'united states%'; 
 
Select *
 from layoffs_staging2; 
 
 select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2 ;


update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;
 
Select *
 from layoffs_staging2; 
 
-- checking the null values

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';

select * 
from layoffs_staging2
where industry is null
or industry = '';

select * 
from layoffs_staging2
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

Select *
 from layoffs_staging2; 
 
 
-- 4.	remove rows of columns that are not necessary 
 select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


Select *
 from layoffs_staging2;  
 
alter table layoffs_staging2
drop column row_num;