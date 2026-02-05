# dbt Models – NHS Prescribing Analytics

---

This directory contains the **dbt transformation layer** for the **NHS Prescribing Cost & Efficiency Platform**.

It is responsible for:

- Cleaning and standardising raw NHS prescribing datasets  
- Modelling multi-grain fact and dimension tables (**chemical, presentation, SNOMED**)  
- Enforcing referential integrity via **schema and relationship tests**  
- Producing analytics-ready tables for reporting in **Power BI**

---

## Project Structure

The project follows a layered dbt structure:

- **staging**  
  Type casting, normalisation, and de-duplication of raw source data

- **intermediate**  
  Grain alignment, surrogate key generation, and reusable transformation logic

- **marts**  
  Validated fact and dimension tables organised in a **star / galaxy schema**
