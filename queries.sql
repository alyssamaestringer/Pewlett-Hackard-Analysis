-- Find list of employees likely to retire born between 1952-1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- how many employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- how many employees born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Narrow the search for retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Narrow the search for retirement eligibility but also were hired during a certain time frame
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');



-- Number of retiring employees using COUNT
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Creating new tables, saying to save in retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- check to see if it's there
SELECT * FROM retirement_info;


-- Recreating the retirement_info table with the emp_no column
-- Drop table first
DROP TABLE retirement_info;

-- Remake table
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables with inner join
-- Select statments selects only the columns we want to view from each table
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
-- From statement points to first table to be joined
FROM departments
-- Inner Join points to second table to be joined
INNER JOIN dept_manager
-- Indicates where postgres should look for matches
ON departments.dept_no = dept_manager.dept_no;

-- recreate the list from the following 
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- joining tables with aliases for code readability, practicing and the join we did above
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Redoing other join with aliases
-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

--USE left join for retirement and dept emp tables and with all current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Using Group By
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

--Adding ORDER BY to list in specific order
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--Adding ORDER BY to list in specific order, create a new table and export it as CSV
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retire
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM dept_retire;

-- Fixing salaries dates to get the table we need
--ORDER BY column DESC for descending order
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Filter the employees we want in the table
SELECT emp_no,
	first_name,
last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- List one, employee information with employee number, last, first name, gender and salary
--TWO joins example, joining three tables together.
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');

-- Second List: Management
-- Manager's employee number, first, last name, starting and ending employment dates
-- List manager per department
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
-- List 3 Department Retirees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_no
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);
	
-- List for sales team only from retirement info, with only numbers of that department 
-- employee numbers, employee first name, employee last name, employee department name
-- Using Group By
SELECT * FROM dept_info
WHERE dept_no = 'd007';

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name
INTO sales_info
FROM retirement_info AS ri
INNER JOIN dept_info AS di
ON (ri.emp_no = di.emp_no)
INNER JOIN departments AS d
ON (di.dept_no = d.dept_no)
WHERE (d.dept_no = 'd007');
