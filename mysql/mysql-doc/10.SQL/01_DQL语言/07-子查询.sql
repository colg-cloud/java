-- 进阶：子查询
 /*
	含义：
		出现在其他语句中的SELECT语句，成为子查询或内查询
		外部的语句可以是INSERT, UPDATE, DELETE, SELECT等，一般SELECT作为外面语句较多
		外部的查询语句，成为主查询或外查询
		
	分类：
		按子查询出现的位置：
			SELECT 后面
				标量子查询
			FROM 后面
				表子查询
			WHERE 或 HAVING 后面
				标量子查询	（单行）
				列子查询	（多行）
				行子查询
			EXISTS 后面（相关子查询）
				表子查询
				EXISTS(完整的查询)，结果：1或0
			
		按结果集的行列书不同：
			标量子查询	（结果集：一行一列）
			列子查询	（结果集：多行一列）
			行子查询	（结果集：多行多列）
			表子查询	（结果集：随意，一般为多行多列）
			
	特点：
		1. 子查询放在小括号内
		2. 子查询一般放在条件的右侧
		3. 标量子查询，一般搭配着单行操作符使用（>, <, >=, <=, =, <>）
		4. 列子查询，一般搭配着多行操作符使用（IN/NOT IN, ANY/SOME, ALL）；IN是= ANY的别名；NOT IN是<> ALL的别名
		5. 子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果
		6. 将子查询结果充当一张表，必须起别名
*/
USE mysql_base;

-- 一：WHERE 或 HAVING 后面

-- 1. 标量子查询

-- 案例1：谁的工资比Abel高？
-- 1.1. 查询Abel的工资
SELECT
    e.salary
FROM
    employees e
WHERE e.last_name = 'Abel';

-- 1.2. 查询员工的信息，满足 salary > 1.1
SELECT
    e.*
FROM
    employees e
WHERE e.salary > (
    SELECT
        e.salary
    FROM
        employees e
    WHERE e.last_name = 'Abel'
);

-- 案例2：返回job_id与141号员工相同，salary比143号员工多的员工last_name、job_id、salary
-- 2.1. 查询141号员工job_id
SELECT
    e.job_id
FROM
    employees e
WHERE e.employee_id = 141;

-- 2.2. 查询143号员工salary
SELECT
    e.salary
FROM
    employees e
WHERE e.employee_id = 143;

-- 2.3. 查询员工的信息，满足 job_id = 1.1，salary > 2.2
SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE e.job_id = (
    SELECT
        e.job_id
    FROM
        employees e
    WHERE e.employee_id = 141
) AND e.salary > (
    SELECT
        e.salary
    FROM
        employees e
    WHERE e.employee_id = 143
);

-- 案例3：返回公司工资最少的员工的last_name, job_id, salary
-- 3.1. 查询公司的最低工资
SELECT
    MIN(e.salary)
FROM
    employees e;

-- 3.2. 查询 salary = 3.1 的员工的last_name, job_id, salary
SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE e.salary = (
    SELECT
        MIN(e.salary)
    FROM
        employees e
);

-- 案例4：查询最低工资大于50号部门的最低工资的部门id和其最低工资
-- 4.1. 查询50号部门的最低工资
SELECT
    MIN(e.salary)
FROM
    employees e
WHERE e.department_id = 50;

-- 4.2. 查询每个部门的最低工资
SELECT
    e.department_id, MIN(e.salary)
FROM
    employees e
GROUP BY e.department_id;

-- 4.3. 在4.2基础上筛选满足MIN(salary) > 4.1 的结果
SELECT
    e.department_id, MIN(e.salary)
FROM
    employees e
GROUP BY e.department_id
HAVING MIN(e.salary) > (
    SELECT
        MIN(e.salary)
    FROM
        employees e
    WHERE e.department_id = 50
);

-- 非法使用标量子查询，标量子查询的结果不是一行一列
SELECT
    e.department_id, MIN(e.salary)
FROM
    employees e
GROUP BY e.department_id
HAVING MIN(e.salary) > (
    SELECT
        e.salary
    FROM
        employees e
    WHERE e.department_id = 50
);


-- 2. 列子查询（多行子查询）

-- 案例1：返回location_id是1400或1700的部门中的所有员工姓名
-- 1.1. 查询location_id是1400或1700的部门编号
SELECT
    DISTINCT d.department_id
FROM
    departments d
WHERE d.location_id IN (1400, 1700);

-- 1.2. 查询员工姓名，满足 department_id 是 1.1 列表中的某一个
SELECT
    e.employee_id, e.last_name, e.department_id
FROM
    employees e
WHERE e.department_id IN (
    SELECT
        DISTINCT d.department_id
    FROM
        departments d
    WHERE d.location_id IN (1400, 1700)
);

-- 案例2：返回其他工种中比job_id为'IT_PROG'的部门任一工资低的员工的employee_id, last_name, job_id, salary
-- 2.1. 查询job_id = 'IT_PROG'部门工资
SELECT
    DISTINCT e.salary
FROM
    employees e
WHERE e.job_id = 'IT_PROG';

-- 2.2. 查询其他工种中 salary < 2.1 的任一工资的员工
SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE salary < ANY(
    SELECT
        DISTINCT e.salary
    FROM
        employees e
    WHERE e.job_id = 'IT_PROG'
) AND e.job_id <> 'IT_PROG';

SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE salary < (
    SELECT
        MAX(e.salary)
    FROM
        employees e
    WHERE e.job_id = 'IT_PROG'
) AND e.job_id <> 'IT_PROG';

-- 案例3：返回其他工种中比job_id为'IT_PROG'部门所有工资都低的员工的employee_id, last_name, job_id, salary
SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE salary < ALL(
    SELECT
        DISTINCT e.salary
    FROM
        employees e
    WHERE e.job_id = 'IT_PROG'
) AND e.job_id <> 'IT_PROG';

SELECT
    e.employee_id, e.last_name, e.job_id, e.salary
FROM
    employees e
WHERE salary < (
    SELECT
        MIN(e.salary)
    FROM
        employees e
    WHERE e.job_id = 'IT_PROG'
) AND e.job_id <> 'IT_PROG';


-- 3. 行子查询（结果集一行多列或多行多列）
-- 案例1：查询员工编号最小并且工资最高的员工信息
-- 1.1. 查询最小的员工编号
SELECT MIN(e.employee_id) FROM employees e;

-- 1.2. 查询工资最高的员工工资
SELECT MAX(e.salary) FROM employees e;

-- 1.3. 查询员工信息
SELECT
    e.*
FROM
    employees e
WHERE e.employee_id = (
    SELECT MIN(e.employee_id) FROM employees e
) AND e.salary = (
    SELECT MAX(e.salary) FROM employees e
);

-- 1.4. 行子查询
SELECT
    e.*
FROM
    employees e
WHERE (e.employee_id, e.salary) = (
    SELECT MIN(e.employee_id), MAX(e.salary) FROM employees e
);


-- 二：SELECT 后面

-- 1. 标量子查询
-- 案例1：查询每个部门的员工个数
SELECT
    d.*, (
        SELECT
            COUNT(*)
        FROM
            employees e
        WHERE e.department_id = d.department_id
    ) 员工个数
FROM
    departments d;

-- 案例2：查询员工号=102的部门名
SELECT
    e.*, (
	SELECT
	    d.department_name
	FROM
	    departments d
	WHERE d.department_id = e.department_id
    ) 部门名
FROM employees e
WHERE e.employee_id = 102;


-- 三：FROM 后面

-- 1. 表子查询
-- 案例：查询每个部门的平均工资的工资等级
SELECT
    e.department_id, ROUND(AVG(e.salary), 2) 平均工资, (
        SELECT
            jg.grade_level
        FROM
            job_grades jg
        WHERE AVG(e.salary) BETWEEN jg.lowest_sal AND jg.highest_sal
    ) 工资等级
FROM
    employees e
GROUP BY e.department_id
ORDER BY 工资等级, 平均工资;

SELECT
    ag_dep.department_id, ag_dep.ag 平均工资, jg.grade_level 工资等级
FROM
    (
        SELECT
            e.department_id, ROUND(AVG(e.salary), 2) ag
        FROM
            employees e
        GROUP BY e.department_id    
    ) ag_dep
    INNER JOIN job_grades jg ON ag_dep.ag BETWEEN jg.lowest_sal AND jg.highest_sal
ORDER BY jg.grade_level, ag_dep.ag;


-- 四：EXISTS 后面（相关子查询）

-- 1. 表子查询
-- 案例1：查询有员工的部门名
SELECT
    d.department_id, d.department_name
FROM
    departments d
WHERE EXISTS (
    SELECT
        1
    FROM
        employees e
    WHERE e.department_id = d.department_id
);

-- IN
SELECT
    d.department_id, d.department_name
FROM
    departments d
WHERE d.department_id IN (
    SELECT
        e.department_id
    FROM
        employees e
);


-- 案例2：查询没有女朋友的男生信息
SELECT
    b.boy_id, b.boy_name
FROM
    boys b
WHERE NOT EXISTS (
    SELECT
        1
    FROM
        girls g
    WHERE g.boyfriend_id = b.boy_id
);

-- IN
SELECT
    b.boy_id, b.boy_name
FROM
    boys b
WHERE b.boy_id IN (
    SELECT
        g.boyfriend_id
    FROM
        girls g
);



-- 1. 查询和Zlotkey相同部门的last_name, salary
SELECT
    e.employee_id, e.last_name, e.salary
FROM
    employees e
WHERE e.department_id = (
    SELECT
        e.department_id
    FROM
        employees e
    WHERE e.last_name = 'Zlotkey'
);

-- 2. 查询工资比公司平均工资高的员工的employee_id, last_name, salary
SELECT
    e.employee_id, e.last_name, e.salary
FROM
    employees e
WHERE e.salary > (
    SELECT
        AVG(e.salary)
    FROM
        employees e
);

-- 3. 查询各部门中工资比本部门平均工资高的员工的employee_id, last_name, salary        
SELECT
    e.employee_id, e.last_name, e.salary,
    ag_dep.department_id, ag_dep.ag 平均工资
FROM
    employees e
    INNER JOIN (
        SELECT
            e.department_id, AVG(e.salary) ag
        FROM
            employees e
        GROUP BY e.department_id
    ) ag_dep ON e.department_id = ag_dep.department_id
WHERE e.salary > ag_dep.ag;

-- 4. 查询和姓名中包含字母u的员工在相同部门的员工的employee_id, last_name
SELECT
    e.employee_id, e.last_name
FROM
    employees e
WHERE e.department_id IN (
    SELECT
        DISTINCT e.department_id
    FROM
        employees e
    WHERE e.last_name LIKE '%u%'
);

-- 5. 查询在部门的location_id为1700的部门工作的员工的employee_id
SELECT
    e.employee_id, e.last_name
FROM
    employees e
WHERE EXISTS (
    SELECT
        1
    FROM
        departments d
    WHERE d.location_id = 1700 AND d.department_id = e.department_id
);

-- 6. 查询管理者是K_ing的员工last_name, salary
SELECT
    e.employee_id, e.last_name, e.salary, e.manager_id
FROM
    employees e
WHERE e.manager_id IN (
    SELECT
        e.employee_id
    FROM
        employees e
    WHERE e.last_name = 'K_ing'
);

-- 7. 查询工资最高的员工的last_name, 要求first_name和last_name显示为一列，列名为姓.名
SELECT
   e.*, CONCAT(e.first_name, '.', e.last_name) '姓.名'
FROM
   employees e
WHERE e.salary = (
    SELECT
        MAX(e.salary)
    FROM
        employees e
);

-- 8. 查询工资最低的员工信息
SELECT
    e.*
FROM
    employees e
WHERE e.salary = (
    SELECT
        MIN(e.salary)
    FROM
        employees e
);

-- 9. 查询平均工资最低的部门信息
SELECT
    d.*
FROM
    departments d
WHERE d.department_id = (
    SELECT
        e.department_id
    FROM
        employees e
    GROUP BY e.department_id
    HAVING AVG(e.salary) = (
        SELECT
            MIN(ag_dep.ag)
        FROM
            (
        	SELECT
        	    e.department_id, AVG(e.salary) ag
        	FROM
        	    employees e
        	GROUP BY e.department_id
            ) ag_dep
    )
);

-- 10. 查询平均工资最低的部门信息和该部门的平均工资
SELECT
    d.*, (
        SELECT
            ROUND(AVG(e.salary), 2)
        FROM
            employees e
        WHERE e.department_id = d.department_id    
    ) 平均工资
FROM
    departments d
WHERE d.department_id = (
    SELECT
        e.department_id
    FROM
        employees e
    GROUP BY e.department_id
    HAVING AVG(e.salary) = (
        SELECT
            MIN(ag_dep.ag)
        FROM
            (
        	SELECT
        	    e.department_id, AVG(e.salary) ag
        	FROM
        	    employees e
        	GROUP BY e.department_id
            ) ag_dep
    )
);

-- 11. 查询平均工资最高的 job 信息
SELECT
    j.*
FROM
    jobs j
WHERE job_id = (
    SELECT
        e.job_id
    FROM
        employees e
    GROUP BY e.job_id
    HAVING AVG(e.salary) = (
        SELECT
            MAX(ag_dep.ag)
        FROM
            (
                SELECT
                    e.job_id, AVG(e.salary) ag
                FROM
                    employees e
                GROUP BY e.job_id
            ) ag_dep
    )
);

-- 12. 查询平均工资高于公司平均工资的部门有哪些
SELECT
    d.*
FROM
    departments d
WHERE d.department_id IN (
    SELECT
        DISTINCT e.department_id
    FROM
        employees e
    GROUP BY e.department_id
    HAVING AVG(e.salary) > (
        SELECT
            AVG(e.salary)
        FROM
            employees e
    )
);

-- 13. 查询公司中所有 manager 的详细信息
SELECT
   e.*
FROM
    employees e
WHERE EXISTS (
    SELECT
        1
    FROM
        employees e2
    WHERE e.employee_id = e2.manager_id
);

-- 14. 查询各个部门中 最高工资中最低的那个部门的最低工资
SELECT
    e.department_id, MIN(e.salary)
FROM
    employees e
WHERE e.department_id = (
    SELECT
        e.department_id
    FROM
        employees e
    GROUP BY e.department_id
    ORDER BY MAX(salary)
    LIMIT 1
);

-- 15. 查询平均工资最高的部门的 manager 的详细信息
SELECT
    e.*
FROM
    employees e
WHERE e.employee_id IN (
    SELECT
        DISTINCT e.manager_id
    FROM
        employees e
    WHERE e.department_id = (
        SELECT
            e.department_id
        FROM
            employees e
        GROUP BY e.department_id
        ORDER BY MAX(e.salary) DESC
        LIMIT 1
    )
);