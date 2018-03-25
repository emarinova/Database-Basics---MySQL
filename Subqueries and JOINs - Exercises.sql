-- 1

USE soft_uni;

SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

-- 2

SELECT e.first_name, e.last_name, t.name, a.address_text
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

-- 3

SELECT e.employee_id, e.first_name, e.last_name, d.name AS department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 4

SELECT e.employee_id, e.first_name, e.salary, d.name AS department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE salary > 15000
ORDER BY e.department_id DESC
LIMIT 5;

-- 5

SELECT employee_id, first_name
FROM employees
WHERE employee_id NOT IN 
							(SELECT employee_id
							FROM employees_projects
                            )
ORDER BY employee_id DESC
LIMIT 3;

-- 6

SELECT e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM employees AS e
RIGHT JOIN departments AS d
ON e.department_id = d.department_id
WHERE DATE(e.hire_date) > '1999-01-01' 
AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;

-- 7

SELECT e.employee_id, e.first_name, p.name AS project_name
FROM employees AS e
JOIN employees_projects AS e_p
ON e.employee_id = e_p.employee_id
JOIN projects AS p
ON e_p.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13'
AND p.end_date IS NULL
ORDER BY e.first_name, p.name
LIMIT 5;

-- 8

SELECT e.employee_id, e.first_name, 
CASE 
	WHEN YEAR(p.start_date) >= 2005 THEN NULL
    ELSE p.name
END AS project_name
FROM employees AS e
JOIN employees_projects AS e_p
ON e.employee_id = e_p.employee_id
JOIN projects AS p
ON e_p.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY project_name;

-- 9

SELECT e.employee_id, e.first_name, e.manager_id, e2.first_name AS manager_name
FROM employees AS e
JOIN employees AS e2
ON e.manager_id = e2.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name;

-- 10

SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, CONCAT(e2.first_name, ' ', e2.last_name) AS manager_name, d.name AS department_name
FROM employees AS e
JOIN employees AS e2
ON e.manager_id = e2.employee_id
JOIN departments AS d
ON e.department_id = d.department_id
WHERE e.manager_id IS NOT NULL
ORDER BY e.employee_id
LIMIT 5;

-- 11

SELECT AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY AVG(salary)
LIMIT 1;
            
-- 12

USE geography;

SELECT m_c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM mountains_countries AS m_c
JOIN mountains AS m
ON m_c.mountain_id = m.id
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE m_c.country_code = 'BG'
AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 13

SELECT m_c.country_code, COUNT(m.mountain_range) AS mountain_range
FROM mountains_countries AS m_c
JOIN mountains AS m
ON m_c.mountain_id = m.id
WHERE m_c.country_code IN ('BG', 'RU', 'US')
GROUP BY m_c.country_code
ORDER BY COUNT(m.mountain_range) DESC;

-- 14

SELECT c.country_name, r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS c_r
ON c.country_code = c_r.country_code
LEFT JOIN rivers AS r
ON c_r.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name ASC
LIMIT 5;

-- 15

SELECT c2.continent_code, c2.currency_code, c2.currency_usage
FROM (
		SELECT c.continent_code, c.currency_code, MAX(c.currency_usage) AS currency_usage
		FROM (
				SELECT continent_code, currency_code, count(currency_code) AS currency_usage
				FROM countries
				GROUP BY continent_code, currency_code
		) AS c
		GROUP BY c.continent_code
        HAVING currency_usage != 1
        ) AS c1
JOIN (
		SELECT continent_code, currency_code, count(currency_code) AS currency_usage
		FROM countries
		GROUP BY continent_code, currency_code
        ) AS c2
ON c1.continent_code = c2.continent_code
WHERE c2.currency_usage = c1.currency_usage
ORDER BY c2.continent_code, c2.currency_usage;

-- 16

SELECT count(country_code)
FROM countries
WHERE country_code NOT IN (
							SELECT DISTINCT country_code
							FROM mountains_countries
                            );
                            
-- 17

SELECT c.country_name, MAX(p.elevation) AS highest_peak_elevation, MAX(r.length) AS longest_river_length
FROM countries AS c
JOIN mountains_countries AS m_c
ON c.country_code = m_c.country_code
JOIN peaks AS p
ON m_c.mountain_id = p.mountain_id
JOIN countries_rivers AS c_r
ON c.country_code = c_r.country_code
JOIN rivers AS r
ON c_r.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name
LIMIT 5;
