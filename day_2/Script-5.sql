----CTEs and window functions ----

---Common table expressions (ANSII SQL in 1999)
--CTE = temporary table that exists while another query is running
--use the temporary table inside another query
--CTEs = 'WITH' queries

--“Add a column for each employee showing 
--the ratio of their salary to the average salary of their team.”

--team avgs---
SELECT
	t.id,
	t.name,
	avg(e.salary) AS avg_salary
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;



SELECT 
	e.first_name,
	e.last_name,
	team_avgs.name AS team_name,
	e.salary / team_avgs.avg_salary AS salary_over_team_avg
FROM employees AS e INNER JOIN (
	SELECT
	t.id,
	t.name,
	avg(e.salary) AS avg_salary
	FROM employees AS e INNER JOIN teams AS t
	ON e.team_id = t.id
	GROUP BY t.id
) AS team_avgs 
ON e.team_id = team_avgs.id;



WITH team_avgs(id, name, avg_salary) AS (
	SELECT
	t.id,
	t.name,
	avg(e.salary)
	FROM employees AS e INNER JOIN teams AS t
	ON e.team_id = t.id
	GROUP BY t.id
)
SELECT 
	e.first_name,
	e.last_name,
	team_avgs.name AS team_name,
	e.salary,
	e.salary /team_avgs.avg_salary AS salary_over_team_avg
FROM employees AS e INNER JOIN team_avgs
ON e.team_id = team_avgs.id;


SELECT 
	avg(salary) AS avg_salary,
	country
FROM employees
GROUP BY country;


WITH country_avgs(avg_salary, country) AS (
	SELECT 
	avg(salary) AS avg_salary,
	country
	FROM employees
	GROUP BY country) 
SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.country, 
	e.salary / country_avgs.avg_salary AS salary_over_country_avg
FROM employees AS e INNER JOIN country_avgs
ON e.country = country_avgs.country;



WITH country_avgs(country, avg_salary) AS (
	SELECT
  		country,
  		AVG(salary)
	FROM employees
	GROUP BY country
), 
team_avgs(id, name, avg_salary) AS (
  SELECT
    t.id,
    t.name,
    AVG(e.salary)
  FROM employees AS e INNER JOIN teams AS t
  ON e.team_id = t.id
  GROUP BY t.id
)
SELECT
	e.first_name,
	e.last_name,
	e.salary,
	e.country,
	team_avgs.name AS team_name,
	e.salary / country_avgs.avg_salary AS salary_over_country_avg,
	e.salary / team_avgs.avg_salary AS salary_over_team_avg
FROM employees AS e INNER JOIN country_avgs
ON e.country = country_avgs.country INNER JOIN team_avgs
ON team_avgs.id = e.team_id;



---Window functions ---
--So far, aggregates applied over groups of rows, or over whole tables
--'OVER' queries

SELECT 
	department,
	avg(salary) AS avg_salary
FROM employees 
GROUP BY department;

---Window definition?
---A specification of a set of rows relative to the current row

---default windown definition is the whole table

SELECT 
	first_name,
	last_name,
	salary,
	sum(salary) OVER () AS sum_salary
FROM employees;


SELECT 
	first_name,
	last_name,
	salary,
	(SELECT sum(salary) FROM employees ) AS sum_salary
FROM employees;

--ORDER BY
--“Get a table of employees’ names, salary and start date ordered by start date,
-- together with a running total of salaries by start date.”

SELECT 
	id,
	first_name,
	last_name,
	salary,
	start_date,
	sum(salary) OVER (ORDER BY start_date ASC NULLS LAST) AS running_tot_salary
FROM employees;

--RANK(), DENSE_RANK(), ROW_NUMBER()
--Rank employees in order by their start date with the corporation.”

SELECT 
	id, 
	first_name,
	last_name,
	start_date,
	rank() OVER (ORDER BY start_date ASC NULLS last) AS start_rank
FROM employees;

SELECT 
	id, 
	first_name,
	last_name,
	start_date,
	rank() OVER (ORDER BY start_date ASC NULLS last) AS start_rank,
	DENSE_RANK() OVER (ORDER BY start_date ASC NULLS last) AS start_dense,
	ROW_NUMBER() OVER (ORDER BY start_date ASC NULLS last) AS row_num
FROM employees;

---PARTITION BY
--current row plus any other rows having the same value in the column specified after 
---partition by

--“Show for each employee the number of other employees 
--who are members of the same department as them.”

SELECT 
	id,
	first_name,
	last_name,
	department,
	count(*) OVER (PARTITION BY department) - 1 AS num_other_employees_in_dept
FROM employees
ORDER BY id;


SELECT 
	id,
	first_name,
	last_name,
	salary,
	grade,
	max(salary) OVER (PARTITION BY grade), 
	min(salary) OVER (PARTITION BY grade) 
FROM employees;

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	e.salary,
	e.salary / avg(e.salary) OVER (PARTITION BY e.team_id) AS salary_over_team_avg
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id 
ORDER BY e.id;

---ORDER by and PARTITION by together
---“Get a table of employees showing the
--order in which they started work with the corporation split by department”

SELECT 
	first_name,
	last_name,
	start_date,
	department,
	RANK() OVER (PARTITION BY department ORDER BY start_date ASC NULLS last)
	AS order_started_in_dept
FROM employees
ORDER BY start_date;

SELECT
  id,
  first_name,
  last_name,
  start_date,
  TO_CHAR(start_date, 'Month') || ' ' || TO_CHAR(start_date, 'yyyy') AS month,
  COUNT(*) OVER (
    PARTITION BY EXTRACT(MONTH FROM start_date), EXTRACT(YEAR FROM start_date)
  ) AS num_that_month
FROM employees
ORDER BY id;
