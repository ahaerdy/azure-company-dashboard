# 00 — Resumo Executivo do Estado Atual do Projeto

## 📌 Identificação do Projeto

Nome do repositório: `azure-company-dashboard`
Base conceitual: Modelo relacional clássico Company
Ambiente utilizado: MySQL 8.0 (servidor local)
Objetivo final: Construção de dashboard corporativo no Power BI

---

# 🏗 Arquitetura Atual

O projeto encontra-se estruturado em três camadas:

## 🔹 1️⃣ Camada Transacional (OLTP) — Concluída

Implementação do modelo relacional normalizado contendo:

- employee
- departament
- dept_locations
- project
- works_on
- dependent

Características:

- Integridade referencial ativa
- Resolução de dependência circular
- Constraints implementadas
- Scripts versionados
- Base populada e validada

Documento associado:
`docs/01-modelagem_relacional.md`

Status: ✔ Concluído

---

## 🔹 2️⃣ Camada Analítica (Views) — Concluída

Criação de camada semântica utilizando views para:

- Consolidação de métricas
- Redução de complexidade de joins
- Separação entre dados operacionais e analíticos
- Preparação para consumo em BI

Views implementadas:

- vw_folha_departamento
- vw_horas_projeto
- vw_estrutura_hierarquica
- vw_fato_horas

Documento associado:
`docs/02-camada-analitica-views.md`

Status: ✔ Concluído

---

## 🔹 3️⃣ Camada de Visualização (Power BI) — Em desenvolvimento

Próximas atividades planejadas:

- Conectar Power BI ao MySQL local
- Importar views analíticas
- Modelar relacionamentos
- Criar medidas (DAX)
- Construir dashboard executivo
- Documentar etapa 03

Status: 🔄 Em andamento

---

# 📊 Evolução Arquitetural Consolidada

Modelo Relacional (OLTP)
⬇
Camada Analítica (Views)
⬇
Visualização e Indicadores (Power BI)

Essa progressão demonstra separação de responsabilidades e simula arquitetura corporativa de dados.

---

# 🧠 Decisões Técnicas Relevantes

- Substituição do Azure SQL por MySQL local devido a limitação de cartão de crédito
- Manutenção de todos os conceitos do desafio original
- Organização do projeto em camadas
- Versionamento de scripts
- Documentação detalhada e reprodutível

---

# 🎯 Próximo Marco

Entrega do dashboard executivo com:

- KPIs corporativos
- Indicadores por departamento
- Análise de horas por projeto
- Visualização hierárquica

Após isso, possível evolução futura:

- Implementação de modelo estrela formal
- Materialização de tabela fato
- Otimizações analíticas

---

# 📌 Observação Estratégica

O projeto já demonstra:

- Modelagem relacional sólida
- Separação OLTP vs OLAP
- Organização arquitetural
- Capacidade de documentação técnica estruturada

Encontra-se atualmente na fase de transição para visualização analítica.
