-- Test it live: https://livesql.oracle.com/apex/livesql/s/f30wems22by88g8eqhi6oeus5
-- Table: table_employees.pls

DECLARE
    emp NUMBER := 1;
    emp_salary NUMBER(5);

    PROCEDURE adjust_salary (
        emp_id NUMBER,
        adj NUMBER,
        sal IN OUT NUMBER
    ) IS
    BEGIN
        sal := sal + adj;

        UPDATE employees
        SET salary = sal
        WHERE id = emp_id;

        DBMS_OUTPUT.PUT_LINE('Updated salary is: ' || sal);
    END;
BEGIN
    SELECT salary
    INTO emp_salary
    FROM employees
    WHERE id = emp;

    adjust_salary(emp, 30, emp_salary);
END;
