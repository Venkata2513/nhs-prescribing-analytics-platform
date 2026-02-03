select
  f.financial_year,
  g.icb_name,
  f.icb_code,
  p.bnf_presentation_name as presentation_name,
  f.bnf_presentation_code,
  f.unit_of_measure,
  count(distinct f.supplier_id) as supplier_count,
  round(min(f.cost_per_item_gbp), 2) as min_cpi_gbp,
  round(max(f.cost_per_item_gbp), 2) as max_cpi_gbp,
  round(max(f.cost_per_item_gbp) - min(f.cost_per_item_gbp), 2) as spread_cpi_gbp
from analytics.fct_prescribing_snomed_icb f
join analytics.dim_geography g
  on f.geography_id = g.geography_id
join analytics.stg_snomed_presentations p
  on f.financial_year = p.financial_year
 and f.icb_code = p.icb_code
 and f.bnf_presentation_code = p.bnf_presentation_code
where f.cost_per_item_gbp is not null
group by 1,2,3,4,5,6
having count(distinct f.supplier_id) >= 3
   and sum(f.total_items) >= 100
order by spread_cpi_gbp desc
limit 25;
