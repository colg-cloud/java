-- 进阶3：排序查询
/*
	语法：
		SELECT
			查询列表
		FROM
			表名
		[WHERE 筛选条件]
		ORDER BY 排序列表 [ASC|DESC]
		
	执行顺序：
		FROM, WHERE, SELECT, ORDER BY
		
	特点：
		1. ASC 升序，DESC 降序；如果不写，默认是升序
		2. ORDER BY 字句中可以支持单个字段、多个字段、表达式、函数、别名
		3. ORDER BY 字句一般是放在查询语句的最后面，LIMIT 字句除外
*/
USE mysql_base;

-- 案例1：查询员工信息，要求工资从高到低排序
SELECT
    e.*
FROM
    employees e
ORDER BY e.salary DESC;

-- 案例2：查询部门编号大于等于90的员工信息，按照入职时间的先后进行排序；添加筛选条件
SELECT
    e.*
FROM
    employees e
WHERE e.department_id >= 90
ORDER BY e.hiredate ASC;

-- 案例3：按年薪的高低显示员工的信息和年薪；按表达式排序
SELECT
    e.*, e.salary * 12 * (1 + IFNULL(e.commission_pct, 0)) 年薪
FROM
    employees e
ORDER BY e.salary * 12 * (1 + IFNULL(e.commission_pct, 0)) DESC;

-- 案例4：按年薪的高低显示员工的信息和年薪；按别名排序
SELECT
    e.*, e.salary * 12 * (1 + IFNULL(e.commission_pct, 0)) 年薪
FROM
    employees e
ORDER BY 年薪 DESC;

-- 案例5：按姓名的长度显示员工的姓名和工资；按函数排序
SELECT
    e.employee_id, e.last_name, e.salary, LENGTH(e.last_name) 姓名长度
FROM
    employees e
ORDER BY 姓名长度;

-- 案例6：查询员工信息，要求先按工资降序排序，再按员工编号升序排序
SELECT
    e.*
FROM
    employees e
ORDER BY e.salary DESC, e.employee_id;