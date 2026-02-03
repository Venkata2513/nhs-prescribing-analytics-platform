select
    time_id,
    financial_year,
    fy_start_year,
    fy_end_year
from {{ ref('int_dim_time') }}
