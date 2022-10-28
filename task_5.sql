create table test_table (
id number,
name varchar2(40) not null,
CONSTRAINT test_table_pk PRIMARY KEY (id)
);

create sequence test_sequence 
start with 1 
increment by 1;

-- автоматическая генерация id с использованием секвенции
create or replace trigger sequence_trigger 
before insert on test_table for each row
begin
  select test_sequence.nextval
  into :new.id 
  from dual;
end;
/

insert into test_table (name) values ('John');

insert into test_table (name) values ('Sara');

select * from test_table;

create table test_table2 (
id number,
name varchar2(40) not null,
CONSTRAINT test_table2_pk PRIMARY KEY (id)
);

-- автоматическая генерация id с использованием функции max
create or replace trigger max_id_trigger
before insert on test_table2
for each row
begin
   select nvl(max(test_table2.id)+1, 1) into :new.id from test_table2;
end;
/

insert into test_table2 (name) values ('John');

insert into test_table2 (name) values ('Sara');

select * from test_table2;

CREATE TABLE debug_log
(
    record_id number(10) NOT NULL,
    event varchar2(30),
    obj_type varchar2(30),
    obj_name varchar2(30),
    logTime DATE,
    CONSTRAINT debug_log_pk PRIMARY KEY (record_id)
);

CREATE SEQUENCE seq_debug_log
START WITH 1
INCREMENT BY 1;

-- запись событий, связанных с созданием, удалением и изменением
CREATE OR REPLACE TRIGGER event_trigger
AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    IF sys.DICTIONARY_OBJ_TYPE = 'TABLE' OR sys.DICTIONARY_OBJ_TYPE = 'VIEW' OR sys.DICTIONARY_OBJ_TYPE = 'SEQUENCE'
        THEN 
            insert into debug_log(record_id, event, obj_type, obj_name, logTime) 
            values (seq_debug_log.nextval, sys.SYSEVENT, sys.DICTIONARY_OBJ_TYPE, sys.DICTIONARY_OBJ_NAME, sysdate);
    END IF;
END;
/

create table new_table (
id number,
name varchar2(40) not null,
CONSTRAINT new_table_pk PRIMARY KEY (id)
);

DROP TABLE new_table;

CREATE OR REPLACE VIEW employees_hired_in_winter 
AS SELECT empno, ename FROM emp
WHERE TO_CHAR(hiredate, 'MM') = '01' OR TO_CHAR(hiredate, 'MM') = '02' OR TO_CHAR(hiredate, 'MM') = '12'
WITH CHECK OPTION;

SELECT * FROM debug_log;

SELECT * FROM USER_TRIGGERS;

DROP TRIGGER max_id_trigger;

DROP TABLE test_table2;

DROP TABLE test_table;

DROP VIEW employees_hired_in_winter;

DROP TRIGGER EVENT_TRIGGER;

DROP SEQUENCE seq_debug_log;

DROP TABLE debug_log;

DROP SEQUENCE test_sequence;