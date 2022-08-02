use employees_mod;

-- ////////////////////////////////// TASK 1 //////////////////////////////////

SELECT 
    YEAR(d.from_date) AS calender_year,
    e.gender AS gender,
    COUNT(e.gender) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calender_year , e.gender
HAVING calender_year >= 1990
ORDER BY calender_year;

-- ////////////////////////////////// TASK 2 //////////////////////////////////

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calender_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calender_year
                AND YEAR(dm.from_date) <= e.calender_year
        THEN
            1
        ELSE 0
    END AS active_status
FROM
    (SELECT 
        YEAR(hire_date) AS calender_year
    FROM
        t_employees
    GROUP BY calender_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calender_year;


-- ////////////////////////////////// TASK 3 //////////////////////////////////

SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(e.hire_date) AS calender_year
FROM
    t_salaries s
        JOIN
    t_employees e ON e.emp_no = s.emp_no
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_name , e.gender , calender_year
HAVING calender_year BETWEEN 1990 AND 2002
ORDER BY e.gender , d.dept_no , calender_year;


-- ////////////////////////////////// TASK 4 //////////////////////////////////

DELIMITER $$
CREATE PROCEDURE filter_salary(in lower_bound FLOAT, in upper_bound FLOAT)
BEGIN
select 
	e.gender,
    d.dept_name,
    round(avg(s.salary), 2) as avg_salary
from
	t_salaries s
		join
	t_employees e on s.emp_no = e.emp_no
		join
	t_dept_emp de on de.emp_no = e.emp_no
		join
	t_departments d on d.dept_no = de.dept_no
where s.salary between lower_bound and upper_bound
group by d.dept_no, e.gender
order by d.dept_no;
END $$
DELIMITER ;

call filter_salary(50000, 90000);