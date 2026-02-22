# 03 - Pipeline de Integração e Tratamento de Dados

## 1. Contexto

Devido à configuração `secure_file_priv` do MySQL, os dados foram exportados para CSV e posteriormente importados no Power BI.

Pipeline adotado:

MySQL → CSV → Power Query → Modelo Analítico

---

## 2. Importação das Tabelas

Foram importadas 6 tabelas:

* employee
* department
* dept_locations
* project
* works_on
* dependent

---

## 3. Tratamentos Aplicados

### 3.1 Ajuste de Cabeçalhos

Correção da opção "Usar primeira linha como cabeçalho" quando aplicada incorretamente.

### 3.2 Tipagem de Dados

* Campos monetários convertidos para Número Decimal (double preciso).
* Campos identificadores ajustados para tipo adequado.

### 3.3 Tratamento de Nulos

Foi realizada verificação de valores nulos em todas as tabelas.

Resultado:

* Apenas 1 valor nulo identificado.
* Localização: `employee.Super_ssn`

### 3.4 Análise do Nulo em Super_ssn

A coluna `Super_ssn` representa o supervisor do colaborador.

A análise identificou que o único valor nulo corresponde ao colaborador no topo da hierarquia organizacional.

Conclusão:

* O nulo é estrutural.
* Não foi removido.
* Mantém coerência hierárquica do modelo.

---

## 4. Validação

* Integridade relacional preservada.
* Nenhuma inconsistência estrutural identificada.
* Dados prontos para modelagem dimensional.

---

## 5. Próxima Etapa

Construção do modelo estrela e criação das primeiras medidas DAX para análise executiva.
