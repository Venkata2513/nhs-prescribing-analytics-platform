select
  financial_year,
  round(sum(total_cost_gbp) / 1000000000.0, 2) as total_cost_gbp_billions,
  round(sum(total_items) / 1000000000.0, 3) as total_items_billions,
  round(sum(total_cost_gbp) / nullif(sum(total_items), 0), 2) as avg_cost_per_item_gbp
from analytics.fct_prescribing_chemical_icb
group by 1
order by 1;
