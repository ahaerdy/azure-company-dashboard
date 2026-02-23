# 00 - Resumo Executivo do Estado Atual do Projeto

## 1. Objetivo do Projeto
O projeto visa integrar dados com **MySQL local (azure_company)** e transformá-los para análise em **Power BI**, seguindo o desafio proposto na disciplina. O foco é criar um modelo analítico consistente e pronto para relatórios corporativos, garantindo qualidade e integridade dos dados.

---

## 2. Estado Atual do Projeto

### 2.1 Modelagem Relacional ✅
- Tabelas principais: `employee`, `department`, `project`, `works_on`, `dept_locations`, `dependent`.
- Relações definidas:
  - `employee.Dno → department.Dnumber`
  - `project.Dnum → department.Dnumber`
  - `works_on.Essn → employee.Ssn`
  - `works_on.Pno → project.Pnumber`
  - `employee.Super_ssn → employee.Ssn` (auto-relacionamento hierárquico)

### 2.2 Camada Analítica (Views MySQL) ✅
- Criadas 4 views analíticas no MySQL como camada semântica intermediária:
  - `vw_folha_departamento` — total de colaboradores, folha salarial e média por departamento
  - `vw_horas_projeto` — total de horas e colaboradores por projeto
  - `vw_estrutura_hierarquica` — organograma com supervisor e departamento
  - `vw_fato_horas` — tabela fato com funcionário, projeto e horas trabalhadas

### 2.3 Pipeline de Integração ✅
- Dados exportados do MySQL para CSV (limitação do `secure_file_priv`).
- 6 tabelas importadas no Power BI via Power Query.
- Cabeçalhos, tipagem e nulos tratados.
- `employee.Super_ssn` nulo identificado como indicador de hierarquia alta (James Borg — topo da organização).

### 2.4 Transformações no Power Query ✅
Todas as transformações do desafio foram aplicadas com sucesso:

| # | Transformação | Tabela |
|---|---|---|
| 1 | `Fname` + `Lname` mesclados em `FullName` | `employee` |
| 2 | `Address` dividido em `Street_Number`, `Street_Name`, `City`, `State` | `employee` |
| 3 | Mesclagem `employee` + `department` → coluna `Dname` adicionada | `employee` |
| 4 | Auto-join `employee` → coluna `Manager` adicionada via `Super_ssn` ↔ `Ssn` | `employee` |
| 5 | Nova tabela `department_locations` com `Dname` + `Dlocation` (para star schema) | `department_locations` |
| 6 | Nova tabela `employee_por_gerente` com contagem de colaboradores por gerente | `employee_por_gerente` |

#### Decisões técnicas documentadas

**Mesclar vs. Atribuir/Acrescentar:**
A operação de **mesclagem** foi utilizada (e não atribuição) nas junções entre tabelas porque o objetivo era enriquecer os registros existentes com informações de outra tabela (ex: adicionar o nome do departamento a cada funcionário). A atribuição/acréscimo serve para empilhar linhas de tabelas com a mesma estrutura — não para cruzar informações entre entidades distintas.

**Limitação conhecida — endereço de Ramesh Narayan:**
O endereço `975-Fire-Oak-Humble-TX` contém hífen extra no nome da rua. A divisão por delimitador `-` gerou uma coluna extra (`Address.5`). Solução aplicada: substituição manual do valor `Fire` por `Fire-Oak` na coluna `Street_Name`, correção de `Oak` para `Humble` em `City` e ajuste do `State`. A coluna `Address.5` vazia foi então removida.

**Tipo de junção — Externa Esquerda (Left Outer):**
Utilizada em todas as mesclagens para garantir que todos os registros da tabela base sejam preservados, mesmo sem correspondência na tabela secundária (ex: James Borg sem gerente).

**Tabelas preservadas vs. derivadas:**
As tabelas `department` e `employee` originais foram preservadas. As transformações que geram múltiplas linhas por registro (mesclagem com localizações, agrupamento por gerente) foram aplicadas em novas consultas derivadas (`department_locations`, `employee_por_gerente`), evitando quebra de relacionamentos no modelo.

### 2.5 Verificação de Horas e Hierarquia ✅
- Caso identificado: **James Borg (SSN 888665555)** vinculado ao projeto **Reorganization (Pno 20)** com **0 horas** — indica papel estratégico/supervisão.
- Detalhes completos em: [04-verificacao_horas_e_hierarquia.md](04-verificacao_horas_e_hierarquia.md)

---

## 3. Próximos Passos

1. **Construção do modelo dimensional (star schema)** no Power BI
2. **Criação de medidas DAX** para métricas executivas
3. **Desenvolvimento do dashboard corporativo**
4. **Publicação e documentação final**

---

## 4. Observações Finais
- Nenhuma inconsistência grave encontrada.
- Casos de 0 horas mantidos para refletir hierarquia e participação estratégica.
- Todas as decisões técnicas foram documentadas para garantir rastreabilidade.