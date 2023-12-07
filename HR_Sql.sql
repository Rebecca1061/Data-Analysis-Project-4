----Analysing--------------

--1)Gender breakdown

select gender,count(gender) as count
from HR
Where termdate is null group by gender;


--2)Race breakdown----
select race,count(race) as count
from HR
Where termdate is null group by race
order by 2 desc;

--3)Age distribution----

select min(age) as youngest,
max(age) as oldest
from HR
Where termdate is null ;

select gender,
case when age>=18 and age<=24 then '18-24'
     when age>=25 and age<=34 then '25-34'
     when age>=35 and age<=44 then '35-44'
     when age>=45 and age<=54 then '45-54'
	 when age>=55 and age<=64 then '55-64'
else '65+' end as age_group,
count(*) as count
from HR
Where termdate is null
group by gender,age_group order by age_group

--4)Mode of work breakdown

select location,count(location) as count
from HR
Where termdate is null group by location

--5)Average length of employment

select round(cast(avg(DATE_PART('Year', termdate) - DATE_PART('Year', hire_date)) as decimal),0)
as avg_len_employment
from HR
Where termdate is not null and termdate<=current_date

--6)Gender distribution vary across department 

select gender,department,count(*)as count
from HR
Where termdate is null group by gender,department;

--7)Jobtitle distribution across company

select jobtitle,count(*)as count
from HR
Where termdate is null group by jobtitle order by 1 desc;

--8)Department with highest turnover rate
select department,
total_count,
termminated_count,
trunc(cast(termminated_count as decimal) /total_count,4)  as termination_rate
from
(select department,
count(*) as total_count,
sum(case when termdate is not null  and 
	termdate<=current_date then 1 else 0 end) as termminated_count
from HR
group by department) as a
order by termination_rate desc;

--9)distribution of employees across locations by city and state

select location_state,count(*) as count
from HR
Where termdate is null group by location_state order by 2 desc;

---10)company's employee count over the years
select year,
hires,
terminated,
hires-terminated as netchange,
round((cast((hires-terminated) as decimal)/hires)*100,2) as net_per_change
from
(select EXTRACT( year FROM (hire_date) ) as year,
count(*) as hires,
sum(case when termdate is not null  and 
	termdate<=current_date then 1 else 0 end) as terminated
from HR group by year) as sub_query order by 1 

---11) tenure distribution of each department
select department,
ROUND(CAST(avg(DATE_PART('Year', termdate) - DATE_PART('Year', hire_date)) AS DECIMAL),0) AS AVG_TENURE
from HR WHERE termdate is not null  and 
	termdate<=current_date 
	GROUP BY department;

----Data cleaning---------------
--1)Renaming columns

Alter table HR
Rename column id to Emp_id;

--2)Adding a new column
Alter table HR
ADD column Age int;

--3)Updating the new column

update HR
Set age=extract(Year from Age(current_date,birthdate));

select min(age),max(age) from HR



----Table creation and data load-----------------------------

CREATE TABLE HR(
id varchar(20),
first_name text,
last_name text,
birthdate date,
gender text,
race text,
department text,
jobtitle varchar(50),
location text,
hire_date date,
termdate timestamptz,
location_city	text,
location_state text
);


COPY HR
FROM 'C:\Users\Dell\Documents\2023\Data analysis projects\Project-4\Dataset\Human Resources.csv'
CSV HEADER;