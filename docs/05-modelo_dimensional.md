# 05 - Modelo Dimensional (Star Schema)

## 🎯 Objetivo da Etapa

Configurar os relacionamentos entre as tabelas no Power BI, estruturando o modelo dimensional no formato **Star Schema** para garantir que as métricas calculem corretamente e os visuais do dashboard funcionem de forma consistente.

---

## 🌟 O que é um Star Schema?

O modelo estrela organiza os dados em dois tipos de tabela:

- **Tabela Fato** — registra eventos, transações ou ocorrências. Contém métricas numéricas e chaves estrangeiras que apontam para as dimensões.
- **Tabelas Dimensão** — descrevem o contexto dos eventos. Contêm atributos descritivos usados para filtrar e agrupar.

Esse modelo é preferido em BI porque:
- Simplifica consultas analíticas
- Melhora a performance dos visuais
- Facilita a criação de medidas DAX

---

## 🏗 Estrutura do Modelo

### Tabela Fato

| Tabela | Descrição |
|---|---|
| `works_on` | Registra quem trabalhou em qual projeto e por quantas horas |

### Tabelas Dimensão

| Tabela | Descrição |
|---|---|
| `employee` | Colaboradores, hierarquia, departamento e gerente |
| `departament` | Departamentos e seus gerentes |
| `project` | Projetos e suas localizações |
| `dependent` | Dependentes dos colaboradores |

### Tabelas Auxiliares (sem relacionamento no modelo)

| Tabela | Descrição | Uso |
|---|---|---|
| `dept_locations` | Localizações por departamento | Referência direta em visuais |
| `department_locations` | Departamento + Localização consolidados | Visuais de mapa/localização |
| `employee_por_gerente` | Contagem de colaboradores por gerente | Visuais de hierarquia |

---

## 🔗 Relacionamentos Configurados

| # | Da Tabela | Coluna | Para Tabela | Coluna | Cardinalidade | Filtro |
|---|---|---|---|---|---|---|
| 1 | `works_on` | `Essn` | `employee` | `Ssn` | Muitos:1 (*:1) | Único |
| 2 | `works_on` | `Pno` | `project` | `Pnumber` | Muitos:1 (*:1) | Único |
| 3 | `employee` | `Dno` | `departament` | `Dnumber` | Muitos:1 (*:1) | Único |
| 4 | `dependent` | `Essn` | `employee` | `Ssn` | Muitos:1 (*:1) | Único |
| 5 | `project` | `Dnum` | `departament` | `Dnumber` | Muitos:1 (*:1) | Único |

---

## 📐 Diagrama do Modelo

```
         dependent
              ↓ (Essn → Ssn)
departament ←── employee ←── works_on (FATO)
     ↑               ↑            ↓ (Pno → Pnumber)
     └───────── project ──────────┘
         (Dnum → Dnumber)
```

---

## ⚠️ Aviso de Caminhos Ambíguos

Ao criar o relacionamento `project → departament`, o Power BI emitiu o aviso:

> *"Há caminhos ambíguos entre works_on e departament: works_on → employee → departament e works_on → project → departament"*

Esse aviso é esperado e não representa erro. Ocorre porque existem dois caminhos para chegar a `departament` a partir de `works_on`. O Power BI usa o caminho padrão automaticamente para a maioria dos visuais. Quando necessário, medidas DAX com `USERELATIONSHIP()` podem especificar explicitamente qual caminho utilizar.

---

## 🔧 Correção Aplicada — Coluna Hours

Durante a configuração do modelo, foi identificado que os valores da coluna `Hours` estavam multiplicados por 10 devido a problema de separador decimal na importação do CSV.

Correção aplicada no Power Query: tipo alterado para Número Decimal e valores divididos por 10.

Valores corrigidos confirmados:

| Colaborador | Projeto | Hours (correto) |
|---|---|---|
| John Smith | ProductX | 32.5 |
| John Smith | ProductY | 7.5 |
| Ramesh Narayan | ProductZ | 40.0 |
| James Borg | Reorganization | 0.0 |

---

## ✅ Status desta Etapa

Concluída. Modelo dimensional configurado, relacionamentos validados e correção de dados aplicada.

## 🎯 Próxima Etapa

Criação de medidas DAX para métricas executivas do dashboard corporativo.
