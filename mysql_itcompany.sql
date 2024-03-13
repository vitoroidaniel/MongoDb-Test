-- SCRIPT FOR DATABASE IT COMPANY
-- DROP DATABASE IF EXISTS
DROP DATABASE IF EXISTS ITCompany;

-- CREATE DATABASE
CREATE DATABASE ITCompany;

USE ITCompany;

-- DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- Create table Departments
CREATE TABLE Departments (
    id_department TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    depart_name VARCHAR(100) UNIQUE NOT NULL
);

-- Create table Employee
CREATE TABLE Employee (
    id_emp INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_department TINYINT,
    name_emp VARCHAR(100) NOT NULL,
    surname_emp VARCHAR(100) NOT NULL,
    adress_emp VARCHAR(100) NOT NULL,
    gender_emp CHAR(1) CHECK(gender_emp = 'M' OR gender_emp = 'F'),
    date_birth_emp DATE,
    idnp_emp VARCHAR(20) CHECK (LENGTH(idnp_emp) >= 3), -- Changed to VARCHAR
    position VARCHAR(100) NOT NULL,
    hiredate_emp DATE,
    hours_worked SMALLINT NOT NULL,
    hourly_rate DECIMAL(10, 2),  
    total_salary DECIMAL(10, 2) GENERATED ALWAYS AS (hours_worked * hourly_rate) STORED, -- Updated
    num_childrens TINYINT NOT NULL,
    FOREIGN KEY(id_department) REFERENCES Departments(id_department),
    CHECK(hours_worked >= 100)
);

-- Create table Childrens
CREATE TABLE Childrens (
    id_child INT AUTO_INCREMENT PRIMARY KEY,
    id_emp INT,
    child_name VARCHAR(100) NOT NULL,
    child_surname VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_emp) REFERENCES Employee(id_emp)
);

-- Create table Sponsor
CREATE TABLE Sponsor (
    id_sponsor TINYINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sponsor_name VARCHAR(100) UNIQUE NOT NULL,
    sponsor_reserved_budget DECIMAL(15, 2) NOT NULL,
    sponsor_start_date DATE NOT NULL,
    sponsor_end_date DATE NOT NULL,
    CHECK(sponsor_end_date >= sponsor_start_date)
);

-- Create table Projects
CREATE TABLE Projects (
    id_project SMALLINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_manager INT NOT NULL,
    id_sponsor TINYINT NOT NULL,
    project_name VARCHAR(100) UNIQUE NOT NULL,
    project_start_date DATE NOT NULL,
    project_end_date DATE NOT NULL,
    project_reserved_hours SMALLINT NOT NULL,
    project_reserved_budget DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (id_manager) REFERENCES Employee(id_emp),
    FOREIGN KEY (id_sponsor) REFERENCES Sponsor(id_sponsor),
    CHECK (project_end_date >= project_start_date)
);

-- Create table Clients
CREATE TABLE Clients (
    id_company TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    company_adress VARCHAR(100) NOT NULL,
    company_telephone VARCHAR(20) NOT NULL CHECK(LENGTH(company_telephone) = 9), -- Changed to VARCHAR
    company_email VARCHAR(100) NOT NULL
);

-- Create table Functions
CREATE TABLE Functions (
    id_function TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    function_name VARCHAR(100) UNIQUE NOT NULL
);

-- Create table EmployeeFunctions
CREATE TABLE EmployeeFunctions (
    id_emp INT NOT NULL,
    id_function TINYINT NOT NULL,
    PRIMARY KEY (id_emp, id_function),
    FOREIGN KEY (id_emp) REFERENCES Employee(id_emp),
    FOREIGN KEY (id_function) REFERENCES Functions(id_function)
);

-- Create table ProjectEmployee
CREATE TABLE ProjectEmployee (
    id_project SMALLINT NOT NULL,
    id_emp INT NOT NULL,
    PRIMARY KEY (id_project, id_emp),
    FOREIGN KEY (id_project) REFERENCES Projects(id_project),
    FOREIGN KEY (id_emp) REFERENCES Employee(id_emp)
);

-- Create table ProjectDepartment
CREATE TABLE ProjectDepartment (
    id_project SMALLINT NOT NULL,
    id_department TINYINT NOT NULL,
    PRIMARY KEY (id_project, id_department),
    FOREIGN KEY (id_project) REFERENCES Projects(id_project),
    FOREIGN KEY (id_department) REFERENCES Departments(id_department)
);

DELIMITER //

CREATE TRIGGER before_insert_Employee
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.date_birth_emp, CURDATE()) < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employees must be at least 18 years old.';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- Trigger for salary
CREATE TRIGGER calculate_total_salary BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    SET NEW.total_salary = NEW.hours_worked * NEW.hourly_rate;
END;

DELIMITER ;

-- INSERTS
-- Inserts for Departments
INSERT INTO Departments (depart_name) VALUES 
('Human Resources'),
('Information Technology'),
('Finance'),
('Marketing'),
('Sales'),
('Customer Support'),
('Research and Development'),
('Operations'),
('Quality Assurance'),
('Legal');

-- Inserts for Employee
INSERT INTO Employee (id_department, name_emp, surname_emp, adress_emp, gender_emp, date_birth_emp, idnp_emp, position, hiredate_emp, hours_worked, hourly_rate, num_childrens) VALUES 
(1, 'John', 'Doe', '123 Main St', 'M', '1990-05-15', 123456789, 'HR Manager', '2022-01-15', 130, 30.00, 2),
(2, 'Jane', 'Smith', '456 Elm St', 'F', '1985-08-20', 987654321, 'Software Engineer', '2022-02-10', 160, 25.00, 1),
(3, 'Alice', 'Johnson', '789 Oak St', 'F', '1995-03-25', 654321987, 'Accountant', '2022-03-05', 150, 28.00, 0),
(4, 'Bob', 'Williams', '321 Pine St', 'M', '1992-11-10', 456789123, 'Marketing Manager', '2022-04-20', 140, 35.00, 2),
(5, 'Emma', 'Brown', '987 Cedar St', 'F', '1988-04-17', 789123456, 'Systems Analyst', '2022-05-15', 155, 27.50, 1),
(6, 'Michael', 'Jones', '654 Maple St', 'M', '1991-07-05', 321987654, 'HR Assistant', '2022-06-10', 135, 22.00, 0),
(7, 'Olivia', 'Martinez', '852 Walnut St', 'F', '1993-09-30', 234567890, 'Sales Representative', '2022-07-18', 145, 26.50, 2),
(8, 'William', 'Garcia', '159 Birch St', 'M', '1987-12-12', 567890123, 'Database Administrator', '2022-08-05', 165, 29.00, 1),
(9, 'Sophia', 'Lopez', '753 Ash St', 'F', '1994-01-28', 890123456, 'Financial Analyst', '2022-09-22', 125, 31.50, 0),
(10, 'Daniel', 'Wilson', '426 Spruce St', 'M', '1990-06-08', 678901234, 'Customer Service Representative', '2022-10-12', 140, 24.00, 2);

-- Inserts for Childrens
INSERT INTO Childrens (id_emp, child_name, child_surname) VALUES 
(1, 'Alice', 'Doe'),
(2, 'Bob', 'Smith'),
(3, 'Charlie', 'Johnson'),
(4, 'Emma', 'Williams'),
(5, 'James', 'Brown'),
(6, 'Grace', 'Jones'),
(7, 'Logan', 'Martinez'),
(8, 'Sophie', 'Garcia'),
(9, 'Jackson', 'Lopez'),
(10, 'Olivia', 'Wilson');

-- Inserts for Sponsor
INSERT INTO Sponsor (sponsor_name, sponsor_reserved_budget, sponsor_start_date, sponsor_end_date) VALUES 
('XYZ Corporation', 50000.00, '2022-01-01', '2022-12-31'),
('Tech Solutions Inc.', 60000.00, '2022-02-01', '2022-12-31'),
('Innovate Now Ltd', 45000.00, '2022-03-01', '2022-12-31'),
('Global Ventures', 55000.00, '2022-04-01', '2022-12-31'),
('Future Enterprises', 48000.00, '2022-05-01', '2022-12-31'),
('Smart Solutions Ltd.', 52000.00, '2022-06-01', '2022-12-31'),
('NextGen Innovations', 47000.00, '2022-07-01', '2022-12-31'),
('InnoTech Ventures', 58000.00, '2022-08-01', '2022-12-31'),
('Digital Solutions Inc.', 51000.00, '2022-09-01', '2022-12-31'),
('Visionary Partners', 59000.00, '2022-10-01', '2022-12-31');

-- Inserts for Projects
INSERT INTO Projects (id_manager, id_sponsor, project_name, project_start_date, project_end_date, project_reserved_hours, project_reserved_budget) VALUES 
(1, 1, 'HR System Upgrade', '2022-03-01', '2022-08-31', 200, 30000.00),
(4, 4, 'Market Expansion Campaign', '2022-03-01', '2022-09-30', 180, 25000.00),
(2, 2, 'Software Development Project', '2022-04-01', '2022-10-31', 220, 35000.00),
(3, 3, 'Financial Planning Software Implementation', '2022-05-01', '2022-11-30', 190, 28000.00),
(5, 5, 'Network Infrastructure Upgrade', '2022-06-01', '2022-12-31', 210, 32000.00),
(6, 6, 'Employee Training Program', '2022-07-01', '2022-12-31', 230, 38000.00),
(7, 7, 'Sales Promotion Campaign', '2022-08-01', '2022-12-31', 200, 30000.00),
(8, 8, 'Database Migration Project', '2022-09-01', '2022-12-31', 190, 27000.00),
(9, 9, 'Financial Audit Process Improvement', '2022-10-01', '2022-12-31', 180, 29000.00),
(10, 10, 'Customer Support System Enhancement', '2022-11-01', '2022-12-31', 170, 26000.00);

-- Inserts for Functions
INSERT INTO Functions (function_name) VALUES 
('HR Manager'),
('Software Engineer'),
('Accountant'),
('Marketing Manager'),
('Systems Analyst'),
('HR Assistant'),
('Sales Representative'),
('Database Administrator'),
('Financial Analyst'),
('Customer Service Representative');

-- Inserts for EmployeeFunctions
INSERT INTO EmployeeFunctions (id_emp, id_function) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 3),
(7, 1),
(8, 2),
(9, 3),
(10, 1);

-- Inserts for ProjectEmployee
INSERT INTO ProjectEmployee (id_project, id_emp) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts for ProjectDepartment
INSERT INTO ProjectDepartment (id_project, id_department) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts for Clients
INSERT INTO Clients (company_name, company_adress, company_telephone, company_email) VALUES 
('ABC Corporation', '456 Oak St', 123456789, 'info@abc.com'),
('Tech Innovators Ltd', '123 Tech Street', 987654321, 'info@techinnovators.com'),
('InnovateTech Solutions', '456 Innovation Avenue', 123456789, 'contact@innovatetech.com'),
('Digital Dynamics Corporation', '789 Digital Road', 567890123, 'info@digitaldynamicscorp.com'),
('InnoSolutions Group', '101 Innovation Lane', 234567890, 'contact@innosolutionsgroup.com'),
('FutureTech Innovations', '202 Future Avenue', 345678901, 'info@futuretechinnovations.com'),
('GlobalTech Enterprises', '303 Global Street', 456789012, 'contact@globaltechenterprises.com'),
('TechGenius Innovate', '404 Tech Lane', 567890123, 'info@techgeniusinnovate.com'),
('InnoSolutions Ltd', '505 Innovation Road', 678901234, 'contact@innosolutionsltd.com'),
('MegaTech Innovations', '606 Mega Avenue', 789012345, 'info@megatechinnovations.com'),
('FutureInnovate Tech', '707 Future Street', 890123456, 'contact@futureinnovatetech.com');

-- SELECTS
-- Select from Departments
SELECT * FROM Departments;
-- Select from Employee
SELECT * FROM Employee;
-- Select from Childrens
SELECT * FROM Childrens;
-- Select from Sponsor
SELECT * FROM Sponsor;
-- Select from Projects
SELECT * FROM Projects;
-- Select from Clients
SELECT * FROM Clients;


-- SELECTS
SELECT * FROM Employee WHERE id_department = 1;

SELECT Projects.project_name, Employee.name_emp AS manager_name
FROM Projects
JOIN Employee ON Projects.id_manager = Employee.id_emp;

SELECT Departments.depart_name, COUNT(Employee.id_emp) AS num_employees
FROM Departments
LEFT JOIN Employee ON Departments.id_department = Employee.id_department
GROUP BY Departments.id_department, Departments.depart_name;

SELECT Projects.project_name, SUM(Projects.project_reserved_budget) AS total_budget
FROM Projects
GROUP BY Projects.id_project, Projects.project_name;

SELECT Clients.company_name, Projects.project_name
FROM Clients
JOIN Projects ON Clients.id_company = Projects.id_sponsor;

SELECT * FROM Projects WHERE id_manager = 4;

SELECT * FROM Projects WHERE YEAR(project_start_date) = 2022;

-- --------------------------------------------------------------------
-- Fragmentarea
-- Fragmentarea verticala
CREATE TABLE Employee_Main AS
SELECT id_emp, name_emp, surname_emp
FROM Employee;

SELECT * FROM Employee_Main;

-- Fragmentarea orizontala
CREATE TABLE Employee_Departament1 AS
SELECT *
FROM Employee
WHERE id_department = 1;

SELECT * FROM Employee_Departament1;

-- VIEWS
-- Viziunea 1: Numele, prenumele angajatului și numele departamentului
DROP VIEW IF EXISTS View_EmployeeDepartment;

CREATE VIEW View_EmployeeDepartment AS
SELECT e.name_emp, e.surname_emp, d.depart_name
FROM Employee e
JOIN Departments d ON e.id_department = d.id_department;

SELECT * FROM View_EmployeeDepartment;

-- Viziunea 2: Numele, prenumele fiecărui copil și numele părintelui
DROP VIEW IF EXISTS View_Children;

CREATE VIEW View_Children AS
SELECT e.name_emp AS parent_name, e.surname_emp AS parent_surname, c.child_name, c.child_surname
FROM Employee e
JOIN Childrens c ON e.id_emp = c.id_emp;

SELECT * FROM View_Children;

-- Viziunea 3: Salariul mediu, minim, maxim și numărul de angajați pentru fiecare departament
DROP VIEW IF EXISTS View_DepartmentStats;

CREATE VIEW View_DepartmentStats AS
SELECT d.depart_name AS department_name,
       AVG(e.total_salary) AS avg_salary,
       MIN(e.total_salary) AS min_salary,
       MAX(e.total_salary) AS max_salary,
       COUNT(e.id_emp) AS num_employees
FROM Employee e
JOIN Departments d ON e.id_department = d.id_department
GROUP BY d.depart_name;

SELECT * FROM View_DepartmentStats;

-- Viziunea 4: Venitul fiecărui angajat de la proiecte
DROP VIEW IF EXISTS View_EmployeeProjectIncome;

CREATE VIEW View_EmployeeProjectIncome AS
SELECT e.name_emp, e.surname_emp, p.project_name, e.total_salary AS income
FROM ProjectEmployee pe
JOIN Employee e ON pe.id_emp = e.id_emp
JOIN Projects p ON pe.id_project = p.id_project;

SELECT * FROM View_EmployeeProjectIncome;

-- LB 6 PARTITIONING
-- PARTITIONING WITH RANGE
DROP TABLE IF EXISTS Partition_Emp;
CREATE TABLE Partition_Emp AS SELECT id_emp, id_department, name_emp, surname_emp, hiredate_emp, date_birth_emp, position FROM Employee;

-- RANGE Partition
ALTER TABLE Partition_Emp
PARTITION BY RANGE (YEAR(date_birth_emp)) (
    PARTITION p0 VALUES LESS THAN (1990),
    PARTITION p1 VALUES LESS THAN (1992),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);

-- LIST Partition
ALTER TABLE Partition_Emp
PARTITION BY LIST (id_department) (
    PARTITION p_001 VALUES IN (1),
    PARTITION p_002 VALUES IN (2),
    PARTITION p_003 VALUES IN (3),
    PARTITION p_004 VALUES IN (4),
    PARTITION p_005 VALUES IN (5),
    PARTITION p_006 VALUES IN (6),
    PARTITION p_007 VALUES IN (7),
    PARTITION p_008 VALUES IN (8),
    PARTITION p_009 VALUES IN (9),
    PARTITION p_010 VALUES IN (10)
);

SELECT * FROM Partition_Emp PARTITION(p_001, p_002, p_003);

-- HASH Partition
ALTER TABLE Partition_Emp
PARTITION BY HASH (YEAR(date_birth_emp)) (
    PARTITION p3,
    PARTITION p4,
    PARTITION p5
);

-- Verify the partitions
SELECT * FROM Partition_Emp PARTITION (p0, p1, p2);

-- HASH Partition

SELECT * FROM Partition_Emp PARTITION (p3);
SELECT * FROM Partition_Emp PARTITION (p4);
SELECT * FROM Partition_Emp PARTITION (p5);

-- Check the contents of the table
SELECT * FROM Partition_Emp;
