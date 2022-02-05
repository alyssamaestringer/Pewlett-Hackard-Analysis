SELECT * FROM employees;
SELECT * FROM titles;

-- Deliverable 1
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

-- Removing duplicate entries
-- Use Dictinct with Orderby to remove duplicate rows
SELECT emp_no, first_name, last_name, title
FROM retirement_titles;

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no, to_date DESC;

-- Query to find number of employees by most recent job title who are about to retire
SELECT COUNT(title), title AS "title" 
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "count" DESC;

SELECT * FROM retiring_titles;
