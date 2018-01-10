CREATE TABLE employees (
    id NUMBER(10) CONSTRAINT emp_pk PRIMARY KEY,
    name VARCHAR2(32) NOT NULL,
    surname VARCHAR2(32) NOT NULL,
    salary NUMBER(5) NOT NULL,
    ADD CONSTRAINT salary_chk CHECK (salary >= 100 AND salary <= 30000)
);

INSERT INTO employees(id, name, surname, salary)
VALUES (1, 'Gennaro', 'Landolfi', 600);

INSERT INTO employees(id, name, surname, salary)
VALUES (3, 'Alessandro', 'Rubino', 600);

INSERT INTO employees(id, name, surname, salary)
VALUES (2, 'Biagio', 'Golino', 3000);
