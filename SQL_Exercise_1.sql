-- 1.
CREATE DATABASE IF NOT EXISTS BOOTCAMP_EXERCISE1;
USE BOOTCAMP_EXERCISE1;

CREATE TABLE regions (
    REGION_ID INT PRIMARY KEY,
    REGION_NAME VARCHAR(25)
);


CREATE TABLE countries (
    COUNTRY_ID CHAR(2) PRIMARY KEY,
    COUNTRY_NAME VARCHAR(40),
    REGION_ID INT,
    CONSTRAINT fk_countries_regions FOREIGN KEY (REGION_ID) REFERENCES regions(REGION_ID)
);


CREATE TABLE locations (
    LOCATION_ID INT PRIMARY KEY,
    STREET_ADDRESS VARCHAR(25),
    POSTAL_CODE VARCHAR(12),
    CITY VARCHAR(30),
    STATE_PROVINCE VARCHAR(12),
    COUNTRY_ID CHAR(2),
    CONSTRAINT fk_locations_countries FOREIGN KEY (COUNTRY_ID) REFERENCES countries(COUNTRY_ID)
);


CREATE TABLE departments (
    DEPARTMENT_ID INT PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR(30),
    MANAGER_ID INT,
    LOCATION_ID INT,
    CONSTRAINT fk_departments_locations FOREIGN KEY (LOCATION_ID) REFERENCES locations(LOCATION_ID)
);


CREATE TABLE jobs (
    JOB_ID VARCHAR(10) PRIMARY KEY,
    JOB_TITLE VARCHAR(35),
    MIN_SALARY DECIMAL(10, 2),
    MAX_SALARY DECIMAL(10, 2)
);


CREATE TABLE employees (
    EMPLOYEE_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(20),
    LAST_NAME VARCHAR(25),
    EMAIL VARCHAR(25),
    PHONE_NUMBER VARCHAR(20),
    HIRE_DATE DATE,
    JOB_ID VARCHAR(10),
    SALARY DECIMAL(10, 2),
    COMMISSION_PCT DECIMAL(5, 2),
    MANAGER_ID INT,
    DEPARTMENT_ID INT,
    CONSTRAINT fk_employees_departments FOREIGN KEY (DEPARTMENT_ID) REFERENCES departments(DEPARTMENT_ID),
    CONSTRAINT fk_employees_jobs FOREIGN KEY (JOB_ID) REFERENCES jobs(JOB_ID)
);


CREATE TABLE job_history (
    EMPLOYEE_ID INT,
    START_DATE DATE,
    END_DATE DATE,
    JOB_ID VARCHAR(10),
    DEPARTMENT_ID INT,
    PRIMARY KEY (EMPLOYEE_ID, START_DATE),
    CONSTRAINT fk_job_history_employees FOREIGN KEY (EMPLOYEE_ID) REFERENCES employees(EMPLOYEE_ID),
    CONSTRAINT fk_job_history_jobs FOREIGN KEY (JOB_ID) REFERENCES jobs(JOB_ID),
    CONSTRAINT fk_job_history_departments FOREIGN KEY (DEPARTMENT_ID) REFERENCES departments(DEPARTMENT_ID)
);


CREATE TABLE job_grades (
    GRADE_LEVEL VARCHAR(2) PRIMARY KEY,
    LOWEST_SAL DECIMAL(10, 2),
    HIGHEST_SAL DECIMAL(10, 2)
);

-- 2.

INSERT INTO regions (region_id, region_name) VALUES
(1, 'Europe'),
(2, 'Americas'),
(3, 'Asia');

INSERT INTO countries (country_id, country_name, region_id) VALUES
('DE', 'Germany', 1),
('IT', 'Italy', 1),
('JP', 'Japan', 3),
('US', 'United States', 2);


INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id) VALUES
(1000, '1297 Via Cola di Rie', '989', 'Roma', NULL, 'IT'),
(1100, '93091 Calle della Te', '10934', 'Venice', NULL, 'IT'),
(1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo', 'JP'),
(1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');


INSERT INTO departments (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) VALUES
(10, 'Administration', 200, 1100),
(20, 'Marketing', 201, 1200),
(30, 'Purchasing', 202, 1400);


INSERT INTO jobs (JOB_ID, JOB_TITLE) VALUES
('ST_CLERK', 'Stock Clerk'),
('MK_REP', 'Marketing Representative'),
('IT_PROG', 'IT Programmer');


INSERT INTO employees (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) VALUES
(100, 'Steven', 'King', 'SKING', '515-1234567', '1987-06-17', 'ST_CLERK', 24000.00, 0.00, 109, 10),
(101, 'Neena', 'Kochhar', 'NKOCHHAR', '515-1234568', '1987-06-18', 'MK_REP', 17000.00, 0.00, 103, 20),
(102, 'Lex', 'De Haan', 'LDEHAAN', '515-1234569', '1987-06-19', 'IT_PROG', 17000.00, 0.00, 108, 30),
(103, 'Alexander', 'Hunold', 'AHUNOLD', '590-4234567', '1987-06-20', 'MK_REP', 9000.00, 0.00, 105, 20);


INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) VALUES
(102, '1993-01-13', '1998-07-24', 'IT_PROG', 20),
(101, '1989-09-21', '1993-10-27', 'MK_REP', 10),
(101, '1993-10-28', '1997-03-15', 'MK_REP', 30),
(100, '1996-02-17', '1999-12-19', 'ST_CLERK', 30),
(103, '1998-03-24', '1999-12-31', 'MK_REP', 20);

-- 3.
SELECT l.location_id, l.street_address, l.city, l.state_province, c.country_name
FROM locations l
JOIN countries c ON l.country_id = c.country_id;

-- 4.
SELECT first_name, last_name, department_id
FROM employees;

-- 5.
SELECT e.first_name, e.last_name, e.job_id, e.department_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
WHERE c.country_name = 'Japan';

-- 6.
SELECT e1.employee_id, e1.last_name, e1.manager_id, e2.last_name AS manager_last_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- 7.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE last_name = 'De Haan' AND first_name = 'Lex');

-- 8.
SELECT d.department_name, COUNT(e.employee_id) AS number_of_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;


-- 9.
SELECT e.employee_id, j.job_title, DATEDIFF(jh.end_date, jh.start_date) AS days_difference
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE e.department_id = 30;

-- 10.
SELECT d.department_name, m.first_name AS manager_first_name, m.last_name AS manager_last_name, l.city, c.country_name
FROM departments d
JOIN employees m ON d.manager_id = m.employee_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id;

-- 11.
SELECT d.department_id, d.department_name, AVG(e.salary) AS average_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- 12.
CREATE TABLE job_grades (
  GRADE_LEVEL VARCHAR(10) PRIMARY KEY,
  MIN_SALARY DECIMAL(8, 2),
  MAX_SALARY DECIMAL(8, 2)
);

ALTER TABLE jobs
ADD COLUMN GRADE_LEVEL VARCHAR(10),
ADD FOREIGN KEY (GRADE_LEVEL) REFERENCES job_grades(GRADE_LEVEL);
