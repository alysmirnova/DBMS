-- номера и имена сотрудников, которых приняли на работу зимой
CREATE OR REPLACE VIEW employees_hired_in_winter 
AS SELECT empno, ename FROM emp
WHERE TO_CHAR(hiredate, 'MM') = '01' OR TO_CHAR(hiredate, 'MM') = '02' OR TO_CHAR(hiredate, 'MM') = '12'
WITH CHECK OPTION;

SELECT * FROM employees_hired_in_winter;

-- имена сотрудников, которые являются непосредственными начальниками не менее, чем трех подчиненных
CREATE OR REPLACE VIEW mgr_more
AS SELECT COUNT(EMP2.EMPNO) AS COUNT_EMPNO, EMP2.ENAME
FROM EMP EMP1 JOIN EMP EMP2 
ON EMP1.MGR = EMP2.EMPNO
HAVING COUNT(EMP2.EMPNO) >= 3
GROUP BY EMP2.ENAME
WITH CHECK OPTION;

SELECT * FROM mgr_more;

CREATE TABLE DEPT1
(
    DEPTNO NUMBER(2,0) NOT NULL,
    DNAME VARCHAR2(50),
    LOC VARCHAR2(50),
    CONSTRAINT DEPT1_PK PRIMARY KEY (DEPTNO)
)
ORGANIZATION INDEX;

CREATE SEQUENCE seq_dept1
START WITH 1
INCREMENT BY 1
CACHE 20;

-- генерация значений с использованием секвенции для таблицы dept1
CREATE OR REPLACE PROCEDURE insert_dept1(
    start_n IN PLS_INTEGER,
    end_n IN PLS_INTEGER
) is
  current_n PLS_INTEGER := start_n;
BEGIN
    LOOP
        EXIT WHEN current_n > end_n;
        INSERT INTO DEPT1(DEPTNO,  DNAME,  LOC) 
            VALUES 
        (
            seq_dept1.NEXTVAL,  
            'DEPARTMENT' || TO_CHAR(seq_dept1.CURRVAL),    
            'LOC' || TO_CHAR(seq_dept1.CURRVAL)
            );
        current_n := current_n + 1;
    END LOOP;
END insert_dept1;
/

BEGIN
    insert_dept1(1, 10);
END;
/

SELECT * FROM DEPT1;

SELECT * FROM USER_SEQUENCES; 

DROP SEQUENCE seq_dept1;

DROP TABLE dept1;

-- факториал натурального числа
CREATE OR REPLACE FUNCTION factorial_n(
    n IN NUMBER
) RETURN NUMBER IS
  current_i NUMBER := 2;
  factorial NUMBER := 1;
BEGIN
    LOOP
        IF current_i <= n
            THEN
                factorial := factorial * current_i;
                current_i := current_i + 1;
            ELSE
                RETURN factorial;
        END IF;
    END LOOP;
END factorial_n;
/

SELECT factorial_n(6) FROM DUAL;

-- количество дней, которые проработал сотрудник
CREATE OR REPLACE FUNCTION diff_date(p_empno IN NUMBER)
RETURN NUMBER
IS 
    curr_date DATE;
    hiredate DATE;
BEGIN
    SELECT SYSDATE INTO curr_date FROM DUAL;
    SELECT hiredate INTO hiredate FROM EMP WHERE empno = p_empno;
    RETURN TRUNC(curr_date - hiredate, 0);
END diff_date;
/

SELECT empno, ename, diff_date(empno) AS amount_of_days FROM emp;

CREATE OR REPLACE TYPE EMPARRAY is VARRAY(10) OF NUMBER;
/

-- список начальников сотрудника
CREATE OR REPLACE FUNCTION all_bosses(p_empno IN NUMBER)
RETURN EMPARRAY
IS 
    p_mgr NUMBER;
    boss_mgr NUMBER;
    i NUMBER;
    boss_array EMPARRAY;
BEGIN
    i := 1;
    boss_array := EMPARRAY(10);
    SELECT MGR INTO p_mgr FROM EMP WHERE empno = p_empno;
    WHILE TO_CHAR(p_mgr) != '-'
    LOOP
        boss_mgr := p_mgr;
        boss_array(i) := boss_mgr;
        boss_array.extend;
        SELECT MGR INTO p_mgr FROM EMP WHERE empno = p_mgr;
        i := i + 1;
    END LOOP;
    RETURN boss_array;
END all_bosses;
/

-- список начальников для каждого сотрудника
DECLARE 
   b_array EMPARRAY;
   i NUMBER;
   p_empno emp.empno%type; 
   CURSOR emp_cursor is 
      SELECT empno FROM emp;
BEGIN 
    i := 1;
    OPEN emp_cursor; 
    LOOP
        FETCH emp_cursor into p_empno; 
        EXIT WHEN emp_cursor%notfound;
        i := 1;
        select all_bosses(p_empno) INTO b_array from dual; 
        DBMS_Output.PUT_LINE
                ('Сотрудник ' || p_empno|| ': ');
        WHILE i <= b_array.count - 1
        LOOP
            DBMS_Output.PUT_LINE
                ('   Начальник №' || i || ' - ' || b_array(i));
            i := i + 1;
        END LOOP;
    END LOOP;
    CLOSE emp_cursor; 
END;
/

-- статистика по сотрудникам и департаментам
CREATE OR REPLACE PROCEDURE emp_dept_statistics
IS 
    num_of_emp NUMBER;
    num_of_dept NUMBER;
    num_of_job NUMBER;
    sum_sal NUMBER;
BEGIN
    SELECT COUNT(*) INTO num_of_emp FROM EMP;
    SELECT COUNT(*) INTO num_of_dept FROM DEPT;
    SELECT COUNT(distinct job) INTO num_of_job FROM EMP;
    SELECT SUM(SAL) INTO sum_sal FROM EMP;
    DBMS_Output.PUT_LINE
        ('Количество сотрудников: ' || num_of_emp);
    DBMS_Output.PUT_LINE
        ('Количество департаментов: ' || num_of_dept);
    DBMS_Output.PUT_LINE
        ('Количество различных должностей: ' || num_of_job);
    DBMS_Output.PUT_LINE
        ('Суммарная зарплата: ' || sum_sal);
END;
/

BEGIN
    emp_dept_statistics;
END;
/

CREATE TABLE debug_log
(
    record_id number(10) NOT NULL,
    LogTime DATE,
    Message varchar2(300),
    inSource varchar2(30),
    CONSTRAINT debug_log_pk PRIMARY KEY (record_id)
);

CREATE SEQUENCE seq_debug_log
START WITH 1
INCREMENT BY 1;

-- даты приема на работу сотрудника, который работает дольше всех и сотрудника, который работает меньше всех
CREATE OR REPLACE PROCEDURE old_new_emp(new_emp OUT DATE, old_emp OUT DATE)
IS 
BEGIN
    SELECT hiredate INTO old_emp
    FROM emp 
    ORDER BY hiredate ASC
    FETCH FIRST 1 ROWS ONLY;
    SELECT hiredate INTO new_emp
    FROM emp 
    ORDER BY hiredate DESC
    FETCH FIRST 1 ROWS ONLY;
    INSERT INTO debug_log(record_id, LogTime, Message, inSource) 
    VALUES(seq_debug_log.nextval, sysdate, 'Дата приёма сотрудника, работающего дольше всех: ' || old_emp || ', меньше всех: ' || new_emp, 'old_new_emp');
END;
/

DECLARE
    date1 date;
    date2 date;
BEGIN
    old_new_emp(date1, date2);
END;
/

SELECT * FROM debug_log;

-- процедура для фиксации динамических ошибок
create or replace procedure LogInfo
    (inInfoMessage in varchar2, inSource in varchar2)
is
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    insert into debug_log(record_id, LogTime, Message, inSource) 
    values (seq_debug_log.nextval, sysdate, inInfoMessage, inSource);
    commit;
exception
    when others then
        return;
end LogInfo;
/

CREATE or replace PROCEDURE error_examples
    (emp_job in varchar2, divider in number)
IS
    p_empno number;
    quotient number;
BEGIN
    select empno into p_empno from emp where job = emp_job;
    select 10 / divider into quotient from dual;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN LogInfo(substr(sqlerrm, 1, 100), 'error_examples'); 
    WHEN ZERO_DIVIDE
        THEN LogInfo(substr(sqlerrm, 1, 100), 'error_examples'); 
    WHEN TOO_MANY_ROWS
        THEN LogInfo(substr(sqlerrm, 1, 100), 'error_examples'); 
END error_examples;
/

BEGIN
error_examples('PRESIDENT', 0);
error_examples('MANAGER', 5);
error_examples('MANAGERp', 5);
END;
/

SELECT * FROM debug_log;

DROP SEQUENCE seq_debug_log;

DROP TABLE debug_log;