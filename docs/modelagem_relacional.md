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

Integridade referencial mantida.

---

## ▶ Como Reproduzir

1. Executar:
   - `database/script_bd_company.sql`

2. Executar:
   - `database/insercao_de_dados_e_queries_sql.sql`

3. Validar contagens:

SELECT COUNT() FROM employee;
SELECT COUNT() FROM departament;
SELECT COUNT() FROM project;
SELECT COUNT() FROM works_on;
SELECT COUNT(*) FROM dependent;


---

## 📊 Resultado

Base relacional íntegra e pronta para integração com Power BI.

---

## 🎯 Próxima Etapa

Integração com ferramenta de BI para construção de dashboard corporativo.

