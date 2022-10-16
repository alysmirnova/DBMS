/*должности сотрудников*/
SELECT DISTINCT JOB FROM EMP;

/*кол-во сотрудников в каждом департаменте*/
SELECT DEPT.DEPTNO, DEPT.DNAME, count(EMP.EMPNO) as the_number_of_employees
FROM EMP RIGHT JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY DEPT.DEPTNO, DEPT.DNAME;

/*средняя зарплата по каждой должности*/
SELECT JOB, round(AVG(SAL), 1) AS average_salary
FROM EMP
GROUP BY JOB;

/*min и max зарплата по каждой должности*/
SELECT JOB, MIN(SAL) as min_salary, MAX(SAL) as max_salary
FROM EMP
GROUP BY JOB;

/*суммарная зарплата по каждому департаменту*/
SELECT DEPT.DEPTNO, DEPT.DNAME, SUM(SAL) as salary_amount
FROM EMP RIGHT JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY DEPT.DEPTNO, DEPT.DNAME;

/*все пары менеджеров*/
SELECT EMP1.EMPNO, EMP1.ENAME, EMP2.EMPNO, EMP2.ENAME
FROM EMP EMP1 CROSS JOIN EMP EMP2
WHERE EMP1.JOB = 'MANAGER' AND EMP2.JOB = 'MANAGER' AND EMP1.EMPNO < EMP2.EMPNO;