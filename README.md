#### **NHS Prescribing Data Platform**



AWS • Redshift Serverless • dbt • SNOMED



**Overview**



End-to-end cloud data engineering pipeline built by a Pharmacist on real NHS prescribing data to analyse prescribing behaviour, costs, and efficiency opportunities across England at Integrated Care Board (ICB) level.



**Architecture**



Excel → Python → Amazon S3 → Redshift Serverless → dbt → Analytics



Source data converted from Excel to CSV using Python (pandas +openpyxl)



Raw data ingested into Amazon S3



Amazon Redshift Serverless used as the analytical warehouse



dbt used for transformation and analytics-layer modelling



**Data Sources**



NHS Business Services Authority (NHSBSA)

Prescribing Cost Analysis (PCA) Summary Tables ICB Level  — FY 2024/25



Datasets used:



Chemical-level prescribing



Presentation-level prescribing



SNOMED-enhanced prescribing data



**Technology Stack**



AWS: S3, Redshift Serverless, IAM



dbt Core



SQL (Redshift)



Python (pandas) for data preparation



**Data Modelling Approach (Summary)**



A galaxy (constellation) schema is used to support multiple analytical grains without conflating measures.



Chemical-level fact for high-level cost and volume analysis



Presentation / SNOMED-level fact for detailed product and prescribing-context analysis



Shared dimensions for time, geography, BNF hierarchy, supplier, and prescribing context



This design avoids deriving metrics across incompatible grains and preserves clinical and operational meaning.



**Canonical Fact Design (Current)**



Fact table: fct\_prescribing\_snomed\_icb

Source: raw.snomed\_presentations



Grain :

financial\_year

× icb\_code

× bnf\_presentation\_code

× prescribing\_context

× supplier\_name

× snomed\_code



Exact duplicates are removed at this grain during staging.



**Why SNOMED is Modelled in the Fact**



SNOMED codes vary by presentation and prescribing context, and multiple SNOMED codes may exist for the same BNF presentation.



Placing SNOMED in a dimension would:



* lose valid clinical distinctions, or



* introduce duplicated dimension rows.



Decision:

Model snomed\_code as a degenerate attribute in the fact table for Phase 1.



Future phase:

Introduce a dedicated dim\_snomed with dm+d (VMP / AMP) mappings for longitudinal or clinical hierarchy analysis.



**Key Engineering Challenges Solved**



Migrating large NHS datasets into Redshift Serverless



Handling verbose free-text fields causing COPY failures



Debugging IAM + S3 and Securitygroup permissions for serverless COPY operations



Using Redshift system views (sys\_load\_error\_detail) for ingestion diagnostics



Designing fact grain based on clinical reality, not convenience



**Current Status**



AWS infrastructure provisioned



Raw data successfully loaded:



~63k chemical substance rows



~600k presentation rows



~770k SNOMED-level rows



Staging and analytics-layer models in progress



**Future Enhancements**



dm+d (VMP / AMP) enrichment



Multi-year longitudinal analysis



Supplier volatility and cost-variance metrics



Curated datasets exposed for downstream analytics or SaaS use cases



Additional Documentation



Detailed grain analysis: /docs/grain-discovery.md



Data model notes: /docs/data\_model.md



Architecture notes: /docs/architecture.md



