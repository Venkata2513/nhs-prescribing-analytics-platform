select
    geography_id,
    icb_code,
    icb_name,
    region_code,
    region_name
from {{ ref('int_dim_geography') }}
