# 04 - Verificação de Horas e Hierarquia (Tabela works_on e Super_ssn)

## Objetivo
Documentar as verificações realizadas nas tabelas `works_on` e `employee`, com foco no número de horas por projeto e na análise de funcionários sem gerente (`Super_ssn IS NULL`). Este documento complementa o resumo executivo do projeto.

---

## 1. Verificação da Tabela `works_on`

### 1.1 Observações
- Colunas analisadas: `Essn`, `Pno`, `Hours`.
- Todas as horas estão preenchidas e consistentes.
- Caso especial identificado:
  - Funcionário **James Borg (SSN 888665555)** vinculado ao projeto **20 - Reorganization** com **0 horas**.

### 1.2 Query utilizada
```sql
SELECT * FROM works_on;
````

### 1.3 Conclusão

* Horas zeradas indicam **participação estratégica ou supervisão**, não execução direta de tarefas.
* Nenhuma inconsistência crítica encontrada na tabela.

---

## 2. Funcionários sem Gerente

### 2.1 Objetivo

Identificar colaboradores com `Super_ssn` nulo para validar a hierarquia organizacional.

### 2.2 Query utilizada

```sql
SELECT
    e.Ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS EmployeeName,
    e.Super_ssn,
    w.Pno AS ProjectNumber,
    p.Pname AS ProjectName,
    w.Hours
FROM employee e
LEFT JOIN works_on w ON e.Ssn = w.Essn
LEFT JOIN project p ON w.Pno = p.Pnumber
WHERE e.Super_ssn IS NULL;
```

### 2.3 Resultado principal

| Ssn       | EmployeeName | Super_ssn | ProjectNumber | ProjectName    | Hours |
| --------- | ------------ | --------- | ------------- | -------------- | ----- |
| 888665555 | James Borg   | NULL      | 20            | Reorganization | 0.0   |

### 2.4 Conclusão

* Funcionário **no topo da hierarquia**, possivelmente gerente ou membro da alta direção.
* Vinculado a projeto estratégico com **0 horas efetivas**.

---

## 3. Agregação por Projeto

### 3.1 Objetivo

Verificar **quantos colaboradores sem gerente** estão associados a cada projeto e o total de horas.

### 3.2 Query utilizada

```sql
SELECT
    w.Pno AS ProjectNumber,
    p.Pname AS ProjectName,
    COUNT(e.Ssn) AS NumEmployeesWithoutManager,
    SUM(w.Hours) AS TotalHoursWithoutManager
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE e.Super_ssn IS NULL
GROUP BY w.Pno, p.Pname
ORDER BY w.Pno;
```

### 3.3 Resultado esperado

| ProjectNumber | ProjectName    | NumEmployeesWithoutManager | TotalHoursWithoutManager |
| ------------- | -------------- | -------------------------- | ------------------------ |
| 20            | Reorganization | 1                          | 0                        |

### 3.4 Conclusão

* Projeto 20 (“Reorganization”) possui **1 funcionário sem gerente**.
* Total de horas = 0 → reforça papel estratégico ou de supervisão.

---

## 4. Observações Finais

* Não foram encontradas inconsistências graves.
* Registros com **0 horas** devem ser mantidos para refletir hierarquia e participação estratégica.
* Próximo passo: continuar verificações das demais colunas e transformações conforme o desafio do projeto.
