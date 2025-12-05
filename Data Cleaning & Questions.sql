create database project;
use project;

-- Project Name - Workforce Analytics Dashboard

select * from HR;

alter table HR
change column ï»¿id emp_id varchar(20) null;
select * from HR;

describe HR;

select birthdate from HR;

-- Change date format and data type of birthdate

update HR set birthdate = case
when birthdate like '%/%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

select birthdate from HR;

set sql_safe_updates = 0;

alter table HR
modify column birthdate date;
select birthdate from HR;

describe HR;

-- Change date format and data type of hire_date
update HR set hire_date = case
when hire_date like '%/%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

select hire_date from HR;

alter table HR
modify column hire_date date;
select hire_date from HR;

describe HR;

select termdate from HR;

-- Change date format and data type of termdate
UPDATE HR
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL
  AND termdate != '';

alter table HR 
modify column termdate date;
select termdate from HR;

select termdate from HR;

select count(termdate) from HR ;
select distinct termdate from HR limit 2500;

describe HR;

select * from HR;

alter table HR
add column age int;
select * from HR;

-- Find the age of employees by birthdate
update HR set age  = timestampdiff(YEAR, birthdate, curdate());
select birthdate,age from HR;

-- find the youngest & oldest employees
select min(age) as youngest, max(age) as oldest from HR;

-- find the age less than 18
select count(*) from HR where age <18;

select count(*) FROM hr where termdate > CURDATE();

select count(*)
FROM HR
where termdate = '0000-00-00';

select distinct(location) from HR;

## Questions ##

-- 1. What is the gender breakdown of employees in the company?
select gender,count(*) as Employee_Count from HR where age>18 group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race,count(*) as Race_Count from HR group by race order by count(*) desc;

-- 3. What is the age distribution of employees in the company?
select min(age) as Youngest , max(age) as Oldest from HR where age>18;

select case
when age>=18 and age <=24 then '18-24'
when age>=25 and age <=34 then '25-34'
when age>=35 and age <=44 then '35-44'
when age>=45 and age <=54 then '45-54'
when age>=55 and age <=64 then '55-64'
else '65+'
end as age_group,gender, count(*) as count from HR group by age_group,gender order by age_group,gender;

-- 4. How many employees work at headquarters versus remote locations?
select location,count(*) from HR group by location;

-- 5. What is the average length of employment for employees who have been terminated?
select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employement
from HR where termdate <= curdate() and termdate <> '0000-00-00' and age> 18;

-- 6. How does the gender distribution vary across departments and job titles?
select department,gender,count(*) as count from HR group by department,gender order by department;

-- 7. What is the distribution of job titles across the company?
select jobtitle,count(*) as count from HR group by jobtitle order by jobtitle desc ;

-- 8. Which department has the highest turnover rate?
select 
department,
total_count,
terminated_count,
round(terminated_count*100/total_count,2)  as termination_rate 
from (
select
 department,
 count(*) as total_count,
 sum(case
 when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count 
from HR where age >=18 group by department) as subquery order by termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state?
select location_state, count(*) as count from HR group by location_state order by count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?
select year,hires, terminations, hires - terminations AS net_change,
round((hires - terminations) / hires * 100, 2) AS net_change_percent
from(select
year(hire_date) as year,count(*) AS hires,
sum(case
when termdate <> '0000-00-00' 
and termdate <= CURDATE() 
then 1 else 0 end) as terminations from HR where age >= 18 group by year(hire_date)) as subquery
order by year ASC;

-- 11. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure from HR 
where termdate <= curdate() and termdate <> '0000-00-00' and  age >= 18 group by department;





