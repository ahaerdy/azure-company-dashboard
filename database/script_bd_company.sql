-- =========================================================
-- SCRIPT DEFINITIVO DE CRIAÇÃO DO BANCO
-- Database: azure_company
-- MySQL 8.0+
-- =========================================================

DROP DATABASE IF EXISTS azure_company;
CREATE DATABASE azure_company;
USE azure_company;

-- =========================================================
-- TABELA: departament
-- =========================================================

CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    Dept_create_date DATE,
    PRIMARY KEY (Dnumber),
    UNIQUE (Dname)
);

-- =========================================================
-- TABELA: employee
-- =========================================================

CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(50),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT,
    PRIMARY KEY (Ssn),
    CONSTRAINT fk_employee_supervisor
        FOREIGN KEY (Super_ssn)
        REFERENCES employee(Ssn)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (Dno)
        REFERENCES departament(Dnumber)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =========================================================
-- ADICIONAR FK GERENTE EM DEPARTAMENTO
-- =========================================================

ALTER TABLE departament
ADD CONSTRAINT fk_dept_manager
FOREIGN KEY (Mgr_ssn)
REFERENCES employee(Ssn)
ON UPDATE CASCADE;

-- =========================================================
-- TABELA: dept_locations
-- =========================================================

CREATE TABLE dept_locations (
    Dnumber INT,
    Dlocation VARCHAR(15),
    PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations
        FOREIGN KEY (Dnumber)
        REFERENCES departament(Dnumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================================
-- TABELA: project
-- =========================================================

CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT,
    PRIMARY KEY (Pnumber),
    UNIQUE (Pname),
    CONSTRAINT fk_project_department
        FOREIGN KEY (Dnum)
        REFERENCES departament(Dnumber)
);

-- =========================================================
-- TABELA: works_on
-- =========================================================

CREATE TABLE works_on (
    Essn CHAR(9),
    Pno INT,
    Hours DECIMAL(3,1),
    PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on
        FOREIGN KEY (Essn)
        REFERENCES employee(Ssn)
        ON DELETE CASCADE,
    CONSTRAINT fk_project_works_on
        FOREIGN KEY (Pno)
        REFERENCES project(Pnumber)
        ON DELETE CASCADE
);

-- =========================================================
-- TABELA: dependent
-- =========================================================

CREATE TABLE dependent (
    Essn CHAR(9),
    Dependent_name VARCHAR(15),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(15),
    PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent_employee
        FOREIGN KEY (Essn)
        REFERENCES employee(Ssn)
        ON DELETE CASCADE
);
