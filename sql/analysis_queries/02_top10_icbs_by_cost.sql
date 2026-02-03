select
  f.financial_year,
  g.icb_name,
  g.icb_code,
  round(sum(f.total_cost_gbp) / 1000000.0, 2) as total_cost_gbp_m,
  round(sum(f.total_items) / 1000000.0, 2) as total_items_m
from analytics.fct_prescribing_chemical_icb f
join analytics.dim_geography g
  on f.geography_id = g.geography_id
group by 1,2,3
order by total_cost_gbp_m desc
limit 10;
