# 📄 03-integracao_e_transformacao_powerbi.md

---

# 🔄 Integração e Transformação de Dados no Power BI

## 🎯 Objetivo da Etapa

Esta etapa tem como finalidade integrar a base relacional hospedada em MySQL na Azure ao Power BI e realizar as transformações necessárias para garantir:

* Consistência estrutural
* Correção de tipos de dados
* Tratamento de inconsistências
* Preparação para modelagem analítica

Essa fase representa a camada de **tratamento e governança de dados (ETL leve)** dentro da arquitetura do projeto.

---

# ☁️ Origem dos Dados

* Banco relacional implementado em MySQL
* Instância criada na Microsoft Azure

Devido a restrições técnicas de driver no ambiente local, os dados foram exportados em formato CSV utilizando o comando:

```sql
SELECT * INTO OUTFILE ...
```

A exportação preservou a integridade estrutural das tabelas.

---

# 📦 Pipeline de Integração

MySQL (Azure)
⬇
Exportação CSV
⬇
Power Query
⬇
Modelo Analítico
⬇
Dashboard Executivo

A integração foi realizada no Microsoft Power BI Desktop por meio da importação de arquivos CSV.

---

# 🧹 Transformações Realizadas no Power Query

## 1️⃣ Correção de Cabeçalhos

Os arquivos CSV gerados não continham nomes de colunas.
As colunas foram renomeadas manualmente conforme o modelo relacional definido no documento `01-modelagem_relacional.md`.

Isso garantiu:

* Clareza semântica
* Manutenção das chaves primárias e estrangeiras
* Coerência com o modelo original

---

## 2️⃣ Ajuste de Tipos de Dados

Foram aplicadas tipagens adequadas conforme boas práticas de modelagem:

* Identificadores (SSN, chaves) → Texto
* Datas → Tipo Date
* Salary → Decimal Number (Double preciso)
* Quantidades e códigos numéricos → Whole Number

Essa etapa assegura precisão analítica e evita erros em medidas DAX futuras.

---

## 3️⃣ Verificação e Tratamento de Nulos

Foram realizadas análises para:

* Identificar colaboradores sem `super_ssn` (potenciais gerentes)
* Verificar departamentos sem gerente definido
* Conferir consistência hierárquica

Os nulos foram tratados conforme o contexto de negócio simulado.

---

## 4️⃣ Validação de Horas de Projeto

A tabela `works_on` foi analisada para verificar:

* Horas nulas
* Valores inconsistentes
* Possíveis distorções quantitativas

Essa verificação assegura confiabilidade nas métricas de alocação.

---

## 5️⃣ Mesclas (Merge Queries)

### ✔ Employee + Department

* Base: Employee
* Junção: Department
* Tipo: Left Outer

Justificativa:
A tabela Employee é a entidade central da análise.
Utilizar Left Join garante que nenhum colaborador seja excluído do modelo.

---

### ✔ Colaboradores + Nome do Gerente

Foi realizada junção para incluir o nome do supervisor de cada colaborador.

Essa etapa poderia ser feita via SQL ou Power Query.
Optou-se por Power Query para manter rastreabilidade dentro do fluxo analítico.

---

## 6️⃣ Consolidação de Colunas

Foram aplicadas transformações estruturais:

* Mescla de Nome + Sobrenome → Nome Completo
* Mescla Departamento + Localização → Identificador único departamento-local

Essa estratégia auxilia na futura construção do modelo estrela.

---

## 7️⃣ Remoção de Colunas Desnecessárias

Campos técnicos não utilizados no relatório foram removidos, reduzindo:

* Complexidade do modelo
* Volume de dados
* Ambiguidade analítica

---

# 🏗 Impacto Arquitetural

A etapa de transformação permitiu:

* Preparação para modelagem dimensional
* Redução de ruído estrutural
* Consolidação de chaves analíticas
* Organização semântica das entidades

Essa separação entre:

Banco Relacional
⬇
Camada Analítica (Views)
⬇
Transformação Power Query

Demonstra compreensão de arquitetura em camadas aplicada a Business Intelligence.

---

# 🧠 Competências Demonstradas

* Integração MySQL → Power BI
* ETL com Power Query
* Tratamento de qualidade de dados
* Aplicação de joins controlados
* Padronização estrutural
* Preparação para modelo estrela
* Governança básica de dados

---

# 🚀 Próxima Etapa

* Consolidação do modelo estrela
* Criação de métricas DAX
* Construção do Dashboard Executivo
* Publicação do relatório final
