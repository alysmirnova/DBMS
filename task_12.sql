CREATE TABLE debug_log
(
    record_id number(10) NOT NULL,
    LogTime varchar2(40),
    Message varchar2(300),
    inSource varchar2(30),
    CONSTRAINT debug_log_pk PRIMARY KEY (record_id)
);

CREATE SEQUENCE seq_debug_log
START WITH 1
INCREMENT BY 1;

CREATE TABLE coordinates
(
    id NUMBER(5) NOT NULL,
    x NUMBER,
    y NUMBER,
    CONSTRAINT coordinates_pk PRIMARY KEY (id)
);

CREATE SEQUENCE coord_log
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE create_coordinates
AS
BEGIN
    INSERT INTO coordinates(id, x, y) VALUES (coord_log.nextval, round(dbms_random.VALUE(-30,30)), round(dbms_random.VALUE(-30,30)));
    INSERT INTO debug_log(record_id, LogTime, Message, inSource)
        VALUES(seq_debug_log.nextval, to_char(SYSTIMESTAMP,'dd:mm:yyyy HH24:MI:SS.FF'), 'Созданы новые координаты', 'create_coordinates');
END;

BEGIN
DBMS_SCHEDULER.CREATE_PROGRAM
( program_name  => 'coord_program',
  program_type  => 'STORED_PROCEDURE' ,
  program_action => 'create_coordinates',
  enabled       => TRUE
);
END;

BEGIN
  DBMS_SCHEDULER.CREATE_SCHEDULE
     ( schedule_name   => 'coord_schedule',
       start_date      => SYSTIMESTAMP,
       repeat_interval => 'FREQ=SECONDLY; INTERVAL=1',
       end_date        => SYSTIMESTAMP + INTERVAL '20' SECOND
     ) ;
END;

DECLARE
   next_run_date TIMESTAMP;
BEGIN
  DBMS_SCHEDULER.EVALUATE_CALENDAR_STRING
  (
    'FREQ=SECONDLY; INTERVAL=1',
     SYSTIMESTAMP,
     NULL,
     next_run_date
  ) ;
  DBMS_OUTPUT.PUT_LINE ( 'current_date: ' || SYSTIMESTAMP );
  DBMS_OUTPUT.PUT_LINE ( 'next_run_date: ' || next_run_date );
END;

BEGIN
   DBMS_SCHEDULER.CREATE_JOB
     ( job_name      => 'coord_job',
       program_name  => 'coord_program',
       start_date      => SYSTIMESTAMP,
       repeat_interval => 'FREQ=SECONDLY; INTERVAL=1',
       end_date        => SYSTIMESTAMP + INTERVAL '25' SECOND,
       enabled       => TRUE
     );
END;

BEGIN
    execute immediate 'truncate table coordinates';
    execute immediate 'truncate table debug_table';
END;