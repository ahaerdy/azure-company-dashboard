# 00 - Resumo Executivo do Estado Atual do Projeto

## 1. Objetivo do Projeto
O projeto visa integrar dados com **MySQL Azure** e transformá-los para análise em **Power BI**, seguindo o desafio proposto na disciplina. O foco é criar um modelo analítico consistente e pronto para relatórios corporativos, garantindo qualidade e integridade dos dados.

---

## 2. Estado Atual do Projeto

### 2.1 Modelagem Relacional
- Tabelas principais: `employee`, `department`, `project`, `works_on`.
- Relações definidas:
  - `employee.Dno → department.Dnumber`
  - `project.Dnum → department.Dnumber`
  - `works_on.Essn → employee.Ssn`
  - `works_on.Pno → project.Pnumber`

### 2.2 Limpeza e Transformação de Dados
- Tipos de dados ajustados (valores monetários para `double` / `decimal`).
- Nulos analisados e tratados:
  - `employee.Super_ssn` nulo identificado como **indicador de hierarquia alta**.
- Colunas complexas ainda serão separadas nos próximos passos.

### 2.3 Verificação de Horas e Hierarquia de Funcionários
- Foi realizada análise da tabela `works_on` para verificar consistência do número de horas por projeto.
- Caso identificado: **James Borg (SSN 888665555)** vinculado ao projeto **Reorganization (Pno 20)** com **0 horas** — indica papel estratégico/supervisão.
- Consulta de `Super_ssn` mostrou funcionários sem gerente, confirmando posições hierárquicas altas.
- Agregação por projeto confirma **quantos funcionários sem gerente estão vinculados a cada projeto**.
- Detalhes completos das queries, resultados e interpretações estão disponíveis em: [04-verificacao_horas_e_hierarquia.md](04-verificacao_horas_e_hierarquia.md)

---

## 3. Próximos Passos do Desafio

1. **Separar colunas complexas**
   - Transformar colunas que contêm múltiplas informações em colunas distintas para análise (ex.: FullName, Endereço detalhado).
2. **Mesclar consultas `employee` e `department`**
   - Criar tabela `employee` com o **nome do departamento associado** a cada funcionário.
   - Tipo de junção dependerá da necessidade de manter funcionários sem departamento.
3. **Eliminar colunas desnecessárias**
   - Limpar a tabela final, mantendo apenas colunas relevantes para análises e relatório Power BI.

---

## 4. Observações Finais
- Nenhuma inconsistência grave encontrada até o momento.
- Casos de 0 horas devem ser mantidos para refletir a **hierarquia e participação estratégica**.
- O histórico detalhado das verificações garante rastreabilidade e facilita futuras análises.
