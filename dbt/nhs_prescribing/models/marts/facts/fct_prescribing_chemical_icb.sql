with base as (

    select
        nullif(trim(financial_year), '') as financial_year_clean,
        icb_code,
        bnf_chemical_substance_code,
        total_items,
        total_cost_gbp,
        population_year,
        population
    from {{ ref('stg_chemical_substances') }}
    where nullif(trim(financial_year), '') is not null
      and icb_code is not null
      and bnf_chemical_substance_code is not null

),

final as (

    select
        md5(financial_year_clean) as time_id,
        md5(icb_code) as geography_id,
        md5(bnf_chemical_substance_code) as bnf_id,

        financial_year_clean as financial_year,
        icb_code,
        bnf_chemical_substance_code,

        sum(total_items) as total_items,
        sum(total_cost_gbp) as total_cost_gbp,

        max(population_year) as population_year,
        max(population) as population

    from base
    group by
        financial_year_clean,
        icb_code,
        bnf_chemical_substance_code

)

select
    *,
    case when total_items > 0 then total_cost_gbp / total_items else null end as cost_per_item_gbp,
    case when population > 0 then (total_items::decimal(18,6) / population) * 1000 else null end as items_per_1000_population
from final
