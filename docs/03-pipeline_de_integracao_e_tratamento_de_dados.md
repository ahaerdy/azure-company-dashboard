# 03 - Pipeline de Integração e Tratamento de Dados

## 1. Contexto

Devido à configuração `secure_file_priv` do MySQL, os dados foram exportados para CSV e posteriormente importados no Power BI.

Pipeline adotado:

```
MySQL → CSV → Power Query → Modelo Analítico
```

---

## 2. Importação das Tabelas

Foram importadas 6 tabelas via CSV:

| Tabela | Descrição |
|---|---|
| `employee` | Colaboradores e hierarquia |
| `department` | Departamentos |
| `dept_locations` | Localizações dos departamentos |
| `project` | Projetos |
| `works_on` | Alocação de funcionários em projetos |
| `dependent` | Dependentes dos funcionários |

---

## 3. Tratamentos Aplicados

### 3.1 Ajuste de Cabeçalhos

Correção da opção "Usar primeira linha como cabeçalho" quando aplicada incorretamente.

### 3.2 Tipagem de Dados

- Campos monetários (`Salary`) convertidos para Número Decimal (double preciso).
- Campos identificadores (`Ssn`, `Super_ssn`) ajustados para tipo Texto para permitir mesclagens.

### 3.3 Tratamento de Nulos

Verificação de valores nulos em todas as tabelas.

- Apenas 1 valor nulo identificado: `employee.Super_ssn`
- O nulo é estrutural — corresponde ao colaborador no topo da hierarquia (James Borg).
- Não foi removido. Mantém coerência hierárquica do modelo.

---

## 4. Transformações no Power Query

### 4.1 Mesclar Fname + Lname → FullName

Colunas `Fname` e `Lname` mescladas em uma única coluna `FullName` com separador espaço.

Exemplo: `John` + `Smith` → `John Smith`

### 4.2 Dividir coluna Address

A coluna `Address` no formato `731-Fondren-Houston-TX` foi dividida pelo delimitador `-` em 4 colunas:

| Coluna | Exemplo |
|---|---|
| `Street_Number` | 731 |
| `Street_Name` | Fondren |
| `City` | Houston |
| `State` | TX |

**Limitação conhecida:** O endereço `975-Fire-Oak-Humble-TX` (Ramesh Narayan) contém hífen extra no nome da rua, gerando uma coluna `Address.5` extra. Solução aplicada via substituição manual de valores:
- `Fire` → `Fire-Oak` em `Street_Name`
- `Oak` → `Humble` em `City`
- Coluna `Address.5` removida após correção.

### 4.3 Mesclar employee + department

Junção entre `employee` (coluna `Dno`) e `department` (coluna `Dnumber`) do tipo **Externa Esquerda**, adicionando a coluna `Dname` à tabela `employee`.

Resultado: cada funcionário passa a exibir o nome do seu departamento diretamente.

### 4.4 Auto-join employee → Manager

Junção da tabela `employee` consigo mesma via `Super_ssn` ↔ `Ssn`, do tipo **Externa Esquerda**, adicionando a coluna `Manager` com o nome completo do gerente de cada colaborador.

James Borg (topo da hierarquia) permanece com valor nulo em `Manager`.

**Observação técnica:** Foi necessário converter `Ssn` e `Super_ssn` para tipo Texto antes da mesclagem, pois os tipos divergentes impediam a junção.

### 4.5 Nova tabela department_locations

Criada por duplicação da tabela `department`, seguida de mesclagem com `dept_locations` via `Dnumber`, do tipo **Externa Esquerda**, adicionando a coluna `Dlocation`.

Cada departamento com múltiplas localizações gera múltiplas linhas — comportamento esperado e necessário para o modelo estrela.

| Dname | Dnumber | Dlocation |
|---|---|---|
| Headquarters | 1 | Houston |
| Administration | 4 | Stafford |
| Research | 5 | Bellaire |
| Research | 5 | Houston |
| Research | 5 | Sugarland |

**Por que mesclar e não atribuir?**
A mesclagem enriquece registros existentes cruzando informações entre entidades distintas. A atribuição/acréscimo serve para empilhar linhas de tabelas com a mesma estrutura — não é aplicável aqui.

### 4.6 Nova tabela employee_por_gerente

Criada por duplicação da tabela `employee`, seguida de agrupamento pela coluna `Manager` com contagem de linhas.

| Manager | Total_Colaboradores |
|---|---|
| Franklin Wong | 3 |
| James Borg | 2 |
| Jennifer Wallace | 2 |
| null | 1 |

O registro nulo representa James Borg — sem gerente por estar no topo da hierarquia.

### 4.7 Correção da coluna Hours

Durante a configuração do modelo dimensional, foi identificado que os valores da coluna `Hours` da tabela `works_on` estavam multiplicados por 10 (ex: `32.5` aparecia como `325`).

Causa: problema de separador decimal na importação do CSV — o ponto (`.`) não foi interpretado corretamente.

Solução aplicada no Power Query:
- Tipo da coluna alterado para **Número Decimal**
- Coluna dividida por **10** via Transformar → Padrão → Dividir

| Antes | Depois |
|---|---|
| 325 | 32.5 |
| 75 | 7.5 |
| 100 | 10.0 |
| 400 | 40.0 |
| 0 | 0.0 |

| Consulta | Tipo | Descrição |
|---|---|---|
| `employee` | Original transformada | Dados completos com FullName, Address separado, Dname e Manager |
| `department` | Original preservada | Departamentos sem alteração estrutural |
| `dept_locations` | Recriada manualmente | Localizações por departamento |
| `department_locations` | Derivada | Department + Dlocation para star schema |
| `project` | Original preservada | Projetos |
| `works_on` | Original preservada | Alocação de horas |
| `dependent` | Original preservada | Dependentes |
| `employee_por_gerente` | Derivada | Contagem de colaboradores por gerente |

---

## 6. Validação

- Integridade relacional preservada.
- Nenhuma inconsistência estrutural identificada.
- Todas as transformações aplicadas e carregadas com sucesso no Power BI.