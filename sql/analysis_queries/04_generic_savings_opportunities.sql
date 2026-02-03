with base as (
  select
    f.financial_year,
    f.bnf_id,
    f.unit_of_measure,
    c.preparation_class,
    c.prescribed_preparation_class,
    sum(f.total_items) as items,
    sum(f.total_cost_gbp) as cost_gbp
  from analytics.fct_prescribing_snomed_icb f
  join analytics.dim_prescribing_context c
    on f.prescribing_context_id = c.prescribing_context_id
  group by 1,2,3,4,5
),

generic_benchmark as (
  select
    financial_year,
    bnf_id,
    unit_of_measure,
    sum(cost_gbp) / nullif(sum(items),0) as generic_cpi
  from base
  where preparation_class = 1
  group by 1,2,3
),

brand as (
  select
    financial_year,
    bnf_id,
    unit_of_measure,
    sum(items) as brand_items,
    sum(cost_gbp) as brand_cost_gbp
  from base
  where prescribed_preparation_class = 3
  group by 1,2,3
)

select
  b.financial_year,
  round(
    sum(
      case
        when g.generic_cpi is not null
         and b.brand_items > 0
         and (b.brand_cost_gbp / b.brand_items) > g.generic_cpi
        then ((b.brand_cost_gbp / b.brand_items) - g.generic_cpi) * b.brand_items
        else 0
      end
    ) / 1000000.0
  , 2) as potential_savings_gbp_m
from brand b
join generic_benchmark g
  on g.financial_year = b.financial_year
 and g.bnf_id = b.bnf_id
 and g.unit_of_measure = b.unit_of_measure
group by 1
order by 1;
