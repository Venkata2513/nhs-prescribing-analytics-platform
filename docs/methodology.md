# Methodology


## Problem Statement



NHS prescribing datasets are large, fragmented, and published at multiple clinical and operational grains. While national cost summaries exist, they do not explain **where** prescribing inefficiencies arise or **how** they can be addressed safely, Also they have a **visibility ceiling**, meaning those reports are pre-defined and do not allow ad-hoc analysis to gain more granular insights. 



This project aims to quantify **evidence-based prescribing efficiency opportunities** by comparing branded and generic prescribing on a like-for-like basis, without double-counting spend or violating clinical substitution rules. Also allows you perform granular, ad-hoc deep-dives into specific ICBs, branded volumes, and therapeutic cost drivers. 



---


## Grain Discovery



A core design step was identifying and respecting the true analytical grains present in the data:



### 1. Chemical-level grain

- Financial Year × ICB × Chemical Substance

- Suitable for macro cost and volume trends



### 2. Presentation-level grain

- Financial Year × ICB × BNF Presentation

- Required for supplier and formulation analysis



### 3. SNOMED-level grain

- Financial Year × ICB × Presentation × Supplier × SNOMED × Prescribing Context

- Required to preserve clinical specificity and prescribing behaviour



Early exploratory profiling confirmed that collapsing these grains into a single table would cause:

- spend duplication

- incorrect aggregations

- invalid savings estimates



This directly informed the multi-fact Galaxy schema used in the warehouse.



---



## Savings Logic (£252.5M)



Savings are estimated using a **Price Per Item (PPI) variance model:**



Savings = (Brand Cost per Item − Generic Benchmark Cost per Item) × Brand Items





### Benchmark Construction

Generic benchmarks are computed:

- at the same financial year

- for the same chemical substance

- using the same unit of measure

- on a weighted average price benchamrk



This ensures comparisons are:

- clinically valid, policy relevant

- operationally realistic

- free from formulation mismatches



---



## Important Caveats



- Savings represent **opportunity**, not guaranteed cash release

- Some branded products do not have directly substitutable generic AMPs

-Only 39% of observable brands have true-to-true generic AMPs, this was due to absense of explicit VMP/AMP mapping in the raw dataset and masking a significant propotion of brands being under reported or ignored.  

- SNOMED → dm+d (VMP/AMP) mapping is required for prescriber-level switch lists



These limitations are explicitly acknowledged and addressed in the Phase 2 roadmap.



---



## Validation



Aggregated outputs align with:

- NHSBSA Prescribing Cost Analysis (PCA) national summaries



This provides external validation of:

- ingestion accuracy

- transformation logic

- grain integrity



