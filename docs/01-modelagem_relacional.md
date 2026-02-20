# Etapa 01 — Modelagem Relacional e Implementação em MySQL Local

## 📌 Contexto

O desafio original do curso previa a utilização do Microsoft Azure com banco de dados em nuvem.

Como alternativa técnica viável, foi implementada a solução utilizando:

- MySQL 8.0
- Servidor local
- Modelagem relacional completa com integridade referencial ativa

Essa abordagem mantém todos os conceitos do desafio original:
- Modelagem relacional
- Constraints
- Chaves estrangeiras
- Relacionamentos N:N
- Hierarquia organizacional
- Base estruturada para BI

---

## 🏗 Estrutura do Banco

Database: `azure_company`

### Tabelas criadas:

- `employee`
- `departament`
- `dept_locations`
- `project`
- `works_on`
- `dependent`

---

## 🔗 Relacionamentos

- Employee ↔ Departament (1:N)
- Employee ↔ Employee (auto-relacionamento - supervisor)
- Departament ↔ Project (1:N)
- Employee ↔ Project (N:N via works_on)
- Employee ↔ Dependent (1:N)

---

## ⚙ Decisões Técnicas

Durante a implementação, foi identificado um ciclo de dependência:

- `departament` depende de `employee` (Mgr_ssn)
- `employee` depende de `departament` (Dno)

Solução adotada:

- Carga inicial com `SET FOREIGN_KEY_CHECKS = 0`
- Inserção estruturada dos dados
- Reativação das constraints após carga

Integridade referencial restaurada e validada após a carga.

## 🧩 Arquitetura Implementada

A base foi construída seguindo modelo relacional normalizado (3FN), com:

- Separação clara de entidades
- Relacionamentos explícitos
- Integridade referencial ativa
- Minimização de redundância

Essa modelagem favorece consistência transacional e prepara o ambiente para posterior criação de camada analítica.

---

## ▶ Como Reproduzir

Pré-requisito:
- MySQL 8.0 ou superior

1. Executar:
   - `database/script_bd_company.sql`

2. Executar:
   - `database/insercao_de_dados_e_queries_sql.sql`

3. Validar contagens:

```mysql
SELECT COUNT(*) FROM employee;
SELECT COUNT(*) FROM departament;
SELECT COUNT(*) FROM project;
SELECT COUNT(*) FROM works_on;
SELECT COUNT(*) FROM dependent;
```

---

## 📊 Resultado

Base relacional íntegra e pronta para integração com Power BI.

## 🔍 Validação e Visualização dos Dados

Após a carga e validação das contagens, foi realizada a inspeção completa das tabelas para confirmar:

- Consistência dos relacionamentos
- Integridade das chaves estrangeiras
- Correta distribuição dos dados
- Estrutura organizacional modelada

Abaixo, apresenta-se o detalhamento completo das tabelas.

### Detalhamento da base:

#### Estrutura e dados da tabela `employee`

```mysql
mysql> select * from employee;
+----------+-------+---------+-----------+------------+------------------------+------+----------+-----------+-----+
| Fname    | Minit | Lname   | Ssn       | Bdate      | Address                | Sex  | Salary   | Super_ssn | Dno |
+----------+-------+---------+-----------+------------+------------------------+------+----------+-----------+-----+
| John     | B     | Smith   | 123456789 | 1965-01-09 | 731-Fondren-Houston-TX | M    | 30000.00 | 333445555 |   5 |
| Franklin | T     | Wong    | 333445555 | 1955-12-08 | 638-Voss-Houston-TX    | M    | 40000.00 | 888665555 |   5 |
| Joyce    | A     | English | 453453453 | 1972-07-31 | 5631-Rice-Houston-TX   | F    | 25000.00 | 333445555 |   5 |
| Ramesh   | K     | Narayan | 666884444 | 1962-09-15 | 975-Fire-Oak-Humble-TX | M    | 38000.00 | 333445555 |   5 |
| James    | E     | Borg    | 888665555 | 1937-11-10 | 450-Stone-Houston-TX   | M    | 55000.00 | NULL      |   1 |
| Jennifer | S     | Wallace | 987654321 | 1941-06-20 | 291-Berry-Bellaire-TX  | F    | 43000.00 | 888665555 |   4 |
| Ahmad    | V     | Jabbar  | 987987987 | 1969-03-29 | 980-Dallas-Houston-TX  | M    | 25000.00 | 987654321 |   4 |
| Alicia   | J     | Zelaya  | 999887777 | 1968-01-19 | 3321-Castle-Spring-TX  | F    | 25000.00 | 987654321 |   4 |
+----------+-------+---------+-----------+------------+------------------------+------+----------+-----------+-----+
8 rows in set (0,00 sec)
```

#### Estrutura e dados da tabela `departament`

```mysql
mysql> select * from departament;
+----------------+---------+-----------+----------------+------------------+
| Dname          | Dnumber | Mgr_ssn   | Mgr_start_date | Dept_create_date |
+----------------+---------+-----------+----------------+------------------+
| Headquarters   |       1 | 888665555 | 1981-06-19     | 1980-06-19       |
| Administration |       4 | 987654321 | 1995-01-01     | 1994-01-01       |
| Research       |       5 | 333445555 | 1988-05-22     | 1986-05-22       |
+----------------+---------+-----------+----------------+------------------+
3 rows in set (0,00 sec)
```

#### Estrutura e dados da tabela `dept_locations`

```mysql
mysql> select * from dept_locations;
+---------+-----------+
| Dnumber | Dlocation |
+---------+-----------+
|       1 | Houston   |
|       4 | Stafford  |
|       5 | Bellaire  |
|       5 | Houston   |
|       5 | Sugarland |
+---------+-----------+
5 rows in set (0,00 sec)
```

#### Estrutura e dados da tabela `project`

```mysql
mysql> select * from project;
+-----------------+---------+-----------+------+
| Pname           | Pnumber | Plocation | Dnum |
+-----------------+---------+-----------+------+
| ProductX        |       1 | Bellaire  |    5 |
| ProductY        |       2 | Sugarland |    5 |
| ProductZ        |       3 | Houston   |    5 |
| Computerization |      10 | Stafford  |    4 |
| Reorganization  |      20 | Houston   |    1 |
| Newbenefits     |      30 | Stafford  |    4 |
+-----------------+---------+-----------+------+
6 rows in set (0,00 sec)
```

#### Estrutura e dados da tabela `works_on`

```mysql
mysql> select * from works_on;
+-----------+-----+-------+
| Essn      | Pno | Hours |
+-----------+-----+-------+
| 123456789 |   1 |  32.5 |
| 123456789 |   2 |   7.5 |
| 333445555 |   2 |  10.0 |
| 333445555 |   3 |  10.0 |
| 333445555 |  10 |  10.0 |
| 333445555 |  20 |  10.0 |
| 453453453 |   1 |  20.0 |
| 453453453 |   2 |  20.0 |
| 666884444 |   3 |  40.0 |
| 888665555 |  20 |   0.0 |
| 987654321 |  20 |  15.0 |
| 987654321 |  30 |  20.0 |
| 987987987 |  10 |  35.0 |
| 987987987 |  30 |   5.0 |
| 999887777 |  10 |  10.0 |
| 999887777 |  30 |  30.0 |
+-----------+-----+-------+
16 rows in set (0,00 sec)

```

#### Estrutura e dados da tabela `dependent`

```mysql
mysql> select * from dependent;
+-----------+----------------+------+------------+--------------+
| Essn      | Dependent_name | Sex  | Bdate      | Relationship |
+-----------+----------------+------+------------+--------------+
| 123456789 | Alice          | F    | 1988-12-30 | Daughter     |
| 123456789 | Elizabeth      | F    | 1967-05-05 | Spouse       |
| 123456789 | Michael        | M    | 1988-01-04 | Son          |
| 333445555 | Alice          | F    | 1986-04-05 | Daughter     |
| 333445555 | Joy            | F    | 1958-05-03 | Spouse       |
| 333445555 | Theodore       | M    | 1983-10-25 | Son          |
| 987654321 | Abner          | M    | 1942-02-28 | Spouse       |
+-----------+----------------+------+------------+--------------+
7 rows in set (0,00 sec)
```

---

## 🎯 Próxima Etapa

Integração com ferramenta de BI para construção de dashboard corporativo.

