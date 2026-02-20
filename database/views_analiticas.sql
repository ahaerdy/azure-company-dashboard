USE azure_company;

-- =========================================================
-- VIEW 1: Folha Salarial por Departamento
-- =========================================================

CREATE OR REPLACE VIEW vw_folha_departamento AS
SELECT
    d.Dnumber,
    d.Dname,
    COUNT(e.Ssn) AS Total_Colaboradores,
    SUM(e.Salary) AS Total_Folha_Salarial,
    ROUND(AVG(e.Salary),2) AS Media_Salarial
FROM departament d
LEFT JOIN employee e ON d.Dnumber = e.Dno
GROUP BY d.Dnumber, d.Dname;


-- =========================================================
-- VIEW 2: Horas por Projeto
-- =========================================================

CREATE OR REPLACE VIEW vw_horas_projeto AS
SELECT
    p.Pnumber,
    p.Pname,
    d.Dname AS Departamento,
    SUM(w.Hours) AS Total_Horas_Projeto,
    COUNT(DISTINCT w.Essn) AS Total_Colaboradores
FROM project p
LEFT JOIN works_on w ON p.Pnumber = w.Pno
LEFT JOIN departament d ON p.Dnum = d.Dnumber
GROUP BY p.Pnumber, p.Pname, d.Dname;


-- =========================================================
-- VIEW 3: Estrutura Hierárquica
-- =========================================================

CREATE OR REPLACE VIEW vw_estrutura_hierarquica AS
SELECT
    e.Ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS Colaborador,
    CONCAT(s.Fname, ' ', s.Lname) AS Supervisor,
    d.Dname AS Departamento,
    e.Salary
FROM employee e
LEFT JOIN employee s ON e.Super_ssn = s.Ssn
LEFT JOIN departament d ON e.Dno = d.Dnumber;


-- =========================================================
-- VIEW 4: Fato Analítica de Horas (Base para BI)
-- =========================================================

CREATE OR REPLACE VIEW vw_fato_horas AS
SELECT
    w.Essn,
    CONCAT(e.Fname, ' ', e.Lname) AS Colaborador,
    e.Salary,
    d.Dname AS Departamento,
    p.Pnumber,
    p.Pname AS Projeto,
    p.Plocation,
    w.Hours
FROM works_on w
JOIN employee e ON w.Essn = e.Ssn
JOIN project p ON w.Pno = p.Pnumber
JOIN departament d ON e.Dno = d.Dnumber;
