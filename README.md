# Projeto de Engenharia de Dados e BI

## Visão Geral

Este projeto demonstra a construção completa de uma solução analítica, partindo de um banco relacional MySQL até a disponibilização dos dados tratados no Power BI para futura construção de dashboard corporativo.

A arquitetura foi estruturada em camadas:

1. Modelagem Relacional (Base Transacional)
2. Camada Analítica (Views SQL)
3. Pipeline de Integração e Tratamento de Dados (Power BI)
4. Próxima etapa: Construção do Dashboard Executivo

---

## Estrutura do Repositório

* 00-resumo_executivo_do_estado_atual_do_projeto.md
* 01-modelagem_relacional.md
* 02-camada_analitica.md
* 03-pipeline_de_integracao_e_tratamento_de_dados.md

---

## Status Atual

✔ Banco MySQL estruturado
✔ Views analíticas criadas
✔ Exportação para CSV realizada
✔ Importação das 6 tabelas no Power BI
✔ Tratamentos de dados aplicados
✔ Validação de nulos realizada

---

## Tratamento de Nulos – Caso Super_ssn

Foi identificado apenas 1 valor nulo na coluna `Super_ssn` da tabela `employee`.

Após análise, verificou-se que o registro corresponde ao colaborador no topo da hierarquia organizacional (sem gerente). Portanto:

* O nulo é estrutural
* Não representa erro de carga
* Não foi removido

Essa decisão mantém a integridade da hierarquia organizacional no modelo analítico.

---

## Próxima Etapa

Construção do modelo dimensional (estrela) e desenvolvimento do dashboard executivo com métricas organizacionais.
