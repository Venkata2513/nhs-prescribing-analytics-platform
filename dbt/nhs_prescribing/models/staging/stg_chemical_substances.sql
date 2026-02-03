with src as (

    select
        -- keys / descriptors
        nullif(trim(financial_year), '')                         as financial_year_raw,
        nullif(trim(region_name), '')                            as region_name,
        nullif(trim(region_code), '')                            as region_code,
        nullif(trim(icb_name), '')                               as icb_name,
        nullif(trim(icb_code), '')                               as icb_code,

        nullif(trim(bnf_chemical_substance_code), '')            as bnf_chemical_substance_code,
        nullif(trim(bnf_chemical_substance_name), '')            as bnf_chemical_substance_name,

        nullif(trim(bnf_paragraph_code), '')                     as bnf_paragraph_code,
        nullif(trim(bnf_paragraph_name), '')                     as bnf_paragraph_name,
        nullif(trim(bnf_section_code), '')                       as bnf_section_code,
        nullif(trim(bnf_section_name), '')                       as bnf_section_name,
        nullif(trim(bnf_chapter_code), '')                       as bnf_chapter_code,
        nullif(trim(bnf_chapter_name), '')                       as bnf_chapter_name,

        try_cast(total_items as bigint)                          as total_items,
        try_cast(total_cost_gbp as decimal(18,2))                as total_cost_gbp,
        try_cast(cost_per_item_gbp as decimal(18,4))             as cost_per_item_gbp,

        try_cast(population_year as integer)                     as population_year,
        try_cast(population as bigint)                           as population,
        try_cast(items_per_1000_population as decimal(18,4))     as items_per_1000_population

    from {{ source('raw', 'chemical_substances') }}

),

typed as (

    select
        nullif(trim(
  case
      when regexp_substr(trim(financial_year_raw), '[0-9]{4}/[0-9]{4}') is not null
then regexp_substr(trim(financial_year_raw), '[0-9]{4}/[0-9]{4}')
   else null
    end 
), '') as financial_year,

        region_name,
        region_code,
        icb_name,
        icb_code,

        bnf_chemical_substance_code,
        bnf_chemical_substance_name,

        bnf_paragraph_code,
        bnf_paragraph_name,
        bnf_section_code,
        bnf_section_name,
        bnf_chapter_code,
        bnf_chapter_name,

        total_items,
        total_cost_gbp,
        cost_per_item_gbp,

        population_year,
        population,
        items_per_1000_population

    from src
where regexp_substr(trim(financial_year_raw), '[0-9]{4}/[0-9]{4}') is not null

),

deduped as (

    select
        *,
        row_number() over (
            partition by
                financial_year,
                icb_code,
                bnf_chemical_substance_code
            order by bnf_chemical_substance_name nulls last
        ) as _rn
    from typed

)

select *
from deduped
where _rn = 1
