SELECT * FROM ALL_TABLES WHERE rownum <= 10;

select * from SYSTEM_PRIVILEGE_MAP where rownum <= 10;

CREATE TABLE CUSTOMERS 
(
    customer_id number(10) NOT NULL,
    customer_name varchar2(50) NOT NULL,
    city varchar2(30),
    birthday date
);

select * from USER_TABLES;

DROP TABLE CUSTOMERS;

CREATE TABLE PRODUCTS
(
    product_id number(10) NOT NULL,
    product_name varchar2(50),
    CONSTRAINT product_pk PRIMARY KEY (product_id)
);

CREATE TABLE CLIENTS
(
    client_id number(10) NOT NULL,
    username varchar2(50) NOT NULL,
    client_password varchar2(30) CHECK(LENGTH(client_password) > 5),
    product_id number(10),
    CONSTRAINT client_pk PRIMARY KEY (client_id),
    CONSTRAINT username_key UNIQUE(username),
    CONSTRAINT fk_client_products
        FOREIGN KEY (product_id)
        REFERENCES PRODUCTS (product_id)
);

INSERT INTO PRODUCTS (product_id, product_name) VALUES (1, 'laptop');

INSERT INTO CLIENTS (client_id, username, client_password, product_id) 
VALUES (1, 'john', 'qwer123', 1);

select * from USER_CONSTRAINTS;

select TABLE_NAME, COUNT(TABLE_NAME) from USER_CONSTRAINTS 
GROUP BY TABLE_NAME;

select COUNT(TABLE_NAME) from USER_CONSTRAINTS;

ALTER TABLE EMP
  MODIFY SAL NUMBER(7,2) CHECK(SAL >= 500 AND SAL <= 5000);

select TABLE_NAME, CONSTRAINT_NAME from USER_CONSTRAINTS 
where TABLE_NAME = 'EMP' AND SEARCH_CONDITION_VC LIKE '%SAL >= 500%';

CREATE OR REPLACE PROCEDURE removeconstraints1(p_table_name in varchar2) IS
  sql_stmt varchar2(2048);
BEGIN
  for rec in (
    select constraint_name
    from user_constraints
    where table_name = p_table_name
    and search_condition_vc = 'SAL >= 500 AND SAL <= 5000'
  )
  loop
    sql_stmt := 'ALTER TABLE "' || p_table_name || '"'
      || ' DROP CONSTRAINT "' || rec.constraint_name || '"';
    execute immediate sql_stmt;
  end loop;
END;
/

BEGIN
    removeconstraints1('EMP');
END;
/

ALTER TABLE EMP
    ADD CONSTRAINT CHECK_SAL CHECK(SAL >= 500 AND SAL <= 5000);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP';

ALTER TABLE EMP
    DROP CONSTRAINT CHECK_SAL;

DROP TABLE CLIENTS;

DROP TABLE PRODUCTS;

select * from USER_INDEXES;

select COUNT(TABLE_NAME) from USER_INDEXES;

CREATE TABLE DEPT1
(
    DEPTNO NUMBER(2,0) NOT NULL,
    DNAME VARCHAR2(50),
    LOC VARCHAR2(50),
    CONSTRAINT DEPT1_PK PRIMARY KEY (DEPTNO)
)
ORGANIZATION INDEX;

INSERT INTO DEPT1
  SELECT *
  FROM DEPT;

SELECT * FROM DEPT1;

SELECT * FROM USER_INDEXES
    WHERE TABLE_NAME = 'DEPT1';

DROP TABLE DEPT1;