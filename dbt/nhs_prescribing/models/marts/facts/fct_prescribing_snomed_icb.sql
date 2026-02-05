with base as (

    select
        nullif(trim(financial_year), '') as financial_year_clean,

        icb_code,
        bnf_presentation_code,
        snomed_code,

        bnf_presentation_name,
        unit_of_measure,
        generic_bnf_presentation_code,
        generic_bnf_presentation_name,
        supplier_name,

        bnf_chemical_substance_code,

        preparation_class,
        prescribed_preparation_class,
        advanced_service_type,

        total_items,
        total_quantity,
        total_cost_gbp,

        population_year,
        population

    from {{ ref('stg_snomed_presentations') }}
    where nullif(trim(financial_year), '') is not null
      and icb_code is not null
      and bnf_presentation_code is not null
),

final as (

    select
        -- Surrogate keys derived from cleaned fields

        md5(financial_year_clean) as time_id,
        md5(icb_code)            as geography_id,
        md5(bnf_chemical_substance_code) as bnf_id,

        md5(
            coalesce(cast(preparation_class as varchar), '∅') || '|' ||
            coalesce(cast(prescribed_preparation_class as varchar), '∅') || '|' ||
            coalesce(advanced_service_type, '∅')
        ) as prescribing_context_id,

        md5(coalesce(supplier_name, 'UNKNOWN')) as supplier_id,

        -- natural keys
        financial_year_clean as financial_year,
        icb_code,
        bnf_presentation_code,
        snomed_code,

        -- descriptors
        max(bnf_presentation_name) as bnf_presentation_name,
        max(unit_of_measure) as unit_of_measure,
        max(generic_bnf_presentation_code) as generic_bnf_presentation_code,
        max(generic_bnf_presentation_name) as generic_bnf_presentation_name,
        max(coalesce(supplier_name, 'UNKNOWN')) as supplier_name,

        -- measures
        sum(total_items) as total_items,
        sum(total_quantity) as total_quantity,
        sum(total_cost_gbp) as total_cost_gbp,

        max(population_year) as population_year,
        max(population) as population

    from base
    group by
        financial_year_clean,
        icb_code,
        bnf_presentation_code,
        snomed_code,
        bnf_chemical_substance_code,
        preparation_class,
        prescribed_preparation_class,
        advanced_service_type,
        supplier_name
)

select
    *,
    case when total_items > 0 then total_cost_gbp / total_items else null end as cost_per_item_gbp,
    case when total_quantity > 0 then total_cost_gbp / total_quantity else null end as cost_per_quantity_gbp,
    case when total_items > 0 then total_quantity::decimal(18,6) / total_items else null end as quantity_per_item,
    case when population > 0 then (total_items::decimal(18,6) / population) * 1000 else null end as items_per_1000_population
from final
