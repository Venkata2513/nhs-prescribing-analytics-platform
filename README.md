# NHS Prescribing Cost & Efficiency Platform

**AWS Redshift · dbt · PowerBI**

A cloud-based analytical platform identifying **£252.5M in annual prescribing efficiency opportunities**, while providing deep insights into prescribing patterns and cost drivers across England’s **42 Integrated Care Boards (ICBs)**.

---

## Overview
NHS prescribing expenditure exceeds **£11B annually**, yet clinically equivalent and lower-cost generic alternatives are not consistently prescribed. 

This project transforms large, fragmented NHS prescribing datasets into a **governed analytical warehouse** to:
- Quantify prescribing costs
- Identify unwarranted variation
- Estimate evidence-based generic switching opportunities

Built by a **GPhC-registered Pharmacist**, the platform combines clinical domain expertise with modern analytics engineering to ensure insights are **clinically valid, reproducible, and policy-relevant**.

---

## Key Findings (FY 2024/25)
*   **Total Prescribing Cost:** £11.15B
*   **Total Items Dispensed:** 1.26B
*   **Average Cost per Item:** £8.84
*   **Estimated Annual Efficiency Opportunity:** **£252.5M**

Savings are concentrated primarily within the **BNF Central Nervous System (CNS)** chapter and a small number of high-impact branded products.

---

## Validation
Aggregated outputs reconcile with [NHSBSA Prescribing Cost Analysis (PCA)](https://www.nhsbsa.nhs.uk) national summaries, providing external validation of data ingestion, transformation logic, and analytical modelling.

---

## Architecture & Tech Stack

### Cloud & Data
*   **AWS:** Amazon S3 (raw data lake), Redshift Serverless (analytical warehouse)
*   **Security:** IAM (secure, role-based access)

### Transformation & Modelling
*   **dbt Core:** Staging, intermediate, and marts layers
*   **Testing:** Schema and relationship testing for referential integrity
*   **Schema:** **Galaxy (Constellation) Schema** to support multiple analytical grains

### Visualisation
*   **Power BI:** KPI dashboards, Savings treemaps, and Brand-level variance analysis

---

## Data Modelling: A Pharmacist–Engineer Perspective
The central challenge of NHS prescribing data is **grain alignment**. This platform reconciles three clinically distinct grains:

| Grain | Purpose |
| :--- | :--- |
| **Chemical** | Macro-level spend and volume trends |
| **Presentation** | Operational and supply-chain analysis |
| **SNOMED** | Clinical concept, specificity, formulation |

SNOMED is retained as a **degenerate attribute** within the fact table to preserve clinical accuracy without unnecessary dimensional explosion.

---

## Savings Methodology (£252.5M)
Savings are estimated using a **Price-Per-Unit (PPU) variance model**:
`Savings = (Brand Cost per Item − Generic Benchmark Cost per Item) × Brand Items`

### Generic Benchmarks
Benchmarks are calculated **like-for-like** across the same chemical substance, unit of measure, and time period. This ensures clinically appropriate comparisons.

---

## Engineering Challenges Addressed
*   **Ingestion Diagnostics:** Used `sys_load_error_detail` in Redshift to resolve COPY failures caused by verbose free-text NHS fields.
*   **Surrogate Key Generation:** Implemented **MD5-based surrogate keys** in dbt to guarantee stable joins across:

   *   ~63k chemical substance rows
   *   ~600k presentation rows
   *   ~770k SNOMED-level rows
   *   42 ICBs

*   **Identity & Access Management:** Configured IAM roles for secure, credential-free S3 ingestion into Redshift.

---

## Future Enhancements (Phase 2)
*   **dm+d enrichment:** Explicit SNOMED → VMP / AMP mapping for actionable switching lists.
*   **CI/CD:** Automated dbt testing via [GitHub Actions](https://github.com).
*   **Orchestration:** Migration of Python ingestion to [AWS Lambda](https://aws.amazon.com).
