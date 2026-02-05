\# dbt Models – NHS Prescribing Analytics

--



This directory contains the dbt transformation layer for the \*\*NHS Prescribing Cost \& Efficiency Platform\*\*.





It is responsible for:

\- cleaning and standardising raw NHS prescribing datasets,

\- modelling multi-grain fact and dimension tables (chemical, presentation, SNOMED),

\- enforcing referential integrity via schema and relationship tests, and

\- producing analytics-ready tables for downstream reporting in Power BI.





The project follows a layered dbt structure:

\- \*\*staging\*\* – type casting, normalization, de-duplication

\- \*\*intermediate\*\* – grain alignment and reusable logic

\- \*\*marts\*\* – star/galaxy schema with validated facts and dimensions

