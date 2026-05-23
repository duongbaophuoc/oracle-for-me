-- 1. Analytic Query: Top 3 highest-spending customers per region
SELECT region, customer_name, total_spent
FROM (
    SELECT 
        region, 
        customer_name, 
        SUM(order_value) OVER(PARTITION BY region) as region_total,
        order_value as total_spent,
        DENSE_RANK() OVER(PARTITION BY region ORDER BY order_value DESC) as rank_in_region
    FROM sales_data
)
WHERE rank_in_region <= 3;

-- 2. Hierarchical Query: Organizational Chart using CONNECT BY
SELECT LEVEL, LPAD(' ', 2*(LEVEL-1)) || employee_name as emp_tree, job_title
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

-- 3. Recursive CTE (ANSI Standard)
WITH emp_hierarchy (employee_id, employee_name, manager_id, lvl) AS (
    SELECT employee_id, employee_name, manager_id, 1
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.employee_name, e.manager_id, eh.lvl + 1
    FROM employees e
    JOIN emp_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM emp_hierarchy;