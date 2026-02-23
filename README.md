# Projeto de Engenharia de Dados e BI

## Visão Geral

Este projeto demonstra a construção completa de uma solução analítica, partindo de um banco relacional MySQL até a disponibilização dos dados tratados no Power BI para construção de dashboard corporativo.

A arquitetura foi estruturada em camadas:

1. Modelagem Relacional (Base Transacional)
2. Camada Analítica (Views SQL)
3. Pipeline de Integração e Tratamento de Dados (Power BI / Power Query)
4. Próxima etapa: Construção do Dashboard Executivo

---

## Estrutura do Repositório

| Arquivo | Descrição |
|---|---|
| `00-resumo_executivo_do_estado_atual_do_projeto.md` | Visão geral do estado do projeto e decisões técnicas |
| `01-modelagem_relacional.md` | Modelagem do banco MySQL e estrutura das tabelas |
| `02-camada_analitica.md` | Views analíticas criadas no MySQL |
| `03-pipeline_de_integracao_e_tratamento_de_dados.md` | Transformações aplicadas no Power Query |
| `04-verificacao_horas_e_hierarquia.md` | Análise de horas e hierarquia organizacional |

---

## Status Atual

✔ Banco MySQL estruturado  
✔ Views analíticas criadas  
✔ Exportação para CSV realizada  
✔ Importação das 6 tabelas no Power BI  
✔ Tratamentos de dados aplicados  
✔ Validação de nulos realizada  
✔ Transformações no Power Query concluídas  
⬜ Modelo dimensional (star schema)  
⬜ Medidas DAX  
⬜ Dashboard executivo  

---

## Transformações Aplicadas no Power Query

| # | Transformação | Tabela |
|---|---|---|
| 1 | `Fname` + `Lname` → `FullName` | `employee` |
| 2 | `Address` → `Street_Number`, `Street_Name`, `City`, `State` | `employee` |
| 3 | Mesclagem com `department` → coluna `Dname` | `employee` |
| 4 | Auto-join → coluna `Manager` via `Super_ssn` ↔ `Ssn` | `employee` |
| 5 | Nova tabela com `Dname` + `Dlocation` para star schema | `department_locations` |
| 6 | Nova tabela com contagem de colaboradores por gerente | `employee_por_gerente` |

---

## Tratamento de Nulos — Super_ssn

Foi identificado apenas 1 valor nulo na coluna `Super_ssn` da tabela `employee`.

Após análise, verificou-se que o registro corresponde ao colaborador no topo da hierarquia organizacional (James Borg — sem gerente). Portanto:

- O nulo é estrutural
- Não representa erro de carga
- Não foi removido

Essa decisão mantém a integridade da hierarquia organizacional no modelo analítico.

---

## Decisão Técnica — Mesclar vs. Atribuir

A operação de **mesclagem** foi utilizada nas junções entre tabelas porque o objetivo era enriquecer registros existentes com informações de outra entidade. A **atribuição/acréscimo** serve para empilhar linhas de tabelas com a mesma estrutura — não é aplicável nos cenários deste projeto.

---

## Próxima Etapa

Construção do modelo dimensional (star schema) e desenvolvimento do dashboard executivo com métricas organizacionais.