# Data Model



## Overview



The warehouse is modelled using a **Galaxy (Constellation) Schema** to support multiple analytical grains without double-counting or loss of clinical detail.



Two fact tables are used, sharing conformed dimensions.



---



## Fact Tables



### 1. `fct\_prescribing\_chemical\_icb`

**Grain**

- Financial Year

- ICB

- Chemical Substance



**Purpose**

- National and regional cost trends

- High-level benchmarking

- Population-adjusted metrics



---



### 2. `fct\_prescribing\_snomed\_icb`

**Grain**

- Financial Year

- ICB

- BNF Presentation

- Supplier

- SNOMED Code

- Prescribing Context



**Purpose**

- Prescribing behaviour analysis

- Brand vs generic variance

- Supplier and formulation effects



SNOMED codes are retained as **degenerate attributes** in the fact table to avoid dimensional explosion while preserving clinical accuracy.



---



## Dimensions



### `dim\_time`

- Financial Year

- Start / End Year attributes



### `dim\_geography`

- ICB Code

- ICB Name

- Region



### `dim\_bnf`

- Chemical Substance

- BNF Chapter

- BNF Section

- Hierarchical descriptors



### `dim\_supplier`

- Supplier Name

- Surrogate Supplier ID



### `dim\_prescribing\_context`

Represents **how** an item was prescribed in which context



Attributes include:

- preparation\_class

- prescribed\_preparation\_class

- advanced\_service\_type



This dimension is generated deterministically using hashed combinations of these attributes.



---



## Key Design Decisions



### Deterministic Surrogate Keys

- MD5 hashing used across all dimensions

- Ensures stable joins across rebuilds

- Avoids reliance on volatile natural keys



### No Presentation Dimension (Phase 1)

Presentation attributes required for analysis already exist in the canonical fact table.  

Introducing a separate presentation dimension would increase join complexity without analytical benefit at this stage.



---



## Testing \& Integrity



dbt schema tests enforce:

- uniqueness of surrogate keys

- non-null foreign keys

- referential integrity between facts and dimensions



