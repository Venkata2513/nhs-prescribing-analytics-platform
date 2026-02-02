#### **# NHS Prescribing Cost \& Efficiency Platform**  

#### **\*\*(AWS Redshift · dbt · PowerBI )\*\***

#### 

#### **A cloud-based analytical platform identifying \*\*£252.5M in annual prescribing efficiency opportunities\*\*, while providing deep insights into prescribing patterns and cost drivers across England’s \*\*42 Integrated Care Boards (ICBs)\*\*.**

#### 

#### **---**

#### 

#### **##  Overview**

#### 

#### **NHS prescribing expenditure exceeds \*\*£11B annually\*\*, yet clinically equivalent and lower-cost generic alternatives are not consistently prescribed.**

#### 

#### **This project transforms large, fragmented NHS prescribing datasets into a \*\*governed analytical warehouse\*\* to:**

#### 

#### **- quantify prescribing costs,**

#### **- identify unwarranted variation, and**

#### **- estimate evidence-based generic switching opportunities.**

#### 

#### **Built by a \*\*GPhC-registered Pharmacist\*\*, the platform combines clinical domain expertise with modern analytics engineering to ensure insights are \*\*clinically valid, reproducible, and policy-relevant\*\*.**

#### 

#### **---**

#### 

#### **##  Key Findings (FY 2024/25)**

#### 

#### **- \*\*Total Prescribing Cost:\*\* £11.15B**  

#### **- \*\*Total Items Dispensed:\*\* 1.26B**  

#### **- \*\*Average Cost per Item:\*\* £8.84**  

#### **- \*\*Estimated Annual Efficiency Opportunity:\*\* \*\*£252.5M\*\***

#### 

#### **Savings are concentrated primarily within:**

#### 

#### **- \*\*BNF Central Nervous System (CNS)\*\* chapter**

#### **- A small number of high-impact branded products**

#### 

#### **---**

#### 

#### **##  Validation**

#### 

#### **Aggregated outputs reconcile with \*\*published NHSBSA Prescribing Cost Analysis (PCA)\*\* national summaries, providing external validation of:**

#### 

#### **- data ingestion,**

#### **- transformation logic, and**

#### **- analytical modelling.**

#### 

#### **---**

#### 

#### **##  Architecture \& Tech Stack**

#### 

#### **### Pipeline** 



#### **Excel → Python → Amazon S3 → Redshift Serverless → dbt → Power BI**





**### Cloud \& Data**



**- \*\*AWS\*\***

  **- Amazon S3 (raw data lake)**

  **- Amazon Redshift Serverless (analytical warehouse)**

  **- IAM (secure, role-based access)**



**### Transformation**



**- \*\*dbt Core\*\***

  **- Staging, intermediate, and marts layers**

  **- Schema and relationship testing for referential integrity**



**### Modelling**



**- \*\*Galaxy (Constellation) Schema\*\***

  **- Supports multiple analytical grains**

  **- Prevents double-counting of spend**



**### Visualisation**



**- \*\*Power BI\*\***

  **- KPI dashboards**

  **- Savings treemaps**

  **- Brand-level variance analysis**



**---**



**## 🧬 Data Modelling: A Pharmacist–Engineer Perspective**



**The central challenge of NHS prescribing data is \*\*grain alignment\*\*.**



**This platform reconciles three clinically distinct grains:**



**| Grain        | Purpose                                      |**

**|-------------|----------------------------------------------|**

**| Chemical     | Macro-level spend and volume trends           |**

**| Presentation | Operational and supply-chain analysis         |**

**| SNOMED       | Clinical concept, specificity, formulation   |**



**SNOMED is retained as a \*\*degenerate attribute\*\* within the fact table (Phase 1) to preserve clinical accuracy without unnecessary dimensional explosion.**



**A \*\*Galaxy schema\*\* enables concurrent analysis across these grains while maintaining referential integrity and preventing double counting.**



**---**



**## Savings Methodology (£252.5M)**



**Savings are estimated using a \*\*Price-Per-Unit (PPU) variance model\*\*:**



**Savings = (Brand Cost per Item − Generic Benchmark Cost per Item) × Brand Items**





**### Generic Benchmarks**



**Benchmarks are calculated \*\*like-for-like\*\* across:**



**- the same \*\*chemical substance\*\*,**

**- the same \*\*unit of measure\*\*, and**

**- the same \*\*time period\*\*.**



**This ensures clinically appropriate comparisons and avoids overstating savings where substitution may not be feasible.**



**---**



**## 🛠 Engineering Challenges Addressed**



**### Ingestion Diagnostics**

**Used `sys\_load\_error\_detail` in Redshift Serverless to resolve COPY failures caused by verbose free-text NHS fields exceeding standard DDL limits.**



**### Surrogate Key Generation**

**Implemented \*\*MD5-based surrogate keys\*\* in dbt to guarantee stable joins across:**



**- ~770k SNOMED-level rows**  

**- 42 ICBs**  

**- multi-grain fact tables**  



**### Identity \& Access Management**

**Configured IAM roles for secure, credential-free S3 ingestion into Redshift Serverless.**



**---**



**##  Visual Outputs (Power BI)**



**- \*\*National KPI Dashboard\*\* – spend, volume, and cost drivers**  

**- \*\*Savings Treemap\*\* – £252.5M opportunity by BNF chapter and section**  

**- \*\*Branded Leaderboard\*\* – products contributing most to prescribing variance**  



**\*(Screenshots available in `/docs/screenshots`)\***



**---**



**##  Future Enhancements (Phase 2)**



**- \*\*dm+d enrichment:\*\* Explicit SNOMED → VMP / AMP mapping for actionable switching lists**  

**- \*\*Multi-year longitudinal analysis\*\***  

**- \*\*CI/CD:\*\* Automated dbt testing via GitHub Actions**  

**- \*\*Orchestration:\*\* Migration of Python ingestion to AWS Lambda or Airflow**  















