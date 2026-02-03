with from_chemicals as (

    select
        nullif(trim(bnf_chapter_code), '')              as bnf_chapter_code,
        nullif(trim(bnf_chapter_name), '')              as bnf_chapter_name,
        nullif(trim(bnf_section_code), '')              as bnf_section_code,
        nullif(trim(bnf_section_name), '')              as bnf_section_name,
        nullif(trim(bnf_paragraph_code), '')            as bnf_paragraph_code,
        nullif(trim(bnf_paragraph_name), '')            as bnf_paragraph_name,
        nullif(trim(bnf_chemical_substance_code), '')   as bnf_chemical_substance_code,
        nullif(trim(bnf_chemical_substance_name), '')   as bnf_chemical_substance_name
    from {{ ref('stg_chemical_substances') }}

),

from_presentations as (

    select
        nullif(trim(bnf_chapter_code), '')              as bnf_chapter_code,
        nullif(trim(bnf_chapter_name), '')              as bnf_chapter_name,
        nullif(trim(bnf_section_code), '')              as bnf_section_code,
        nullif(trim(bnf_section_name), '')              as bnf_section_name,
        nullif(trim(bnf_paragraph_code), '')            as bnf_paragraph_code,
        nullif(trim(bnf_paragraph_name), '')            as bnf_paragraph_name,
        nullif(trim(bnf_chemical_substance_code), '')   as bnf_chemical_substance_code,
        nullif(trim(bnf_chemical_substance_name), '')   as bnf_chemical_substance_name
    from {{ ref('stg_presentations') }}

),

from_snomed as (

    select
        nullif(trim(bnf_chapter_code), '')              as bnf_chapter_code,
        nullif(trim(bnf_chapter_name), '')              as bnf_chapter_name,
        nullif(trim(bnf_section_code), '')              as bnf_section_code,
        nullif(trim(bnf_section_name), '')              as bnf_section_name,
        nullif(trim(bnf_paragraph_code), '')            as bnf_paragraph_code,
        nullif(trim(bnf_paragraph_name), '')            as bnf_paragraph_name,
        nullif(trim(bnf_chemical_substance_code), '')   as bnf_chemical_substance_code,
        nullif(trim(bnf_chemical_substance_name), '')   as bnf_chemical_substance_name
    from {{ ref('stg_snomed_presentations') }}

),

unioned as (

    select * from from_chemicals
    union
    select * from from_presentations
    union
    select * from from_snomed

),

deduped as (

    select
        bnf_chemical_substance_code,
        max(bnf_chemical_substance_name) as bnf_chemical_substance_name,
        max(bnf_paragraph_code)          as bnf_paragraph_code,
        max(bnf_paragraph_name)          as bnf_paragraph_name,
        max(bnf_section_code)            as bnf_section_code,
        max(bnf_section_name)            as bnf_section_name,
        max(bnf_chapter_code)            as bnf_chapter_code,
        max(bnf_chapter_name)            as bnf_chapter_name
    from unioned
    where bnf_chemical_substance_code is not null
    group by bnf_chemical_substance_code

)

select
    md5(bnf_chemical_substance_code) as bnf_id,

    bnf_chemical_substance_code,
    bnf_chemical_substance_name,

    bnf_paragraph_code,
    bnf_paragraph_name,
    bnf_section_code,
    bnf_section_name,
    bnf_chapter_code,
    bnf_chapter_name

from deduped
