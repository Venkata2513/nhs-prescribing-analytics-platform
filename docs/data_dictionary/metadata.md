\# Data Dictionary \& Metadata



This project utilizes publicly available NHSBSA prescribing datasets. The following metadata is reproduced and structured from official NHSBSA documentation to ensure analytical integrity.



\## 1. Clinical \& BNF Hierarchy

These fields define the "Grain" of the medicinal products being analyzed.



| Field | Description |

| :--- | :--- |

| \*\*BNF Chapter\*\* | Broadest grouping (e.g., Gastro-Intestinal System). Includes Name and Code. |

| \*\*BNF Section / Paragraph\*\* | Intermediate therapeutical classifications sitting below the Chapter level. |

| \*\*BNF Chemical Substance\*\* | The main active ingredient (e.g., Amoxicillin). Appliances inherit the BNF section. |

| \*\*BNF Presentation\*\* | The specific type, strength, and formulation (e.g., Paracetamol 500mg tablets). |

| \*\*SNOMED Code\*\* | Unique computer-readable identifier (SNOMED CT) for Medicinal Products (VMP/AMP level). |

| \*\*Generic BNF Presentation\*\* | For proprietary drugs, this identifies the generic equivalent BNF code/name. |

| \*\*Preparation Class\*\* | Categorizes products into 5 classes (Generic, Proprietary, Appliance, etc.). Key for efficiency modeling. |

| \*\*Supplier Name\*\* | The manufacturer or wholesaler (e.g., TEVA, AAH Pharmaceuticals). |

| \*\*Unit of Measure\*\* | The smallest available unit (e.g., tablet, ml, gram). |



\## 2. Financial \& Quantitative Measures

The core metrics used to calculate the £252.5M savings opportunity.



| Field | Description |

| :--- | :--- |

| \*\*Total Cost (GBP)\*\* | Also known as Net Ingredient Cost (NIC). Based on Drug Tariff basic prices. |

| \*\*Total Items\*\* | Number of times a product appears on a prescription form (Paper or Electronic). |

| \*\*Total Quantity\*\* | Total count of units dispensed (Items × Quantity). |

| \*\*Cost Per Item (GBP)\*\* | Calculated as `Total Cost / Total Items`. |

| \*\*Cost Per Quantity (GBP)\*\* | Calculated as `Total Cost / Total Quantity`. |

| \*\*Quantity Per Item\*\* | The average quantity prescribed per single item. |



\## 3. Geography \& Population

The dimensions used to aggregate data at the Integrated Care Board (ICB) level.



| Field | Description |

| :--- | :--- |

| \*\*ICB Name / Code\*\* | The Integrated Care Board responsible for the prescribing organization. |

| \*\*Region Name / Code\*\* | The broader NHS region based on administrative records. |

| \*\*Population\*\* | ONS mid-year population estimates for the corresponding year. |

| \*\*Items Per 1,000 Pop\*\* | Normalized dispensing rate for cross-regional comparison. |

| \*\*Financial Year\*\* | Data period (1 April to 31 March). |



\## 4. Preparation Class Reference

This is the logic used to identify \*\*Class 3 (Branded)\*\* vs \*\*Class 1 (Generic)\*\* for savings benchmarks:



\* \*\*Class 1:\*\* Drugs prescribed and available generically.

\* \*\*Class 2:\*\* Prescribed generically but only available as proprietary.

\* \*\*Class 3:\*\* Prescribed and dispensed by proprietary brand name.

\* \*\*Class 4:\*\* Dressings, appliances, and medical devices.

\* \*\*Class 5:\*\* Prescribed generically with a named supplier.

