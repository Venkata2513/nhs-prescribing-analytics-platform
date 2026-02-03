select
    bnf_id,
    bnf_chemical_substance_code,
    bnf_chemical_substance_name,
    bnf_paragraph_code,
    bnf_paragraph_name,
    bnf_section_code,
    bnf_section_name,
    bnf_chapter_code,
    bnf_chapter_name
from {{ ref('int_dim_bnf') }}
