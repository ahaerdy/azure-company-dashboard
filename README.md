# Processando e Transformando Dados com Power BI

## 📋 Sobre o Projeto

Projeto desenvolvido como parte do bootcamp **NTT DATA - Engenharia de Dados com Python** na plataforma DIO.

O objetivo é demonstrar o pipeline completo de engenharia de dados — desde a modelagem relacional até a preparação de dados para um dashboard corporativo — utilizando MySQL e Power BI.

> **Instrutora:** Juliana Mascarenhas (Tech Education Specialist / Cientista de Dados)

---

## 🎯 Escopo do Desafio

Conforme as instruções oficiais do desafio, o objetivo desta entrega é a **coleta e processamento de dados utilizando o Power BI**, preparando a base para futura construção de um dashboard corporativo. As etapas envolvem:

1. Criação do banco de dados e modelagem relacional
2. Construção de camada analítica com views SQL
3. Integração e importação dos dados no Power BI
4. Transformações e limpeza de dados via Power Query
5. Configuração do modelo dimensional (Star Schema)

---

## ⚠️ Adaptação Técnica

O desafio original previa a utilização do **Microsoft Azure** com banco de dados em nuvem. Como alternativa técnica viável — devido à exigência de serviço pago — foi implementada a solução com:

- **MySQL 8.0** em servidor local
- Modelagem relacional completa com integridade referencial ativa

Essa abordagem é válida pois emprega todos os conceitos do desafio original:

| Conceito | Implementado |
|---|---|
| Modelagem relacional | ✅ |
| Constraints | ✅ |
| Chaves estrangeiras | ✅ |
| Relacionamentos N:N | ✅ |
| Hierarquia organizacional | ✅ |
| Base estruturada para BI | ✅ |

---

## 🗂 Estrutura do Repositório

```
/
├── README.md                                          ← Este arquivo
├── database/
│   ├── script_bd_company.sql                         ← DDL: criação das tabelas
│   ├── insercao_de_dados_e_queries_sql.sql           ← DML: inserção dos dados
│   └── views_analiticas.sql                          ← Views da camada analítica
├── powerbi/
│   └── azure_company.pbix                            ← Arquivo Power BI
└── docs/
    ├── 01-modelagem_relacional.md
    ├── 02-camada-analitica-views.md
    ├── 03-pipeline_de_integracao_e_tratamento_de_dados.md
    ├── 04-verificacao_horas_e_hierarquia.md
    └── 05-modelo_dimensional.md
```

---

## 🏗 Etapa 01 — Modelagem Relacional

### Banco de dados: `azure_company`

#### Tabelas criadas

| Tabela | Descrição |
|---|---|
| `employee` | Colaboradores, hierarquia e salários |
| `departament` | Departamentos e seus gerentes |
| `dept_locations` | Localizações dos departamentos |
| `project` | Projetos e suas localizações |
| `works_on` | Alocação de colaboradores em projetos (N:N) |
| `dependent` | Dependentes dos colaboradores |

#### Relacionamentos

| Relacionamento | Tipo |
|---|---|
| `employee` ↔ `departament` | 1:N |
| `employee` ↔ `employee` | Auto-relacionamento (supervisor) |
| `departament` ↔ `project` | 1:N |
| `employee` ↔ `project` | N:N via `works_on` |
| `employee` ↔ `dependent` | 1:N |

#### Decisão técnica — ciclo de dependência

Durante a implementação foi identificado um ciclo de dependência:
- `departament` depende de `employee` via `Mgr_ssn`
- `employee` depende de `departament` via `Dno`

Solução adotada:

```sql
SET FOREIGN_KEY_CHECKS = 0;
-- inserção estruturada dos dados
SET FOREIGN_KEY_CHECKS = 1;
```

Integridade referencial restaurada e validada após a carga.

#### Estrutura das tabelas

<details>
<summary>📄 Visualizar dados das tabelas</summary>

**employee**
```
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
```

**departament**
```
+----------------+---------+-----------+----------------+------------------+
| Dname          | Dnumber | Mgr_ssn   | Mgr_start_date | Dept_create_date |
+----------------+---------+-----------+----------------+------------------+
| Headquarters   |       1 | 888665555 | 1981-06-19     | 1980-06-19       |
| Administration |       4 | 987654321 | 1995-01-01     | 1994-01-01       |
| Research       |       5 | 333445555 | 1988-05-22     | 1986-05-22       |
+----------------+---------+-----------+----------------+------------------+
```

**dept_locations**
```
+---------+-----------+
| Dnumber | Dlocation |
+---------+-----------+
|       1 | Houston   |
|       4 | Stafford  |
|       5 | Bellaire  |
|       5 | Houston   |
|       5 | Sugarland |
+---------+-----------+
```

**project**
```
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
```

**works_on**
```
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
```

**dependent**
```
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
```

</details>

#### Como reproduzir

```bash
# Pré-requisito: MySQL 8.0 ou superior

# 1. Criar estrutura do banco
mysql -u root -p < database/script_bd_company.sql

# 2. Inserir os dados
mysql -u root -p < database/insercao_de_dados_e_queries_sql.sql

# 3. Validar
mysql -u root -p -e "
  SELECT COUNT(*) AS employees FROM azure_company.employee;
  SELECT COUNT(*) AS departments FROM azure_company.departament;
  SELECT COUNT(*) AS projects FROM azure_company.project;
  SELECT COUNT(*) AS allocations FROM azure_company.works_on;
  SELECT COUNT(*) AS dependents FROM azure_company.dependent;
"
```

---

*Continuação nas próximas etapas...*
