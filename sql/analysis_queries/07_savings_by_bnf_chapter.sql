with brand as (
  select
    f.financial_year,
    b.bnf_id,
    b.bnf_chapter_name,
    b.bnf_section_name,
    f.unit_of_measure,
    sum(f.total_items) as brand_items,
    sum(f.total_cost_gbp) as brand_cost_gbp
  from analytics.fct_prescribing_snomed_icb f
  join analytics.dim_bnf b
    on f.bnf_id = b.bnf_id
  join analytics.dim_prescribing_context c
    on f.prescribing_context_id = c.prescribing_context_id
  where c.preparation_class = 3
    and f.unit_of_measure is not null
  group by 1,2,3,4,5
),

generic_benchmark as (
  select
    f.financial_year,
    f.bnf_id,
    f.unit_of_measure,
    -- choose benchmark method:
    -- 1) weighted avg cost-per-item (stable)
    case when sum(f.total_items) > 0 then sum(f.total_cost_gbp) / sum(f.total_items) end as generic_cpi_wavg,

    -- 2) min observed cost-per-item (aggressive, “best case”)
    min(f.cost_per_item_gbp) as generic_cpi_min
  from analytics.fct_prescribing_snomed_icb f
  join analytics.dim_prescribing_context c
    on f.prescribing_context_id = c.prescribing_context_id
  where c.preparation_class = 1
    and f.unit_of_measure is not null
    and f.cost_per_item_gbp is not null
    and f.bnf_id is not null
  group by 1,2,3
),

savings as (
  select
    b.financial_year,
    b.bnf_chapter_name,
    b.bnf_section_name,
    sum(
      case
        when g.generic_cpi_wavg is not null and b.brand_items > 0
        then ((b.brand_cost_gbp / b.brand_items) - g.generic_cpi_wavg) * b.brand_items
        else 0
      end
    ) as potential_savings_gbp
  from brand b
  left join generic_benchmark g
    on g.financial_year = b.financial_year
   and g.unit_of_measure = b.unit_of_measure
   and g.bnf_id = b.bnf_id
  group by 1,2,3
)

select
  financial_year,
  bnf_chapter_name,
  bnf_section_name,
  round(potential_savings_gbp/1000000.0, 2) as potential_savings_gbp_m
from savings
where potential_savings_gbp > 1000
order by potential_savings_gbp desc;
