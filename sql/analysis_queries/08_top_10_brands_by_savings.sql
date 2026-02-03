with brand as (
  select
    f.financial_year,
    f.bnf_presentation_name,
    f.bnf_id,
    f.unit_of_measure,
    sum(f.total_items) as brand_items,
    sum(f.total_cost_gbp) as brand_cost_gbp
  from analytics.fct_prescribing_snomed_icb f
  join analytics.dim_prescribing_context c
    on f.prescribing_context_id = c.prescribing_context_id
  where c.preparation_class = 3
    and f.unit_of_measure is not null
    and f.bnf_id is not null
  group by 1,2,3,4
),
generic_benchmark as (
  select
    f.financial_year,
    f.bnf_id,
    f.unit_of_measure,
    case when sum(f.total_items) > 0 then sum(f.total_cost_gbp) / sum(f.total_items) end as generic_cpi_wavg
  from analytics.fct_prescribing_snomed_icb f
  join analytics.dim_prescribing_context c
    on f.prescribing_context_id = c.prescribing_context_id
  where c.preparation_class = 1
    and f.unit_of_measure is not null
    and f.bnf_id is not null
  group by 1,2,3
)
select
  b.financial_year,
b.bnf_presentation_name,
   sum( case
      when g.generic_cpi_wavg is not null and b.brand_items > 0
      then ((b.brand_cost_gbp / b.brand_items) - g.generic_cpi_wavg) * b.brand_items
      else 0
    end) as potential_savings_gbp_m
from brand b
left join generic_benchmark g
  on g.financial_year = b.financial_year
 and g.bnf_id = b.bnf_id
 and g.unit_of_measure = b.unit_of_measure
group by 1,2
order by 1,3 desc
limit 10;