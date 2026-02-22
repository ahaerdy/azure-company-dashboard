
# 🔗 Estrutura Relacional

O modelo contempla:

* Employee → Department (1:N)
* Employee → Employee (Supervisor)
* Department → Project (1:N)
* Employee → Project (N:N via works_on)
* Employee → Dependent (1:N)

Simula uma estrutura corporativa corporativa realista com:

* Estrutura organizacional
* Hierarquia de supervisão
* Controle de projetos
* Alocação de horas
* Folha salarial

---

# ☁️ Ambiente de Dados

O projeto foi desenvolvido com:

* Banco de dados em MySQL
* Instância criada na Microsoft Azure
* Integração analítica via Microsoft Power BI Desktop

Devido a restrições técnicas de driver no ambiente local, os dados foram exportados para arquivos CSV utilizando `SELECT INTO OUTFILE`, mantendo integridade estrutural da base.

---

# 📦 Pipeline de Integração

MySQL (Azure)
⬇
Exportação CSV
⬇
Power Query (Tratamento e Transformação)
⬇
Modelo Analítico
⬇
Dashboard Executivo

Essa abordagem manteve a arquitetura em camadas e garantiu continuidade do projeto.

---

# 🧹 Transformações Realizadas (Power Query)

Conforme diretrizes do desafio:

### ✔ 1. Verificação de Cabeçalhos

Os arquivos CSV gerados não continham nomes de colunas.
As colunas foram renomeadas manualmente conforme o modelo relacional original.

### ✔ 2. Ajuste de Tipos de Dados

* Salary → Decimal Number
* Datas → Tipo Date
* Identificadores → Texto
* Chaves Numéricas → Whole Number

### ✔ 3. Tratamento de Nulos

* Identificação de colaboradores sem `super_ssn` (possíveis gerentes)
* Verificação de departamentos sem gerente
* Análise de integridade hierárquica

### ✔ 4. Validação de Horas de Projeto

* Conferência de horas nulas
* Verificação de valores inconsistentes

### ✔ 5. Mesclas Realizadas

* Employee + Department (Left Join)
* Inclusão do nome do departamento na base de colaboradores
* Junção para identificação do nome do gerente

Justificativa técnica:
Foi utilizada mescla (merge) em vez de atribuição direta, pois os dados estavam distribuídos em entidades normalizadas, exigindo junção relacional.

### ✔ 6. Consolidação de Campos

* Mescla de Nome + Sobrenome → Nome Completo
* Mescla Departamento + Localização → Identificador único departamento-local

### ✔ 7. Remoção de Colunas Desnecessárias

Campos técnicos não utilizados no relatório foram removidos para otimização do modelo.

---

# 📊 Evolução Arquitetural

Banco Relacional Normalizado
⬇
Camada Analítica (Views SQL)
⬇
Transformação Power Query
⬇
Modelo Estrela (em preparação)
⬇
Dashboard Executivo

Essa progressão demonstra:

* Separação clara de responsabilidades
* Governança de dados
* Preparação para BI corporativo

---

# 🧠 Competências Demonstradas

* Modelagem relacional normalizada
* Integridade referencial
* Resolução de dependência circular
* Criação de camada analítica (views)
* Transformação de dados no Power Query
* Tratamento de qualidade de dados
* Construção de modelo analítico
* Integração MySQL → Power BI
* Documentação técnica estruturada

---

# 📊 Status do Projeto

- ✔ Instância MySQL criada na Azure
- ✔ Base relacional implementada
- ✔ Camada analítica construída
- ✔ Exportação e integração com Power BI
- 🔄 Transformações e modelagem dimensional em andamento
- 🔄 Dashboard executivo em desenvolvimento

---

# 🚀 Próxima Etapa

* Finalização do modelo estrela
* Criação das métricas DAX
* Construção da página executiva
* Publicação do relatório Power BI
