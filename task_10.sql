SELECT * FROM electric_power
ORDER BY ID
FETCH FIRST 15 ROWS ONLY;

CREATE OR REPLACE TYPE t_row AS OBJECT (statistics VARCHAR2(50), morning NUMBER, day NUMBER, evening NUMBER, night NUMBER, total NUMBER);
/

CREATE OR REPLACE TYPE t_tab IS TABLE OF t_row;
/

create or replace function el_power_tab return t_tab pipelined
is
    PRAGMA AUTONOMOUS_TRANSACTION;
    type year_arr IS VARRAY(2) OF VARCHAR2(4);
    type twonum_arr IS VARRAY(2) OF NUMBER;
    type sum_arr IS VARRAY(5) OF NUMBER;
    type time_arr IS VARRAY(4) OF twonum_arr;
    years year_arr;
    quarters time_arr;
    hours time_arr;
    sum_el sum_arr;
    total_years sum_arr;
    total sum_arr;
begin
    execute immediate('truncate table el_power');
    commit;

    years := year_arr('2009', '2010');
    quarters := time_arr(twonum_arr(1, 3), twonum_arr(4, 6), twonum_arr(7, 9), twonum_arr(10, 12));
    hours := time_arr(twonum_arr(6, 11), twonum_arr(12, 17), twonum_arr(18, 24), twonum_arr(1, 5));
    total := sum_arr(0, 0, 0, 0);

    for k in 1..2 loop
        total_years := sum_arr(0, 0, 0, 0);
        for i in 1..4 loop
            sum_el := sum_arr();
            for j in 1..4 loop
                sum_el.extend;
                select sum(value) into sum_el(j)
                    from electric_power
                    where SUBSTR(date_, 7, 4) = years(k) and TO_NUMBER(SUBSTR(date_, 4, 2)) >= quarters(i)(1) and TO_NUMBER(SUBSTR(date_, 4, 2)) <= quarters(i)(2)
                    and hour >= hours(j)(1) and hour <= hours(j)(2);
                total_years(j) := total_years(j) + round(sum_el(j));
                total(j) := total(j) + round(sum_el(j));
            end loop;
            insert into el_power(statistics, morning, day, evening, night, total)
                values(i || ' quarter', sum_el(1), sum_el(2), sum_el(3), round(sum_el(4)), sum_el(1) + sum_el(2) + sum_el(3) + round(sum_el(4)));
            commit;
        end loop;
        insert into el_power(statistics, morning, day, evening, night, total)
            values('Total ' || years(k), total_years(1), total_years(2),
                total_years(3), total_years(4), total_years(1) + total_years(2) + total_years(3) + total_years(4));
        commit;
    end loop;

    insert into el_power(statistics, morning, day, evening, night, total)
        values('Total', total(1), total(2), total(3), total(4), total(1) + total(2) + total(3) + total(4));
    commit;

    for rec in (select * from el_power) loop
          pipe row(t_row(rec.statistics, rec.morning, rec.day, rec.evening, rec.night, rec.total));
    end loop;
    return;
end;
/

select * from table(el_power_tab);