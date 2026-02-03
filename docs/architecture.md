\# Architecture



\## High-Level Design



This project implements a modern, cloud-native analytical pipeline using AWS and dbt.



NHSBSA Excel Files

↓

Python (pandas)

↓

Amazon S3 (Raw Zone)

↓

Amazon Redshift Serverless

↓

dbt (Staging → Marts)

↓

Power BI



---



## Ingestion Layer



### Source

- NHS Business Services Authority (NHSBSA)

- Prescribing Cost Analysis ICB Summary Tables (FY 2024/25)



### Processing

- Large Excel files converted to CSV using Python

- Minimal transformation at this stage to keep it true to the source



---



## Storage \& Compute



### Amazon S3

- Raw data lake

- Immutable source storage



### Amazon Redshift Serverless

- Columnar analytical warehouse

- Auto-scaling compute

- Secure COPY ingestion from S3 via IAM roles



---



## Transformation Layer (dbt)



### Staging Models

- Type casting

- Null standardisation

- Financial year normalisation

- Deduplication at source grain



### Intermediate Models

- Grain alignment

- Key preparation for dimensions



### Mart Models

- Fact and dimension construction

- Surrogate key assignment

- Schema and relationship testing



---



## Analytics \& Visualisation



### Power BI

- KPI dashboard

- Savings treemap (BNF chapter / section)

- High-impact branded product leaderboard



Screenshots are provided in `/docs/Screenshots` to demonstrate analytical validation.



---



## Security \& Governance



- IAM roles for Redshift COPY operations

- No credentials embedded in code

- dbt artifacts and logs excluded from version control



---



## Scalability



The architecture is designed to support:

- Multi-year expansion

- Monthly EPD datasets

- dm+d enrichment

- Orchestrated ingestion (Phase 2)



