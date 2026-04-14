# Processando e Transformando Dados com Power BI

## 📋 Sobre o Projeto

Projeto desenvolvido como parte do bootcamp **NTT DATA - Engenharia de Dados com Python** na plataforma DIO.

O objetivo é demonstrar o pipeline completo de engenharia de dados — desde a modelagem relacional até a preparação de dados para um dashboard corporativo — utilizando MySQL e Power BI.

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

Documentação detalhada desta etapa neste link:
- [Etapa 01 — Modelagem Relacional e Implementação em MySQL Local](docs/01-modelagem_relacional.md)

---

## 📊 Etapa 02 — Camada Analítica com Views (MySQL)

### Objetivo

Após a criação do banco relacional e inserção dos dados, foi construída uma camada intermediária entre o banco transacional (OLTP) e o Power BI, utilizando **views analíticas** no MySQL.

As views funcionam como camada semântica sobre o modelo relacional:
- Não duplicam dados
- Não alteram as tabelas originais
- Permitem criar consolidações e métricas
- Simplificam consultas complexas

### Por que criar uma camada analítica?

As tabelas originais foram modeladas para integridade relacional (modelo normalizado). Ferramentas de BI trabalham melhor com dados consolidados e estruturas mais simples. A camada analítica resolve isso:

| Antes | Depois |
|---|---|
| Banco apenas relacional (OLTP) | Banco relacional + camada analítica (OLAP) |
| Consultas complexas com múltiplos JOINs | Views prontas para consumo |
| Responsabilidade misturada | Separação clara de responsabilidades |

### Views Criadas

#### 1. `vw_folha_departamento`
Total de colaboradores, folha salarial e média salarial por departamento.

```sql
SELECT * FROM vw_folha_departamento;
```
```
+---------+----------------+---------------------+----------------------+----------------+
| Dnumber | Dname          | Total_Colaboradores | Total_Folha_Salarial | Media_Salarial |
+---------+----------------+---------------------+----------------------+----------------+
|       4 | Administration |                   3 |             93000.00 |       31000.00 |
|       1 | Headquarters   |                   1 |             55000.00 |       55000.00 |
|       5 | Research       |                   4 |            133000.00 |       33250.00 |
+---------+----------------+---------------------+----------------------+----------------+
```

#### 2. `vw_horas_projeto`
Total de horas e colaboradores envolvidos por projeto, com departamento responsável.

```sql
SELECT * FROM vw_horas_projeto;
```
```
+---------+-----------------+----------------+---------------------+---------------------+
| Pnumber | Pname           | Departamento   | Total_Horas_Projeto | Total_Colaboradores |
+---------+-----------------+----------------+---------------------+---------------------+
|       1 | ProductX        | Research       |                52.5 |                   2 |
|       2 | ProductY        | Research       |                37.5 |                   3 |
|       3 | ProductZ        | Research       |                50.0 |                   2 |
|      10 | Computerization | Administration |                55.0 |                   3 |
|      20 | Reorganization  | Headquarters   |                25.0 |                   3 |
|      30 | Newbenefits     | Administration |                55.0 |                   3 |
+---------+-----------------+----------------+---------------------+---------------------+
```

#### 3. `vw_estrutura_hierarquica`
Organograma completo com colaborador, supervisor, departamento e salário.

```sql
SELECT * FROM vw_estrutura_hierarquica;
```
```
+-----------+------------------+------------------+----------------+----------+
| Ssn       | Colaborador      | Supervisor       | Departamento   | Salary   |
+-----------+------------------+------------------+----------------+----------+
| 123456789 | John Smith       | Franklin Wong    | Research       | 30000.00 |
| 333445555 | Franklin Wong    | James Borg       | Research       | 40000.00 |
| 453453453 | Joyce English    | Franklin Wong    | Research       | 25000.00 |
| 666884444 | Ramesh Narayan   | Franklin Wong    | Research       | 38000.00 |
| 888665555 | James Borg       | NULL             | Headquarters   | 55000.00 |
| 987654321 | Jennifer Wallace | James Borg       | Administration | 43000.00 |
| 987987987 | Ahmad Jabbar     | Jennifer Wallace | Administration | 25000.00 |
| 999887777 | Alicia Zelaya    | Jennifer Wallace | Administration | 25000.00 |
+-----------+------------------+------------------+----------------+----------+
```

#### 4. `vw_fato_horas`
Tabela fato principal: cada linha representa um colaborador alocado em um projeto com suas horas trabalhadas. Estrutura que se aproxima de um modelo dimensional.

```sql
SELECT * FROM vw_fato_horas;
```
```
+-----------+------------------+----------+----------------+---------+-----------------+-----------+-------+
| Essn      | Colaborador      | Salary   | Departamento   | Pnumber | Projeto         | Plocation | Hours |
+-----------+------------------+----------+----------------+---------+-----------------+-----------+-------+
| 123456789 | John Smith       | 30000.00 | Research       |       1 | ProductX        | Bellaire  |  32.5 |
| 123456789 | John Smith       | 30000.00 | Research       |       2 | ProductY        | Sugarland |   7.5 |
| 333445555 | Franklin Wong    | 40000.00 | Research       |       2 | ProductY        | Sugarland |  10.0 |
| 333445555 | Franklin Wong    | 40000.00 | Research       |       3 | ProductZ        | Houston   |  10.0 |
| 333445555 | Franklin Wong    | 40000.00 | Research       |      10 | Computerization | Stafford  |  10.0 |
| 333445555 | Franklin Wong    | 40000.00 | Research       |      20 | Reorganization  | Houston   |  10.0 |
| 453453453 | Joyce English    | 25000.00 | Research       |       1 | ProductX        | Bellaire  |  20.0 |
| 453453453 | Joyce English    | 25000.00 | Research       |       2 | ProductY        | Sugarland |  20.0 |
| 666884444 | Ramesh Narayan   | 38000.00 | Research       |       3 | ProductZ        | Houston   |  40.0 |
| 888665555 | James Borg       | 55000.00 | Headquarters   |      20 | Reorganization  | Houston   |   0.0 |
| 987654321 | Jennifer Wallace | 43000.00 | Administration |      20 | Reorganization  | Houston   |  15.0 |
| 987654321 | Jennifer Wallace | 43000.00 | Administration |      30 | Newbenefits     | Stafford  |  20.0 |
| 987987987 | Ahmad Jabbar     | 25000.00 | Administration |      10 | Computerization | Stafford  |  35.0 |
| 987987987 | Ahmad Jabbar     | 25000.00 | Administration |      30 | Newbenefits     | Stafford  |   5.0 |
| 999887777 | Alicia Zelaya    | 25000.00 | Administration |      10 | Computerization | Stafford  |  10.0 |
| 999887777 | Alicia Zelaya    | 25000.00 | Administration |      30 | Newbenefits     | Stafford  |  30.0 |
+-----------+------------------+----------+----------------+---------+-----------------+-----------+-------+
```

### Como reproduzir

```bash
# Executar após a Etapa 01
mysql -u root -p < database/views_analiticas.sql

# Validar
mysql -u root -p -e "
  USE azure_company;
  SELECT * FROM vw_folha_departamento;
  SELECT * FROM vw_horas_projeto;
  SELECT * FROM vw_estrutura_hierarquica;
  SELECT * FROM vw_fato_horas;
"
```

### ⚠️ Observação sobre a integração com Power BI

A integração com o Power BI **não foi realizada via views**, pois a configuração `secure_file_priv` do MySQL impediu o acesso direto ao servidor. Os dados foram exportados para **CSV** e importados via Power Query. As views continuam válidas como documentação da camada semântica e podem ser utilizadas em conexões diretas ao MySQL quando disponíveis.

Documentação detalhada desta etapa neste link:
- [Etapa 02 — Criação da Camada Analítica com Views (MySQL)](docs/02-camada-analitica-views.md)

---

## 🔄 Etapa 03 — Pipeline de Integração e Tratamento de Dados (Power Query)

### Objetivo

Importar as 6 tabelas via CSV para o Power BI e realizar todas as transformações necessárias para preparar o modelo dimensional (Star Schema).

### 3.1 Importação
- 6 tabelas importadas como **CSV** no arquivo `azure_company.pbix`
- Fontes: `employee.csv`, `department.csv`, `dept_locations.csv`, `project.csv`, `works_on.csv`, `dependent.csv`

### 3.2 Transformações Aplicadas

| Passo | Tabela                  | Transformação                                      | Detalhes / Decisões Técnicas |
|-------|-------------------------|----------------------------------------------------|------------------------------|
| 1A    | employee                | Mesclar `Fname` + `Lname`                         | Coluna `FullName` (separador: espaço) |
| 1B    | employee                | Dividir `Address` por `-`                          | Colunas: `Street_Number`, `Street_Name`, `City`, `State` |
| 1B    | employee                | Tratamento manual de endereço com hífen extra      | Ramesh Narayan: `Fire` → `Fire-Oak` / `Humble` / `TX` |
| 2     | employee                | Mesclar com `department`                           | Adicionada coluna `Dname` (Left Outer Join) |
| 3     | employee                | Auto-join para obter gerente                       | Coluna `Manager` via `Super_ssn` ↔ `Ssn` (Left Outer Join) |
| 4     | department              | Mesclar com `dept_locations` (consulta duplicada)  | Criada tabela `department_locations` |
| 5     | employee                | Consulta separada `employee_por_gerente`           | Agrupamento por `Manager` + contagem de colaboradores |
| 6     | works_on                | Correção da coluna `Hours`                         | Valores multiplicados por 10 → divididos por 10 (tipo Decimal) |
| 7     | department              | Removida mesclagem original                        | Evitar duplicatas em `Dnumber` |

**Decisões técnicas importantes**:
- Uso exclusivo de **Left Outer Join** para preservar todos os registros (ex: James Borg com `Super_ssn` = NULL)
- Criação de consultas **separadas** (`department_locations` e `employee_por_gerente`) para não alterar as tabelas originais
- Manutenção do valor `NULL` em `Manager` (James Borg é o topo da hierarquia)

### 3.3 Resultado Final no Power BI
Consultas carregadas após “Fechar e Aplicar”:
- `employee`
- `department`
- `project`
- `works_on`
- `dependent`
- `department_locations`
- `employee_por_gerente`

Documentação detalhada desta etapa:
- [Etapa 03 — Pipeline de Integração e Tratamento de Dados (Power Query)](docs/03-pipeline_de_integracao_e_tratamento_de_dados.md)

---

## 🔍 Etapa 04 — Verificação de Horas e Hierarquia

### Objetivo

Antes de finalizar as transformações no Power Query, foram realizadas verificações cruzadas nos dados originais para garantir a consistência das informações de **horas trabalhadas** e da **hierarquia organizacional**.

Essas análises foram fundamentais para definir as regras de mesclagem e limpeza aplicadas na Etapa 03.

### 4.1 Verificação das Horas dos Projetos

- Coluna `Hours` da tabela `works_on` foi analisada.
- Foram identificados valores com separador decimal incorreto na importação (ex: 325 ao invés de 32.5).
- **Solução aplicada**: divisão por 10 e alteração do tipo para Número Decimal.
- Total de horas por projeto e alocações validadas contra as views analíticas criadas na Etapa 02.

### 4.2 Análise da Hierarquia Organizacional

- Coluna `Super_ssn` da tabela `employee` foi examinada.
- **James Borg** (SSN 888665555) é o único registro com `Super_ssn = NULL` → topo da hierarquia.
- Todos os demais colaboradores possuem gerente válido.
- Nenhum departamento ficou sem gerente.
- **Decisão técnica**: preservar o valor `NULL` (não remover nem preencher) para refletir corretamente a estrutura real da empresa.

### 4.3 Reflexo no Power Query

As verificações desta etapa influenciaram diretamente as transformações:

| Verificação                  | Decisão no Power Query                          | Justificativa |
|------------------------------|--------------------------------------------------|-------------|
| Horas com erro decimal       | Dividir coluna `Hours` por 10 + tipo Decimal    | Correção de importação CSV |
| Super_ssn = NULL (James Borg)| Manter valor nulo na coluna `Manager`           | Preservar hierarquia real |
| Todos depts. com gerente     | Uso exclusivo de Left Outer Join                | Evitar perda de registros |
| Hierarquia correta           | Auto-join `Super_ssn` ↔ `Ssn`                   | Criar coluna `Manager` |

**Resultado**: As transformações ficaram alinhadas com a realidade dos dados, garantindo fidelidade para o dashboard.

Documentação detalhada desta etapa:
- [Etapa 04 — Verificação de Horas e Hierarquia](docs/04-verificacao_horas_e_hierarquia.md)

---

## ⭐ Etapa 05 — Modelo Dimensional (Star Schema)

### Objetivo

Configurar o modelo dimensional no Power BI para otimizar as análises e garantir o correto funcionamento das medidas DAX e visuais do dashboard.

O modelo segue o padrão **Star Schema**:
- **Tabela Fato** no centro (transações)
- **Tabelas Dimensão** ao redor (descrições/contextos)

### 5.1 Estrutura do Modelo

**Tabela Fato**:
- `works_on` (alocação de horas por colaborador e projeto)

**Tabelas Dimensão**:
- `employee`
- `department`
- `project`
- `dependent`
- `department_locations`
- `employee_por_gerente`

### 5.2 Relacionamentos Criados

| De                  | Coluna     | Para                | Coluna     | Cardinalidade | Direção do Filtro |
|---------------------|------------|---------------------|------------|---------------|-------------------|
| `works_on`          | `Essn`     | `employee`          | `Ssn`      | Muitos:1      | Único             |
| `works_on`          | `Pno`      | `project`           | `Pnumber`  | Muitos:1      | Único             |
| `employee`          | `Dno`      | `department`        | `Dnumber`  | Muitos:1      | Único             |
| `dependent`         | `Essn`     | `employee`          | `Ssn`      | Muitos:1      | Único             |
| `project`           | `Dnum`     | `department`        | `Dnumber`  | Muitos:1      | Único             |

**Tabelas isoladas (sem relacionamento ativo)**:
- `department_locations`
- `employee_por_gerente`

### 5.3 Diagrama do Modelo (Mermaid)

```mermaid
erDiagram
    works_on }o--|| employee : "Essn → Ssn"
    works_on }o--|| project : "Pno → Pnumber"
    employee }o--|| department : "Dno → Dnumber"
    dependent }o--|| employee : "Essn → Ssn"
    project }o--|| department : "Dnum → Dnumber"

5.4 Decisões TécnicasTodos os relacionamentos foram criados manualmente via “Gerenciar Relacionamentos”.
Aviso de “caminhos ambíguos” entre works_on e department foi aceito (dois caminhos possíveis: via employee ou via project). Será tratado com USERELATIONSHIP nas medidas DAX quando necessário.
Correção final da coluna Hours (divisão por 10 + tipo Decimal) foi aplicada antes de fechar o modelo.
Tabelas department_locations e employee_por_gerente foram mantidas isoladas para uso direto nos visuais.

Resultado: Modelo dimensional limpo, otimizado e pronto para a criação de medidas DAX e construção do dashboard corporativo.Documentação detalhada desta etapa (incluindo diagrama interativo):Etapa 05 — Modelo Dimensional (Star Schema) (docs/05-modelo_dimensional.md)

 Todo o pipeline de preparação de dados está concluído!Próximos passos possíveis:Criação de medidas DAX
Construção do dashboard executivo
Publicação e compartilhamento do relatório

