with src as (
    select
        nullif(trim(supplier_name), '') as supplier_name
    from {{ ref('stg_snomed_presentations') }}
),

final as (
    select distinct
        coalesce(supplier_name, 'UNKNOWN') as supplier_name
    from src
)

select
    md5(supplier_name) as supplier_id,
    supplier_name
from final
