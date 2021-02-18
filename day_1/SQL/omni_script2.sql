SELECT id, first_name, last_name
FROM employees 
WHERE department = 'Accounting';


SELECT 
	concat('Hello', ' ', 'there!') AS greeting;


SELECT id,
	first_name, 
	last_name,
	concat(first_name, ' ', last_name) AS full_name
FROM employees
WHERE first_name IS NOT NULL AND last_name IS NOT NULL;


SELECT DISTINCT(department)
FROM employees;


SELECT 
count(*)
FROM employees 
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';

SELECT 
	sum(salary) AS total_salary_2001_joiners
FROM employees 
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';


SELECT 
max(salary) AS maximum_salary,
min(salary) AS minimum_salary 
FROM employees ;



SELECT avg(salary)
FROM employees 
WHERE department = 'Human Resources';

SELECT sum(salary) 
FROM employees 
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';


SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary ASC
LIMIT 1;


SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST ;


SELECT *
FROM employees 
ORDER BY 
	fte_hours DESC NULLS LAST, last_name ASC NULLS LAST;
	

SELECT *
FROM employees
ORDER BY start_date ASC NULLS LAST
LIMIT 1;


SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC NULLS LAST
LIMIT 1;


SELECT department,
	count(id) AS number_employees
FROM employees 
GROUP BY department ;


SELECT department, count(id) AS num_fte_quarter_half 
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department;

SELECT count(first_name) AS count_first_name,
count(id) AS count_id,
count(*) AS count_start
FROM employees;


SELECT 
	department, 
	round(EXTRACT (DAY FROM now() - min(start_date))/365) AS longest_time
FROM employees 
GROUP BY department
ORDER BY longest_time DESC ;


SELECT 
	department, 
	first_name,
	count(id) AS num_employees
FROM employees 
GROUP BY department, first_name ;


SELECT department,
	count(id) AS num_pensioneed
FROM employees 
WHERE pension_enrol = TRUE
GROUP BY department;

SELECT country,
	count(id) AS missing_names
FROM employees 
WHERE first_name IS NULL 
GROUP BY country;

SELECT 
	department, 
	count(id) AS num_fte_quarter_half
FROM employees 
WHERE fte_hours IN (0.25, 0.5)
GROUP BY department
HAVING count(id) >= 40 ;

SELECT 
	country,
	min(salary) AS min_salary
FROM employees 
WHERE pension_enrol = TRUE 
GROUP BY country 
HAVING min(salary) < 21000;

SELECT department,
	min(start_date) AS min_date
FROM employees 
WHERE grade = 1
GROUP BY department 
HAVING min(start_date) < '1991-01-01';

SELECT *
FROM employees 
WHERE country  = 'Japan' AND salary > (SELECT 
										avg(salary)
									FROM employees);
								

SELECT fte_hours,
	count(id) AS num_employees 
FROM employees 
GROUP BY fte_hours
ORDER BY num_employees DESC 
LIMIT 1;


SELECT *
FROM employees 
WHERE country = 'United States' AND fte_hours = (
	SELECT fte_hours
FROM employees 
GROUP BY fte_hours
ORDER BY count(id) DESC 
LIMIT 1);





