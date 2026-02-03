with src as (

    select
        -- keys / descriptors
        nullif(trim(financial_year), '')                         as financial_year_raw,
        nullif(trim(region_name), '')                            as region_name,
        nullif(trim(region_code), '')                            as region_code,
        nullif(trim(icb_name), '')                               as icb_name,
        nullif(trim(icb_code), '')                               as icb_code,

        nullif(trim(bnf_presentation_code), '')                  as bnf_presentation_code,
        nullif(trim(bnf_presentation_name), '')                  as bnf_presentation_name,

        nullif(trim(snomed_code), '')                            as snomed_code,
        nullif(trim(supplier_name), '')                          as supplier_name,
        nullif(trim(unit_of_measure), '')                        as unit_of_measure,

        nullif(trim(generic_bnf_presentation_code), '')          as generic_bnf_presentation_code,
        nullif(trim(generic_bnf_presentation_name), '')          as generic_bnf_presentation_name,

        nullif(trim(bnf_chemical_substance_code), '')            as bnf_chemical_substance_code,
        nullif(trim(bnf_chemical_substance_name), '')            as bnf_chemical_substance_name,

        nullif(trim(bnf_paragraph_code), '')                     as bnf_paragraph_code,
        nullif(trim(bnf_paragraph_name), '')                     as bnf_paragraph_name,
        nullif(trim(bnf_section_code), '')                       as bnf_section_code,
        nullif(trim(bnf_section_name), '')                       as bnf_section_name,
        nullif(trim(bnf_chapter_code), '')                       as bnf_chapter_code,
        nullif(trim(bnf_chapter_name), '')                       as bnf_chapter_name,

        nullif(trim(advanced_service_type), '')                  as advanced_service_type,

        -- if these are already numeric in raw, try_cast is harmless
        try_cast(preparation_class as integer)                   as preparation_class,
        try_cast(prescribed_preparation_class as integer)        as prescribed_preparation_class,

        -- measures
        try_cast(total_items as bigint)                          as total_items,
        try_cast(total_quantity as bigint)                       as total_quantity,
        try_cast(total_cost_gbp as decimal(18,2))                as total_cost_gbp,
        try_cast(cost_per_item_gbp as decimal(18,4))             as cost_per_item_gbp,
        try_cast(cost_per_quantity_gbp as decimal(18,6))         as cost_per_quantity_gbp,
        try_cast(quantity_per_item as decimal(18,6))             as quantity_per_item,

        try_cast(population_year as integer)                     as population_year,
        try_cast(population as bigint)                           as population,
        try_cast(items_per_1000_population as decimal(18,4))     as items_per_1000_population

    from {{ source('raw', 'snomed_presentations') }}

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

        bnf_presentation_code,
        bnf_presentation_name,

        snomed_code,
        supplier_name,
        unit_of_measure,

        generic_bnf_presentation_code,
        generic_bnf_presentation_name,

        bnf_chemical_substance_code,
        bnf_chemical_substance_name,

        bnf_paragraph_code,
        bnf_paragraph_name,
        bnf_section_code,
        bnf_section_name,
        bnf_chapter_code,
        bnf_chapter_name,

        preparation_class,
        prescribed_preparation_class,
        advanced_service_type,

        total_items,
        total_quantity,
        total_cost_gbp,
        cost_per_item_gbp,
        cost_per_quantity_gbp,
        quantity_per_item,

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
                bnf_presentation_code,
                preparation_class,
                prescribed_preparation_class,
                advanced_service_type,
                supplier_name,
                snomed_code
            order by bnf_presentation_name nulls last
        ) as _rn
    from typed

)

select *
from deduped
where _rn = 1
