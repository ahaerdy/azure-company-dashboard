# Projeto Company — Modelagem Relacional e Integração com Power BI

## 📌 Visão Geral

Este projeto implementa o clássico modelo relacional **Company** utilizando **MySQL 8.0**, substituindo a exigência original de Azure SQL por uma arquitetura local com integridade referencial completa.

O banco foi construído com:

- Constraints ativas
- Chaves estrangeiras
- Relacionamento N:N
- Auto-relacionamento (hierarquia de supervisão)
- Estratégia controlada de carga de dados
- Estrutura preparada para modelagem analítica

O objetivo final do projeto é integrar o modelo relacional ao **Power BI**, construindo um dashboard executivo com indicadores corporativos.

---

## 🏗 Arquitetura do Projeto

### 🔹 Camada de Banco de Dados
- MySQL 8.0 (servidor local)
- Modelagem relacional com integridade referencial
- Resolução de dependência circular entre tabelas
- Scripts versionados de criação e carga

### 🔹 Camada Analítica (Em desenvolvimento)
- Integração com Power BI
- Adaptação para modelo estrela
- Criação de medidas DAX
- Construção de painel executivo

---

## 📂 Estrutura do Repositório

```
azure-company-dashboard/
│
├── database/
│   ├── script_bd_company_v2.sql
│   └── insercao_de_dados_e_queries_sql.sql
│
├── docs/
│   └── etapa_01_modelagem_mysql_local.md
│
├── powerbi/
│   └── (arquivos .pbix)
│
└── README.md

```

---

## 🔗 Estrutura Relacional

O modelo contempla:

- **Employee → Department (1:N)**
- **Employee → Employee (Supervisor)**
- **Department → Project (1:N)**
- **Employee → Project (N:N via works_on)**
- **Employee → Dependent (1:N)**

Esse conjunto permite simular uma estrutura corporativa realista, com departamentos, projetos, folha salarial e alocação de horas.

---

## 🎯 Objetivo Analítico

A base foi estruturada para permitir análises como:

- Total de colaboradores
- Folha salarial por departamento
- Horas alocadas por projeto
- Distribuição de supervisão
- Indicadores executivos simulados

---

## 🧠 Competências Demonstradas

- Modelagem relacional
- Gerenciamento de constraints
- Resolução de dependência circular
- Carga estruturada de dados
- Preparação para modelagem analítica
- Integração banco → BI

---

## 📊 Status do Projeto

✔ Modelagem relacional concluída
✔ Base populada e validada
🔄 Modelagem analítica em Power BI em andamento

---

## 🚀 Próxima Etapa

Integração com Power BI e construção do dashboard executivo.
