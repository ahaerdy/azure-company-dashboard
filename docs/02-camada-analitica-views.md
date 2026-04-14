# 📊 Etapa 02 — Criação da Camada Analítica com Views (MySQL)

## 🎯 Objetivo da Etapa

Após a criação do banco relacional `azure_company` e inserção dos dados, foi necessário criar uma camada intermediária entre o banco transacional (OLTP) e a ferramenta de Business Intelligence (Power BI).

Essa camada foi construída utilizando **views analíticas**.

**Observação**: As views funcionam como camada semântica sobre o modelo relacional, permitindo abstração e consolidação sem duplicação física dos dados.

---

## 🧠 O que é uma View?

Uma *view* no MySQL é uma consulta salva que pode ser utilizada como se fosse uma tabela.

Ela:
- Não duplica dados
- Não altera as tabelas originais
- Permite criar consolidações e métricas
- Simplifica consultas complexas

---

## 🏗 Por que criar uma camada analítica?

As tabelas originais foram modeladas para integridade relacional (modelo normalizado).

Porém, ferramentas de BI trabalham melhor com:

- Dados consolidados
- Métricas já agregadas
- Estruturas mais simples de consumir

Assim, criamos uma camada intermediária para:

✔ Separar OLTP de OLAP  
✔ Reduzir complexidade no Power BI  
✔ Melhorar organização arquitetural  

---

# 🔵 Views

Abaixo são apresentadas as views criadas, acompanhadas de exemplos reais de saída, demonstrando a consolidação e organização dos dados.

## 1️⃣ vw_folha_departamento

Calcula:

- Total de colaboradores por departamento
- Total da folha salarial
- Média salarial

### Saída:

```mysql
mysql> SELECT * FROM vw_folha_departamento;
+---------+----------------+---------------------+----------------------+----------------+
| Dnumber | Dname          | Total_Colaboradores | Total_Folha_Salarial | Media_Salarial |
+---------+----------------+---------------------+----------------------+----------------+
|       4 | Administration |                   3 |             93000.00 |       31000.00 |
|       1 | Headquarters   |                   1 |             55000.00 |       55000.00 |
|       5 | Research       |                   4 |            133000.00 |       33250.00 |
+---------+----------------+---------------------+----------------------+----------------+
3 rows in set (0,00 sec)
```

## 2️⃣ vw_horas_projeto

Calcula:

- Total de horas por projeto
- Total de colaboradores envolvidos
- Departamento responsável

### Saída:

```mysql
mysql> SELECT * FROM vw_horas_projeto;
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
6 rows in set (0,01 sec)
```

## 3️⃣ vw_estrutura_hierarquica

Permite visualizar:

- Funcionário
- Supervisor
- Departamento
- Salário

Essa view já possibilita construir um organograma.

### Saída:

```mysql
mysql> SELECT * FROM vw_estrutura_hierarquica;
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
8 rows in set (0,00 sec)
```

## 4️⃣ vw_fato_horas

Essa é a principal view analítica.

Cada linha representa: Funcionário + Projeto + Horas trabalhadas.

Essa estrutura se aproxima de uma **tabela fato**, típica de modelos dimensionais.

```mysql
mysql> SELECT * FROM vw_fato_horas;
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
16 rows in set (0,00 sec)
```

---

# 📈 Evolução Arquitetural do Projeto

### Antes:
Banco apenas relacional (modelo normalizado)

### Depois:
Banco relacional + camada analítica (views)

Isso representa a transição de: **Sistema operacional → Sistema analítico**

Essa transição representa a introdução de uma camada semântica, aproximando o modelo relacional de um modelo dimensional, preparando o ambiente para consumo analítico.

---

## 📌 Conclusão

A criação das views marca o início da transformação dos dados brutos em informação analítica.

Essa etapa demonstra:

- Entendimento de arquitetura de dados
- Separação de responsabilidades
- Preparação adequada para BI

---

## ⚠️ Observação sobre a Integração com Power BI

A integração com o Power BI **não foi realizada via views**, pois a configuração `secure_file_priv` do MySQL impediu o acesso direto. Os dados foram exportados para **CSV** e importados no Power BI via Power Query.

As views continuam válidas como documentação da camada semântica e podem ser utilizadas em conexões diretas ao MySQL quando disponíveis.

---

# ▶ Como Reproduzir Esta Etapa

## 1️⃣ Pré-requisito

O banco deve já estar criado e populado conforme documentado na Etapa 01.

Executar previamente:

- `database/script_bd_company.sql`
- `database/insercao_de_dados_e_queries_sql.sql`

## 2️⃣ Criar as Views Analíticas

Executar:

- `database/views_analiticas.sql`

## 3️⃣ Validar a Criação

```mysql
SELECT * FROM vw_folha_departamento;
SELECT * FROM vw_horas_projeto;
SELECT * FROM vw_estrutura_hierarquica;
SELECT * FROM vw_fato_horas;
```

Se as consultas retornarem dados, a camada analítica foi criada com sucesso.

---

## ✅ Status desta Etapa

Concluída. Views criadas, validadas e documentadas.