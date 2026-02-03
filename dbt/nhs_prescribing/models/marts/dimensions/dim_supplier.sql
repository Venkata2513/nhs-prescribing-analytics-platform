select
    supplier_id,
    supplier_name
from {{ ref('int_dim_supplier') }}
