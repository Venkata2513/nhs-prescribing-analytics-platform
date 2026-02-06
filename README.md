# NHS Prescribing Cost & Efficiency Platform

**AWS Redshift · dbt · PowerBI**

A cloud-based analytical platform identifying **£252.5M in annual prescribing efficiency opportunities**, while providing deep insights into prescribing patterns and cost drivers across England’s **42 Integrated Care Boards (ICBs)**.

---

## Overview
NHS prescribing expenditure exceeds **£11B annually**, yet clinically equivalent and lower-cost generic alternatives are not consistently prescribed. While national cost summaries exist but those reports are pre-defined, static and do not allow custom analysis to gain more granular insights.

This project transforms large, fragmented NHS prescribing datasets into a **governed analytical warehouse** to:
- Quantify prescribing costs
- Identify unwarranted variation
- Estimate evidence-based generic switching opportunities

Built by a **GPhC registered Pharmacist**, the platform combines clinical domain expertise with modern analytics engineering to ensure insights are **clinically valid, reproducible, and policy-relevant**.

**Data Rationale:** This project uses prescription cost analysis (PCA) ICB-level summary dataset for FY 2024/25. For high-level strategic analysis, the ICB-level summary dataset presents as an ideal candidate. While the monthly English Prescribing Dataset (EPD) offers granular transaction-level detail, the summary dataset allows for **clearer broader benchmarks and variance analysis** without the unnecessary noise inherent in monthly EPD data.

---

## Key Findings (FY 2024/25)
*   **Total Prescribing Cost:** £11.15B
*   **Total Items Dispensed:** 1.26B
*   **Average Cost per Item:** £8.84
*   **Estimated Annual Efficiency Opportunity:** **£252.5M**

Savings are concentrated primarily within the **BNF Central Nervous System (CNS)** chapter and a small number of high-impact branded products.

---

## Validation
Aggregated outputs align with [NHSBSA Prescribing Cost Analysis (PCA)](https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england/prescription-cost-analysis-england-202425) national summaries, providing external validation of data ingestion, transformation logic, and analytical modelling.

---

## Architecture & Tech Stack

![System Architecture](https://github.com/Venkata2513/nhs-prescribing-analytics-platform/blob/main/docs/diagrams/NHS%20Prescribing%20Data%20Platform%20Architecture.png)

Fig 1: End-to-End Data Pipeline Architecture. (Galaxy Schema implemented within the dbt transformation layer to support multi-grain analysis)

### Cloud & Data
*   **AWS:** Amazon S3 (raw data lake), Redshift Serverless (analytical warehouse)
*   **Security:** IAM (secure, role-based access)

### Transformation & Modelling
*   **Python:** Pandas (data preparation, file conversion, ingestion support)
*   **dbt Core:** Staging, intermediate, and marts layers
*   **Testing:** Schema and relationship testing for referential integrity
*   **Schema:** **Galaxy (Constellation) Schema** to support multiple analytical grains

### Visualisation
*   **Power BI:** KPI dashboards, Savings tree maps, and Brand-level variance analysis

---

## Data Modelling: A Pharmacist–Engineer Perspective
The central challenge of NHS prescribing data is **grain alignment**. This platform reconciles three clinically distinct grains:

| Grain | Purpose |
| :--- | :--- |
| **Chemical** | Macro-level spend and volume trends |
| **Presentation** | Operational and supply-chain analysis |
| **SNOMED** | Clinical concept, specificity, formulation |

**Galaxy Schema** (also known as a constellation schema) has been chosen over separate star schemas to avoid:

* Duplication of several dimension tables

* More maintenance overhead

* Less efficiency for combined or comparative analysis (e.g. brand vs generic across both tables)

Two fact tables with conformed dimension tables, enable flexible, scalable, and joined analysis from both grain levels.

Due to absence of clear VMP/AMP mappings in the raw dataset - and to avoid unnecessary dimensional explosion - SNOMED is  retained as a **degenerate attribute** within the fact table in Phase 1. This is to preserve clinical specificity while maintaining a scalable model. SNOMED enrichment will be core Phase 2 enhancement of this project to give actionable prescribing insights. 



---

## Savings Methodology (£252.5M)
Savings are estimated using a **Price-Per-Unit (PPU) variance model**:
`Savings = (Brand Cost per Item − Generic Benchmark Cost per Item) × Brand Items`

### Generic Benchmarks
Benchmarks are calculated **like-for-like** across the same chemical substance, unit of measure, and time period. This ensures clinically appropriate comparisons.

Estimated savings should be interpreted as **economic opportunity** where prescribing variance exists rather than a switch list. This analysis acknowledges operational realities such as clinical suitability, strength, formulation and supplier volatility always guide prescribing decisions. 

---

## Engineering Challenges Addressed
*   **Ingestion Diagnostics:** Used `sys_load_error_detail` in Redshift to resolve COPY failures caused by long free-text NHS fields.
*   **Surrogate Key Generation:** Implemented **MD5-based surrogate keys** in dbt to guarantee stable joins across:<br>
    ~63k chemical substance rows<br>
    ~600k presentation rows<br>
    ~770k SNOMED-level rows<br>
      42 ICBs  
*   **Identity & Access Management:** Configured IAM roles for secure, credential-free S3 ingestion into Redshift.

---

## Future Enhancements (Phase 2)
*   **dm+d enrichment:** Explicit SNOMED → VMP / AMP mapping for actionable switching lists.
*   **Multi-year longitudinal analysis**
*   **CI/CD:** Automated dbt testing via [GitHub Actions](https://github.com).
*   **Orchestration:** Migration of Python ingestion to [AWS Lambda](https://aws.amazon.com).
