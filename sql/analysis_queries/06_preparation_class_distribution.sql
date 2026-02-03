select
  f.financial_year,
  c.preparation_class,
  sum(f.total_items) as total_items,
  round(sum(f.total_cost_gbp) / 1000000.0, 2) as total_cost_gbp_m,
  round(
    (sum(f.total_items)::decimal(18,6) /
     nullif(sum(sum(f.total_items)) over (partition by f.financial_year), 0)
    ) * 100, 2
  ) as pct_items,
  round(
    (sum(f.total_cost_gbp)::decimal(18,6) /
     nullif(sum(sum(f.total_cost_gbp)) over (partition by f.financial_year), 0)
    ) * 100, 2
  ) as pct_cost
from analytics.fct_prescribing_snomed_icb f
join analytics.dim_prescribing_context c
  on f.prescribing_context_id = c.prescribing_context_id
group by 1,2
order by f.financial_year, c.preparation_class;
